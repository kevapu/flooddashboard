import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sidewidget.dart';
import 'animatedbackground.dart';
import 'drainmonitortable.dart'; 
import 'calender.dart';
import 'ticketingsystem.dart';
import 'notificationmaintenace.dart';

final Color primaryColor = const Color.fromARGB(255, 69, 87, 244);
final Color dropdownColor = const Color(0xFFB0E0E6);

class AddDeleteDrainScreen extends StatefulWidget {
  final String? initialSelectedDrain;

  const AddDeleteDrainScreen({super.key, this.initialSelectedDrain});

  @override
  State<AddDeleteDrainScreen> createState() => _AddDeleteDrainScreenState();
}

class _AddDeleteDrainScreenState extends State<AddDeleteDrainScreen> {
  String? selectedDrain;

  @override
  void initState() {
    super.initState();
    selectedDrain = widget.initialSelectedDrain;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentScreen: 'Add/Delete Drain'),
      appBar: AppBar(
        title: const Text('Status Maintenance'),
        centerTitle: true,
        elevation: 6,
        backgroundColor: Colors.lightBlue,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: BackgroundWrapper(
        child: Padding(
          padding: const EdgeInsets.all(15.0), // approx 0.5 cm
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;

              return Column(
                children: [
                  // Top part (60%)
                  SizedBox(
                    height: height * 0.6,
                    child: Row(
                      children: [
                        // Top left (60%)
                        Expanded(
                          flex: 6,
                          child: Container(
                            margin: const EdgeInsets.only(right: 7.5), // half of 15
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 69, 68, 68),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: 7.5),
                              child: const DrainMonitorTable(),
                            ),
                          ),
                        ),
                        // Top right (40%)
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: const EdgeInsets.only(left: 7.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 700,  // or your desired size
                                height: 600,
                                child: MaintenaCalendar2027(),
                              ),
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Bottom part (40%)
                  SizedBox(
                    height: height * 0.4 - 15, // subtract spacing
                    child: Row(
                      children: [
                        // Bottom left (70%)
                        Expanded(
                          flex: 7,
                          child: Container(
                            margin: const EdgeInsets.only(right: 7.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                           
                              child:MaintenanceTicketingSection(),
                            
                          ),
                        ),
                        // Bottom right (30%)
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.only(left: 7.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          
                              
                              child: NotificationSection(),
                            
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
