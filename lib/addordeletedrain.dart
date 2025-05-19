import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'sidewidget.dart';

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
                color: primaryColor
              ),
            ),
          ),
        ),
      ),
    );
  }
}
