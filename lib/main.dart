import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'sidewidget.dart';

void main() {
  runApp(DrainTrackerApp());
}

class DrainTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drain Tracker',
      theme: ThemeData(
        primarySwatch: const Color.fromARGB(255, 92, 180, 251),
      ),
      home: DrainTrackerHome(),
    );
  }
}