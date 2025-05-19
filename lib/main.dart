import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

final Color primaryColor = Color(0xFF0062BD);
final Color secondaryColor = Color(0xFF00BFA6);
final Color accentColor = Color(0xFFFF6F61);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drain Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(
              primary: primaryColor,
              secondary: secondaryColor,
              tertiary: accentColor,
            ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 5,
          shadowColor: primaryColor.withValues(alpha: 0.5),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final String currentScreen;

  const AppDrawer({super.key, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    Widget buildTile(String title, IconData icon, Widget destination) {
      final bool isSelected = currentScreen == title;
      return Material(
        color: isSelected ? primaryColor.withValues(alpha: 0.15) : Colors.transparent,
        child: ListTile(
          leading: Icon(icon,
              color: isSelected ? primaryColor : Colors.grey.shade700,
              size: 26),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? primaryColor : Colors.grey.shade800,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          horizontalTitleGap: 8,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          onTap: () {
            if (isSelected) {
              Navigator.pop(context);
              return;
            }
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => destination,
                transitionsBuilder:
                    (_, animation, __, child) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                transitionDuration: const Duration(milliseconds: 350),
              ),
            );
          },
          hoverColor: primaryColor.withValues(alpha:0.1),
        ),
      );
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 140,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Text(
                'Drain Tracker',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(1, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  buildTile('Home', Icons.home_outlined, const HomeScreen()),
                  buildTile('Drain Map', Icons.map_outlined, const DrainMapScreen()),
                  buildTile('Monitor', Icons.monitor_outlined, const MonitorScreen()),
                  buildTile('Add/Delete Drain', Icons.edit_outlined, const AddDeleteDrainScreen()),
                  buildTile('Trouble Score', Icons.bar_chart_outlined, const TroubleScoreScreen()),
                  buildTile('Notifications', Icons.notifications_outlined, const NotificationsScreen()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '© 2024 Drain Tracker',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _goToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentScreen: 'Home'),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        elevation: 6,
        shadowColor: primaryColor.withValues(alpha: 0.4),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/background.jpg"), fit: BoxFit.cover),
              gradient: LinearGradient(
                colors: [
                  primaryColor.withValues(alpha: 0.1),
                  secondaryColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Welcome to UrbanPulse',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: primaryColor.darken(0.1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Redefining Urban Intelligence. Seamlessly monitor, track, and manage drainage systems with precision.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 14,
            right: 14,
            child: GestureDetector(
              onTap: () => _goToNotifications(context),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor, accentColor.withValues(alpha: 0.85)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.6),
                      offset: const Offset(0, 3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.notification_important, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    const Text(
                      'VIEW PRIORITY NOTIFICATIONS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 1),
                            blurRadius: 3,
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
    );
  }
}

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
        title: const Text('Drain Network Map'),
        centerTitle: true,
        elevation: 6,
        shadowColor: primaryColor.withValues(alpha: 0.4),
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

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentScreen: 'Monitor'),
      appBar: AppBar(
        title: const Text('Monitor'),
        centerTitle: true,
        elevation: 6,
        shadowColor: primaryColor.withValues(alpha:0.4),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Monitor Screen',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor.darken(0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddDeleteDrainScreen extends StatelessWidget {
  const AddDeleteDrainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentScreen: 'Add/Delete Drain'),
      appBar: AppBar(
        title: const Text('Add/Delete Drain'),
        centerTitle: true,
        elevation: 6,
        shadowColor: primaryColor.withValues(alpha:0.4),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Add/Delete Drain Screen',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor.darken(0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TroubleScoreScreen extends StatelessWidget {
  const TroubleScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentScreen: 'Trouble Score'),
      appBar: AppBar(
        title: const Text('Trouble Score'),
        centerTitle: true,
        elevation: 6,
        shadowColor: primaryColor.withValues(alpha:0.4),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Trouble Score Screen',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor.darken(0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentScreen: 'Notifications'),
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 6,
        shadowColor: primaryColor.withValues(alpha:0.4),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Notifications Screen',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor.darken(0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension to darken a color by [amount] (0.0 to 1.0)
extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
