import 'package:flutter/material.dart';
import 'rain.dart'; // Make sure this file exists and is correct

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen blue background with white rain
          Positioned.fill(
            child: Container(
              color: Colors.blue, // Full-screen blue background
              child: Transform.rotate(
                angle: 3.14159 / 4, // Rotate 45 degrees
                child: ParallaxRain(
                  dropColors: [Colors.white], // White raindrops
                  trail: true,
                ),
              ),
            ),
          ),

          // Foreground content filling full screen
          Positioned.fill(
            child: child,
          ),
        ],
      ),
    );
  }
}
