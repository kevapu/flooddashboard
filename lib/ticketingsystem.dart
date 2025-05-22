import 'package:flutter/material.dart';

class MaintenanceTicketingSection extends StatefulWidget {
  const MaintenanceTicketingSection({Key? key}) : super(key: key);

  @override
  _MaintenanceTicketingSectionState createState() =>
      _MaintenanceTicketingSectionState();
}

class _MaintenanceTicketingSectionState extends State<MaintenanceTicketingSection>
    with SingleTickerProviderStateMixin {
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

  // Tickets list updated with more entries
  final List<Map<String, String>> tickets = [
    {
      'code': 'Drain0017-US',
      'jobOrder': 'Battery Maintenance',
      'jobStatus': 'Pending',
      'supervisor': 'IR.',
      'deadline': '9 July 2027',
    },
    {
      'code': 'Drain0020-US',
      'jobOrder': 'Battery Maintenance',
      'jobStatus': 'Pending',
      'supervisor': 'IR.',
      'deadline': '15 July 2027',
    },
    {
      'code': 'Drain002-FS',
      'jobOrder': 'Sensor Maintenance',
      'jobStatus': 'OnGoing',
      'supervisor': 'IR.',
      'deadline': '20 July 2027',
    },
    {
      'code': 'Drain006-FS02',
      'jobOrder': 'Circuit Maintenance',
      'jobStatus': 'Finished',
      'supervisor': 'IR.',
      'deadline': '20 July 2027',
    },
    // More tickets to fill space
    {
      'code': 'Drain011-ZX',
      'jobOrder': 'Pump Maintenance',
      'jobStatus': 'Pending',
      'supervisor': 'IR.',
      'deadline': '30 July 2027',
    },
    {
      'code': 'Drain014-XY',
      'jobOrder': 'Valve Maintenance',
      'jobStatus': 'OnGoing',
      'supervisor': 'IR.',
      'deadline': '28 July 2027',
    },
  ];

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade700;
      case 'ongoing':
        return Colors.green.shade700;
      case 'finished':
        return Colors.green.shade900;
      default:
        return Colors.grey.shade700;
    }
  }

  Widget buildTicket(Map<String, String> ticket) {
    final status = ticket['jobStatus']!.toLowerCase();
    final Color baseColor = getStatusColor(status);

    final content = Container(
      width: 160, // fixed width for ticket box
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: baseColor.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: baseColor.withOpacity(0.6),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ticket['code']!,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            'Job Order: ${ticket['jobOrder']}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            'Job Status: ${ticket['jobStatus']}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            'Supervisor: ${ticket['supervisor']}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            'Deadline: ${ticket['deadline']}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );

    if (status == 'ongoing') {
      // blinking green border effect
      return AnimatedBuilder(
        animation: _blinkController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _blinkController.value > 0.5
                    ? Colors.greenAccent.shade400
                    : Colors.transparent,
                width: 3,
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: content,
          );
        },
      );
    }

    // normal for pending and finished
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: content,
    );
  }

  // The special "Pending Job Offer" label box
  Widget buildPendingJobOfferBox() {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.orange.shade800,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade600.withOpacity(0.6),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Pending Job Offer',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // fill all available height and width
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      color: Colors.grey.shade900,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true, // right to left
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildPendingJobOfferBox(),
            ...tickets.map(buildTicket).toList(),
          ],
        ),
      ),
    );
  }
}
