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
  String selectedDrain = 'Drain 001';
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

    if (selectedDrain == 'Drain 001') {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDrainChange(String? value) {
    if (value == 'Drain 001') {
      _controller.forward(from: 0.0);
    } else {
      _controller.reset();
    }
    setState(() {
      selectedDrain = value!;
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
                const SizedBox(height: 40),

                // Slide-in chart row only for Drain 001
                if (selectedDrain == 'Drain 001')
                  SlideTransition(
                    position: _slideAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text("Flowrate vs Time", style: chartTitleStyle),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 300,
                              height: 300,
                              child: LineChart(
                                sampleChartData("Flowrate"),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Water Height vs Time", style: chartTitleStyle),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 300,
                              height: 300,
                              child: LineChart(
                                sampleChartData("Water Height"),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Rain Rate vs Time", style: chartTitleStyle),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 300,
                              height: 300,
                              child: LineChart(
                                sampleChartData("Rain Rate"),
                              ),
                            ),
                          ],
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

  LineChartData sampleChartData(String yAxisLabel) {
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
          spots: [
            FlSpot(0, 5),
            FlSpot(1, 10),
            FlSpot(2, 6),
            FlSpot(3, 14),
            FlSpot(4, 11),
            FlSpot(5, 17),
          ],
          isCurved: true,
          color: primaryColor,
          barWidth: 3,
          dotData: FlDotData(show: true),
        ),
      ],
    );
  }
}
