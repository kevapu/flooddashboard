import 'dart:math';
import 'package:flutter/material.dart';

class DrainMonitorTable extends StatelessWidget {
  const DrainMonitorTable({super.key});

  List<Map<String, dynamic>> _generateDrainData() {
    final List<String> sensorTypes = [
      'Flowmeter Sensor',
      'Ultrasonic Sensor',
      'Float Sensor',
    ];

    List<Map<String, dynamic>> data = [];
    final Random random = Random();
    final lowBatteryIndices = {random.nextInt(20), random.nextInt(20)};
    for (int i = 0; i < 20; i++) {
      final isLowBattery = lowBatteryIndices.contains(i);
      final battery = isLowBattery
          ? random.nextInt(20) + 20 // 20% to 39%
          : random.nextInt(61) + 40; // 40% to 100%
      data.add({
        'no': i + 1,
        'drainNumber': 'Drain ${(i + 1).toString().padLeft(3, '0')}',
        'sensorType': sensorTypes[random.nextInt(sensorTypes.length)],
        'battery': '$battery%',
        'status': isLowBattery ? 'Offline' : 'Online',
        'isLow': isLowBattery,
      });
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final data = _generateDrainData();
    final anyOffline = data.any((item) => item['status'] == 'Offline');

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: anyOffline ? const Color.fromARGB(255, 77, 77, 77) : Colors.green.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white54),
            ),
            child: const Center(
              child: Text(
                'Drain Monitoring Table',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                border: TableBorder.all(color: Colors.white30, width: 0.5),
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.grey.shade800),
                headingTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                dataRowColor: MaterialStateColor.resolveWith((states) => Colors.black),
                columns: const [
                  DataColumn(label: Text('No.')),
                  DataColumn(label: Text('Drain Number')),
                  DataColumn(label: Text('Sensor Type')),
                  DataColumn(label: Text('Battery Level')),
                  DataColumn(label: Text('Status')),
                ],
                rows: data.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(Text(item['no'].toString(),
                          style: const TextStyle(color: Colors.white))),
                      DataCell(Text(item['drainNumber'],
                          style: const TextStyle(color: Colors.white))),
                      DataCell(Text(item['sensorType'],
                          style: const TextStyle(color: Colors.white))),
                      DataCell(Text(
                        item['battery'],
                        style: TextStyle(
                          color: item['isLow'] ? Colors.redAccent : Colors.lightGreenAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                      DataCell(
                        item['status'] == 'Offline'
                            ? BlinkingText(
                                text: 'Offline',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : const Text(
                                'Online',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlinkingText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const BlinkingText({super.key, required this.text, this.style});

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Text(widget.text, style: widget.style),
    );
  }
}
