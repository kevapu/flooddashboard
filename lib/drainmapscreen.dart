import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'sidewidget.dart';
import '../services/firebase_service.dart';  // ADD THIS
import '../models/region_risk_model.dart';   // ADD THIS

class DrainMapScreen extends StatefulWidget {
  const DrainMapScreen({super.key});

  @override
  State<DrainMapScreen> createState() => _DrainMapScreenState();
}

class _DrainMapScreenState extends State<DrainMapScreen> {
  Map<String, dynamic> _drainMap = {}; // Initialize as empty map
  Set<Polyline> _drainPolylines = {};
  Set<Marker> _markers = {};
  Set<Polygon> _regionPolygons = {}; // ADD THIS for region overlays
  TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  bool _loading = true;
  RegionAnalysis? _regionAnalysis; // ADD THIS

  @override
  void initState() {
    super.initState();
    loadDrainData();
  }

  Future<void> loadDrainData() async {
    setState(() {
      _loading = true;
    });

    try {
      final String jsonString =
          await rootBundle.loadString('assets/drain_topology.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      setState(() {
        _drainMap = data;
        _drainPolylines = buildPolylines(data);
        _markers = buildMarkers(data);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load drain data')),
        );
      }
      print('Error loading drain data: $e');
    }
  }

  Set<Polyline> buildPolylines(Map<String, dynamic> drainMap) {
    Set<Polyline> polylines = {};
    Set<String> processed = {};
    int polylineId = 1;
    
    drainMap.forEach((drainId, drainData) {
      final lat = drainData['lat']?.toDouble();
      final lon = drainData['lon']?.toDouble();
      if (lat == null || lon == null) return;

      final start = LatLng(lat, lon);
      final connections = drainData['connected_to'];

      if (connections is List) {
        for (final neighbor in connections) {
          if (neighbor is! String) continue;

          final connectionKey = [drainId, neighbor]..sort();
          final key = connectionKey.join('_');
          if (processed.contains(key)) return;

          final neighborData = drainMap[neighbor];
          if (neighborData == null) return;

          final endLat = neighborData['lat']?.toDouble();
          final endLon = neighborData['lon']?.toDouble();
          if (endLat == null || endLon == null) return;

          final end = LatLng(endLat, endLon);

          polylines.add(
            Polyline(
              polylineId: PolylineId('poly_$polylineId'),
              color: secondaryColor,
              width: 8,
              points: [start, end],
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              patterns: [PatternItem.dash(15), PatternItem.gap(10)],
            ),
          );

          processed.add(key);
          polylineId++;
        }
      }
    });

    return polylines;
  }

  Set<Marker> buildMarkers(Map<String, dynamic> drainMap) {
    Set<Marker> markers = {};

    drainMap.forEach((drainId, data) {
      if (data['lat'] is double && data['lon'] is double) {
        // Get marker color based on individual drain status
        Color markerColor = _getMarkerColorForDrain(drainId);
        
        markers.add(
          Marker(
            markerId: MarkerId(drainId),
            position: LatLng(data['lat'], data['lon']),
            infoWindow: InfoWindow(
              title: drainId,
              snippet: _getDrainStatusText(drainId),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(markerColor)),
          ),
        );
      }
    });

    return markers;
  }

  // ADD THIS: Build region polygons based on risk analysis
  Set<Polygon> buildRegionPolygons(RegionAnalysis regionAnalysis) {
    Set<Polygon> polygons = {};
    
    for (RegionRisk region in regionAnalysis.regions) {
      List<LatLng> regionPoints = [];
      
      // Get coordinates for all drains in this region
      for (String drainId in region.nodes) {
        final drainData = _drainMap[drainId];
        if (drainData != null && 
            drainData['lat'] is double && 
            drainData['lon'] is double) {
          regionPoints.add(LatLng(drainData['lat'], drainData['lon']));
        }
      }
      
      if (regionPoints.length >= 3) {
        // Create a convex hull or simple polygon around the points
        List<LatLng> polygonPoints = _createPolygonFromPoints(regionPoints);
        
        polygons.add(
          Polygon(
            polygonId: PolygonId(region.regionId),
            points: polygonPoints,
            fillColor: region.getRiskColor().withOpacity(0.3),
            strokeColor: region.getRiskColor(),
            strokeWidth: 2,
          ),
        );
      }
    }
    
    return polygons;
  }

  // ADD THIS: Create a polygon around region points
  List<LatLng> _createPolygonFromPoints(List<LatLng> points) {
    if (points.length < 3) return points;
    
    // Simple approach: create a bounding polygon
    // You can implement a more sophisticated convex hull algorithm if needed
    double minLat = points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat = points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    double minLng = points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng = points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);
    
    // Add some padding
    double padding = 0.002; // Adjust this value as needed
    
    return [
      LatLng(minLat - padding, minLng - padding),
      LatLng(maxLat + padding, minLng - padding),
      LatLng(maxLat + padding, maxLng + padding),
      LatLng(minLat - padding, maxLng + padding),
    ];
  }

  // ADD THIS: Get marker color based on drain status
  Color _getMarkerColorForDrain(String drainId) {
    if (_regionAnalysis?.individualDrains[drainId] != null) {
      switch (_regionAnalysis!.individualDrains[drainId]) {
        case 'overflowing':
          return Colors.red;
        case 'stagnant':
          return Colors.orange;
        case 'normal':
          return Colors.green;
        default:
          return Colors.blue;
      }
    }
    return Colors.blue; // default
  }

  // ADD THIS: Convert color to marker hue
  double _getMarkerHue(Color color) {
    if (color == Colors.red) return BitmapDescriptor.hueRed;
    if (color == Colors.orange) return BitmapDescriptor.hueOrange;
    if (color == Colors.green) return BitmapDescriptor.hueGreen;
    return BitmapDescriptor.hueAzure; // default
  }

  // ADD THIS: Get status text for drain
  String _getDrainStatusText(String drainId) {
    String status = _regionAnalysis?.individualDrains[drainId] ?? 'unknown';
    return 'Status: ${status.toUpperCase()}';
  }

  void _searchDrain() {
    final input = _searchController.text.trim();
    if (!input.startsWith('drain_')) {
      final idNumber = input.padLeft(3, '0');
      final formattedId = 'drain_$idNumber';
      _animateToDrain(formattedId);
    } else {
      _animateToDrain(input);
    }
  }

  void _animateToDrain(String drainId) async {
    final drainData = _drainMap[drainId];
    if (drainData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Drain ID $drainId not found')),
      );
      return;
    }
    final lat = drainData['lat']?.toDouble();
    final lon = drainData['lon']?.toDouble();
    if (lat == null || lon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid coordinates for $drainId')),
      );
      return;
    }
    final target = LatLng(lat, lon);
    if (_mapController != null) {
      for (double zoom = 15; zoom <= 18; zoom += 0.5) {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: zoom),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  // ADD THIS: Build legend widget
  Widget _buildLegend() {
    return Positioned(
      bottom: 100,
      left: 16,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Risk Levels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 8),
            _buildLegendItem('High Flood Risk', Colors.red),
            _buildLegendItem('Potential Blockage', Colors.orange),
            _buildLegendItem('Low Risk', Colors.green),
            SizedBox(height: 8),
            Text('Individual Drains', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 4),
            _buildLegendItem('Overflowing', Colors.red),
            _buildLegendItem('Stagnant', Colors.orange),
            _buildLegendItem('Normal', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  // ADD THIS: Build risk summary panel
  Widget _buildRiskSummary() {
    if (_regionAnalysis == null) return Container();

    int highRisk = _regionAnalysis!.regions.where((r) => r.riskLevel == 'High Flood Risk').length;
    int blockageRisk = _regionAnalysis!.regions.where((r) => r.riskLevel == 'Potential Blockage Risk').length;
    int lowRisk = _regionAnalysis!.regions.where((r) => r.riskLevel == 'Low Risk').length;

    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Risk Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 6),
            Text('High Risk: $highRisk', style: TextStyle(fontSize: 12, color: Colors.red)),
            Text('Blockage Risk: $blockageRisk', style: TextStyle(fontSize: 12, color: Colors.orange)),
            Text('Low Risk: $lowRisk', style: TextStyle(fontSize: 12, color: Colors.green)),
            SizedBox(height: 4),
            Text(
              'Updated: ${_regionAnalysis!.lastUpdated.toString().substring(11, 16)}',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentScreen: 'Drain Map'),
      appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text(
            'Drain Network Map',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 6,
          shadowColor: primaryColor.withOpacity(0.4),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(66),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      elevation: 4,
                      shadowColor: Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Drain ID (001-060)',
                          prefixIcon: const Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _searchDrain(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _searchDrain,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.lightBlue.shade700,
                    ),
                    child: const Text('Go'),
                  ),
                ],
              ),
            ),
          ),
        ),

      // MODIFIED: Added StreamBuilder for real-time updates
      body: StreamBuilder<RegionAnalysis?>(
        stream: FirebaseService.getRegionAnalysisStream(),
        builder: (context, snapshot) {
          // Update region analysis when new data arrives
          if (snapshot.hasData) {
            _regionAnalysis = snapshot.data;
            // Rebuild markers and polygons with new data
            if (_drainMap.isNotEmpty) {
              _markers = buildMarkers(_drainMap);
              _regionPolygons = buildRegionPolygons(_regionAnalysis!);
            }
          }

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.05),
                      secondaryColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(3.1400, 101.6880),
                          zoom: 15,
                        ),
                        markers: _markers,
                        polylines: _drainPolylines,
                        polygons: _regionPolygons, // ADD THIS
                        onMapCreated: (controller) {
                          _mapController = controller;
                        },
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        mapToolbarEnabled: false,
                        compassEnabled: true,
                      ),
              ),
              // ADD THESE: Overlay widgets
              _buildLegend(),
              _buildRiskSummary(),
            ],
          );
        },
      ), // MODIFIED: End of StreamBuilder

      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        elevation: 6,
        tooltip: 'Center Map',
        onPressed: () {
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                const CameraPosition(
                  target: LatLng(3.1400, 101.6880),
                  zoom: 15,
                ),
              ),
            );
          }
        },
        child: const Icon(Icons.my_location, size: 28),
      ),
    );
  }
}