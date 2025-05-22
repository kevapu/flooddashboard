import 'dart:async';
import 'package:flutter/material.dart';

class MaintenaCalendar2027 extends StatefulWidget {
  const MaintenaCalendar2027({Key? key}) : super(key: key);

  @override
  _MaintenaCalendar2027State createState() => _MaintenaCalendar2027State();
}

class _MaintenaCalendar2027State extends State<MaintenaCalendar2027>
    with SingleTickerProviderStateMixin {
  static const int year = 2027;
  static const int month = 7; // July

  late final AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  // Maintenance events info
  final Map<int, Map<String, dynamic>> maintenanceEvents = {
    2: {
      'status': 'Pending',
      'drain': 'Drain007',
      'deadline': 9, // 7 days after 2 July
    },
    8: {
      'status': 'Pending',
      'drain': 'Drain0020',
      'deadline': 15,
    },
    23: {
      'status': 'In Progress',
      'drain': 'Drain002',
      'deadline': 30,
    },
    27: {
      'status': 'Finished',
      'drain': 'Drain006',
    }
  };

  // Weekday labels starting Sunday
  final List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  int daysInMonth(int year, int month) {
    final nextMonth = month == 12 ? DateTime(year + 1, 1) : DateTime(year, month + 1);
    final lastDay = nextMonth.subtract(const Duration(days: 1));
    return lastDay.day;
  }

  int firstWeekdayOfMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    return firstDay.weekday % 7; // Sunday=0, Monday=1, ... Saturday=6
  }

  Widget _buildDateCell(int day, bool isWithinMonth) {
    final event = maintenanceEvents[day];
    // Check if this day is a deadline for any event and get that event's drain
    final deadlineEvent = maintenanceEvents.entries
        .firstWhere(
          (entry) => entry.value['deadline'] == day,
          orElse: () => const MapEntry(-1, {}),
        )
        .value;

    final bool isDeadline = deadlineEvent.isNotEmpty;

    // Base styles for dark theme
    Color bgColor = const Color.fromARGB(255, 188, 188, 188);
    Color borderColor = Colors.grey.shade700;
    Widget? labelWidget;

    if (!isWithinMonth) {
      bgColor = Colors.grey.shade800;
    } else if (event != null) {
      final status = event['status'] as String;
      switch (status) {
        case 'Pending':
          bgColor = Colors.orange.shade700;
          labelWidget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Pending',
                  style: TextStyle(
                      fontSize: 10,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold)),
              Text(event['drain'],
                  style: const TextStyle(fontSize: 8, color: Color.fromARGB(255, 255, 255, 255))),
            ],
          );
          borderColor = Colors.orange.shade300;
          break;
        case 'In Progress':
          bgColor = Colors.green.shade700;
          labelWidget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('OnGoing',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.green.shade200,
                      fontWeight: FontWeight.bold)),
              Text(event['drain'],
                  style: const TextStyle(fontSize: 8, color: Colors.greenAccent)),
            ],
          );
          borderColor = Colors.green.shade300;
          break;
        case 'Finished':
          bgColor = Colors.green.shade900;
          labelWidget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Finished',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.green.shade200,
                      fontWeight: FontWeight.bold)),
              Text(event['drain'],
                  style: const TextStyle(fontSize: 8, color: Colors.greenAccent)),
            ],
          );
          borderColor = Colors.green.shade400;
          break;
      }
    }

    if (isDeadline) {
      bgColor = Colors.red.shade700;
      labelWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Deadline',
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255))),
          if (deadlineEvent['drain'] != null)
            Text(deadlineEvent['drain'],
                style: const TextStyle(fontSize: 8, color: Color.fromARGB(255, 255, 255, 255))),
        ],
      );
      borderColor = Colors.red.shade300;
    }

    final dayTextColor = isWithinMonth ? Colors.grey.shade200 : Colors.grey.shade600;

    Widget cell = Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      child: day > 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(day.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14, color: dayTextColor)),
                if (labelWidget != null) ...[
                  const SizedBox(height: 4),
                  labelWidget,
                ]
              ],
            )
          : const SizedBox.shrink(),
    );

    // Add blinking green border for "In Progress" dates
    if (event != null && event['status'] == 'In Progress' && isWithinMonth) {
      return AnimatedBuilder(
        animation: _blinkController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _blinkController.value > 0.5 ? Colors.greenAccent : Colors.transparent,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(2),
            child: cell,
          );
        },
      );
    }

    return cell;
  }

  @override
  Widget build(BuildContext context) {
    final int totalDays = daysInMonth(year, month);
    final int firstWeekDay = firstWeekdayOfMonth(year, month);

    // Total grid slots: 7 columns * 6 rows = 42
    List<int> daysGrid = List.generate(42, (index) {
      int dayNum = index - firstWeekDay + 1;
      if (dayNum < 1 || dayNum > totalDays) return 0;
      return dayNum;
    });

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey.shade700),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade900,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'Maintenance Calendar - July 2027',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade200),
          ),
          const SizedBox(height: 8),

          // Weekday header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays
                .map((e) => Expanded(
                      child: Center(
                        child: Text(
                          e,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                        ),
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: 8),

          // Vertical scrollable grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: daysGrid.length,
              itemBuilder: (context, index) {
                final day = daysGrid[index];
                final isWithinMonth = day > 0;
                return _buildDateCell(day, isWithinMonth);
              },
            ),
          ),
        ],
      ),
    );
  }
}
