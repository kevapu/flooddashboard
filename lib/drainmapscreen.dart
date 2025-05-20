import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'sidewidget.dart';
import 'notificationscreen.dart';


class DrainMapScreen extends StatefulWidget {
  const DrainMapScreen({super.key});

  @override
  State<DrainMapScreen> createState() => _DrainMapScreenState();
}

class _DrainMapScreenState extends State<DrainMapScreen> {
  Map<String, dynamic> _drainMap = {}; // Initialize as empty map
  Set<Polyline> _drainPolylines = {};
  Set<Marker> _markers = {};
  TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  bool _loading = true;

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
        markers.add(
          Marker(
            markerId: MarkerId(drainId),
            position: LatLng(data['lat'], data['lon']),
            infoWindow: InfoWindow(
              title: drainId,
              snippet: 'Tap for details',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          ),
        );
      }
    });

    return markers;
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

  void _goToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentScreen: 'Drain Map'),
      appBar: AppBar(
          backgroundColor: Colors.lightBlue, // Sky blue background
          title: const Text(
            'Drain Network Map',
            style: TextStyle(
              color: Colors.white,         // Title in white
              fontSize: 22,                // Increased font size
              fontWeight: FontWeight.bold, // Optional: make it bold
            ),
          ),
          centerTitle: true,
          elevation: 6,
          shadowColor: primaryColor.withOpacity(0.4), // Corrected method name
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
                      backgroundColor: Colors.lightBlue.shade700, // optional: match AppBar
                    ),
                    child: const Text('Go'),
                  ),
                ],
              ),
            ),
          ),
        ),

      body: Stack(
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
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    mapToolbarEnabled: false,
                    compassEnabled: true,
                  ),
          ),
          Positioned(
            bottom: 14,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => _goToNotifications(context),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor, accentColor.withValues(alpha: 0.9)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha:0.65),
                      offset: const Offset(0, 3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.notification_important,
                        color: Colors.white, size: 22),
                    const SizedBox(width: 14),
                    const Text(
                      'VIEW PRIORITY NOTIFICATIONS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
