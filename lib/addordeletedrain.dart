import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sidewidget.dart';
import 'animatedbackground.dart';

final Color primaryColor = Color.fromARGB(255, 69, 87, 244);
final Color dropdownColor = Color(0xFFB0E0E6);

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

  void _onDrainChange(String? value) {
    setState(() {
      selectedDrain = value;
    });
  }

  void _onReportEmergency() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Emergency reported for $selectedDrain')),
    );
  }

  bool get _isEmergency {
    if (selectedDrain == null) return false;

    // Emergency conditions:
    if (selectedDrain == 'Drain 006') {
      // Battery low & offline → emergency
      return true;
    }
    if (selectedDrain == 'Drain 001') {
      // Battery 78%, online → no emergency
      return false;
    }

    // Default no emergency
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool showSpecification =
        selectedDrain == 'Drain 001' || selectedDrain == 'Drain 006';

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
      body: Center(
        child: BackgroundWrapper(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown card
                  Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Please Select a Drain',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: selectedDrain,
                            hint: const Text(
                              'Select a Drain',
                              style: TextStyle(color: Colors.grey),
                            ),
                            items: List.generate(
                              6,
                              (index) => DropdownMenuItem(
                                value: 'Drain 00${index + 1}',
                                child: Text('Drain 00${index + 1}'),
                              ),
                            ),
                            onChanged: _onDrainChange,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: dropdownColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            dropdownColor: dropdownColor,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            iconEnabledColor: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Specification panel - slide in when Drain 001 or Drain 006 selected
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: showSpecification
                        ? SpecificationPanel(selectedDrain: selectedDrain!)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _isEmergency
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16, right: 16),
              child: FloatingActionButton.extended(
                onPressed: _onReportEmergency,
                backgroundColor: Colors.red,
                icon: const Icon(Icons.report_problem),
                label: Text(
                  'Report Emergency',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class SpecificationPanel extends StatelessWidget {
  final String selectedDrain;
  SpecificationPanel({Key? key, required this.selectedDrain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDrain001 = selectedDrain == 'Drain 001';
    final bool isDrain006 = selectedDrain == 'Drain 006';

    // Setup the details per drain:
    final String location = 'Bandar Sri Conor';
    final String status = isDrain001 ? 'online' : 'offline';
    final double batteryLevel = isDrain001 ? 0.78 : 0.15; // 78% or 15%
    final String component = isDrain001
        ? 'Rotary Flowmeter Sensor'
        : (isDrain006 ? 'Resistive float sensor' : '');

    return Card(
      key: ValueKey(selectedDrain),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Specification',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: batteryLevel,
                        strokeWidth: 8,
                        color: batteryLevel < 0.25 ? Colors.red : primaryColor,
                        backgroundColor: Colors.grey.shade300,
                      ),
                      Center(
                        child: Text(
                          '${(batteryLevel * 100).toInt()}%',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color:
                                batteryLevel < 0.25 ? Colors.red : primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    'Battery Status',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _infoRow(component, Icons.settings),
            const SizedBox(height: 12),
            _infoRow('Location: $location', Icons.location_on),
            const SizedBox(height: 12),
            _infoRow('Status: $status', Icons.error_outline,
                iconColor:
                    status == 'offline' ? Colors.red : Colors.green.shade600),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, IconData icon, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? primaryColor),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
