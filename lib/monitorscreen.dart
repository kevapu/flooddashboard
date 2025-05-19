import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_background/animated_background.dart';
import 'package:fl_chart/fl_chart.dart';
import 'sidewidget.dart';

final Color primaryColor = Color.fromARGB(255, 69, 87, 244);
final Color secondaryColor = Color(0xFF87CEFA);
final Color dropdownColor = Color(0xFFB0E0E6);

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen>
    with TickerProviderStateMixin {
  String? selectedDrain;  // Changed to nullable

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (selectedDrain != null && isSupportedDrain(selectedDrain!)) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isSupportedDrain(String drain) {
    // For drain 001 to 004 show charts
    return ['Drain 001', 'Drain 002', 'Drain 003', 'Drain 004'].contains(drain);
  }

  void _onDrainChange(String? value) {
    if (value != null && isSupportedDrain(value)) {
      _controller.forward(from: 0.0);
    } else {
      _controller.reset();
    }
    setState(() {
      selectedDrain = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentScreen: 'Monitor'),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 110, 149, 248),
        elevation: 6,
        centerTitle: true,
        shadowColor: primaryColor.withOpacity(0.4),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Monitor',
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            spawnMaxRadius: 50,
            spawnMinSpeed: 15,
            spawnMaxSpeed: 40,
            particleCount: 70,
            spawnOpacity: 0.3,
            baseColor: Colors.blueAccent,
          ),
        ),
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
                          hint: Text(
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                const SizedBox(height: 40),

                // Slide-in chart row for Drain 001 to 004
                if (selectedDrain != null && isSupportedDrain(selectedDrain!))
                  SlideTransition(
                    position: _slideAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(205, 231, 158, 254),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Center(
                                child: Text("Flowrate vs Time", style: chartTitleStyle),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 300,
                                height: 300,
                                child: LineChart(
                                  sampleChartData(selectedDrain!, "Flowrate"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(205, 231, 158, 254),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Center(
                                child: Text("Water Height vs Time", style: chartTitleStyle),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 300,
                                height: 300,
                                child: LineChart(
                                  sampleChartData(selectedDrain!, "Water Height"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(205, 231, 158, 254),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Center(
                                child: Text("Rain Rate vs Time", style: chartTitleStyle),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 300,
                                height: 300,
                                child: LineChart(
                                  sampleChartData(selectedDrain!, "Rain Rate"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final TextStyle chartTitleStyle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );

  LineChartData sampleChartData(String drain, String yAxisLabel) {
    // Provide different dummy data for different drains
    List<FlSpot> spots;

    switch (drain) {
      case 'Drain 001':
        spots = [
          FlSpot(0, 5),
          FlSpot(1, 10),
          FlSpot(2, 6),
          FlSpot(3, 14),
          FlSpot(4, 11),
          FlSpot(5, 17),
        ];
        break;
      case 'Drain 002':
        spots = [
          FlSpot(0, 3),
          FlSpot(1, 8),
          FlSpot(2, 7),
          FlSpot(3, 10),
          FlSpot(4, 9),
          FlSpot(5, 12),
        ];
        break;
      case 'Drain 003':
        spots = [
          FlSpot(0, 6),
          FlSpot(1, 7),
          FlSpot(2, 9),
          FlSpot(3, 13),
          FlSpot(4, 14),
          FlSpot(5, 16),
        ];
        break;
      case 'Drain 004':
        spots = [
          FlSpot(0, 4),
          FlSpot(1, 6),
          FlSpot(2, 5),
          FlSpot(3, 8),
          FlSpot(4, 10),
          FlSpot(5, 15),
        ];
        break;
      default:
        spots = [
          FlSpot(0, 0),
          FlSpot(1, 0),
          FlSpot(2, 0),
          FlSpot(3, 0),
          FlSpot(4, 0),
          FlSpot(5, 0),
        ];
    }

    return LineChartData(
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          axisNameWidget: Text(yAxisLabel, style: TextStyle(fontSize: 14)),
          axisNameSize: 28,
          sideTitles: SideTitles(
            showTitles: true,
            interval: 5,
            reservedSize: 40,
          ),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: const Text("Time", style: TextStyle(fontSize: 14)),
          axisNameSize: 24,
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
          ),
        ),
        rightTitles: AxisTitles(),
        topTitles: AxisTitles(),
      ),
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: primaryColor,
          barWidth: 3,
          dotData: FlDotData(show: true),
        ),
      ],
    );
  }
}
