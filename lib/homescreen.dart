import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sidewidget.dart';
import 'notificationscreen.dart';
import 'animatedbackground.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = _getTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _getTime();
      });
    });
  }

  String _getTime() {
    final now = DateTime.now();
    return DateFormat('hh:mm a').format(now);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
      drawer: const AppDrawer(currentScreen: 'Home'),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 6,
        centerTitle: true,
        shadowColor: Colors.blue.withOpacity(0.4),
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          BackgroundWrapper(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top white welcome container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Welcome to Urban Pulse',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Girl and text bubble side by side
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text bubble
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                '"Redefining Urban Intelligence. Seamlessly monitor, track, and manage drainage systems with precision."',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          const SizedBox(width: 9),

                          // Girl image
                          Image.asset(
                            'assets/girl.png',
                            width: 450,
                            height: 450,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),

                    // Optional old small time container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      
                    ),
                  ],
                ),
              ),
            ),
          ),

          // New time at bottom-left
          Positioned(
            bottom: 16,
            left: 50,
            child: Text(
              _currentTime,
              style: GoogleFonts.poppins(
                fontSize: 60,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
