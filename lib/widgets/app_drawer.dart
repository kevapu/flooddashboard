import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/home_screen.dart';
import '../screens/drain_map_screen.dart';
import '../screens/monitor_screen.dart';
import '../screens/add_delete_drain_screen.dart';
import '../screens/trouble_score_screen.dart';
import '../screens/notifications_screen.dart';
import '../themes/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final String currentScreen;

  const AppDrawer({super.key, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    Widget buildTile(String title, IconData icon, Widget destination) {
      final bool isSelected = currentScreen == title;
      final primaryColor = AppTheme.primaryColor;

      return Material(
        color: isSelected ? primaryColor.withOpacity(0.15) : Colors.transparent,
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
          hoverColor: primaryColor.withOpacity(0.1),
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
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.secondaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.4),
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
                    const Shadow(
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