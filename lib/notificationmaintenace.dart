import 'package:flutter/material.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({Key? key}) : super(key: key);

  final List<_NotificationItem> notifications = const [
    _NotificationItem(
      title: 'Drain 007 maintenance deadline 7 days left',
      severity: NotificationSeverity.important,
    ),
    _NotificationItem(
      title: 'Drain 0020 maintenance deadline 7 days left',
      severity: NotificationSeverity.important,
    ),
    _NotificationItem(
      title: 'Drain006 Flow Meter Sensor replaced',
      severity: NotificationSeverity.normal,
    ),
    _NotificationItem(
      title: 'Electric Box Puchong Maintenance OnGoing',
      severity: NotificationSeverity.warning,
    ),
    _NotificationItem(
      title: 'Drain001 Battery Replacement overdue by 2 days',
      severity: NotificationSeverity.critical,
    ),
    _NotificationItem(
      title: 'New job assigned: Drain009 Sensor Calibration',
      severity: NotificationSeverity.normal,
    ),
    _NotificationItem(
      title: 'Circuit Maintenance scheduled for Drain005 on 10 June 2027',
      severity: NotificationSeverity.important,
    ),
  ];

  Color _getSeverityColor(NotificationSeverity severity) {
    switch (severity) {
      case NotificationSeverity.normal:
        return Colors.greenAccent.shade400;
      case NotificationSeverity.warning:
        return Colors.orangeAccent.shade400;
      case NotificationSeverity.important:
        return Colors.deepOrangeAccent.shade400;
      case NotificationSeverity.critical:
        return Colors.redAccent.shade400;
    }
  }

  IconData _getSeverityIcon(NotificationSeverity severity) {
    switch (severity) {
      case NotificationSeverity.normal:
        return Icons.check_circle_outline;
      case NotificationSeverity.warning:
        return Icons.warning_amber_outlined;
      case NotificationSeverity.important:
        return Icons.notifications_active_outlined;
      case NotificationSeverity.critical:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121212), // dark background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: _getSeverityColor(notification.severity)
                          .withOpacity(0.7),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _getSeverityIcon(notification.severity),
                        color: _getSeverityColor(notification.severity),
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum NotificationSeverity { normal, warning, important, critical }

class _NotificationItem {
  final String title;
  final NotificationSeverity severity;

  const _NotificationItem({
    required this.title,
    required this.severity,
  });
}
