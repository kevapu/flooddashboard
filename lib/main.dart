import 'package:flutter/material.dart';

import 'addordeletedrain.dart';
import 'drainmapscreen.dart';
import 'homescreen.dart';
import 'monitorscreen.dart';
import 'notificationscreen.dart';
import 'sidewidget.dart';
import 'troublescorescreen.dart';


void main() {
  runApp(const DrainDashboardApp());
}

class DrainDashboardApp extends StatelessWidget {
  const DrainDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flood Dashboard',
      theme: ThemeData(
       primarySwatch: Colors.blue,
      ),
      home: const MainScreen()
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    const HomeScreen(),
    const MonitorScreen(),
    const AddDeleteDrainScreen(),
    const TroubleScoreScreen(),
    const DrainMapScreen(),
    const  NotificationsScreen(),
  ];

  // Corresponding titles
  final List<String> _titles = [
    'Home',
    'Monitor',
    'Add/Delete Drain',
    'Trouble Score',
    'Drain Map',
    'Notifications',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      drawer: AppDrawer(
        currentScreen: _titles[_selectedIndex],
      ),
      body: _screens[_selectedIndex],
    );
  }
}
