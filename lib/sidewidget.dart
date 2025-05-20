import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'troublescorescreen.dart';
import 'homescreen.dart';
import 'monitorscreen.dart';
import 'notificationscreen.dart';
import 'addordeletedrain.dart';
import 'drainmapscreen.dart';

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
          backgroundColor: const Color.fromARGB(255, 38, 201, 242),
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
            foregroundColor: const Color.fromARGB(255, 75, 218, 254),
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
          fillColor: const Color.fromARGB(255, 60, 188, 252),
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