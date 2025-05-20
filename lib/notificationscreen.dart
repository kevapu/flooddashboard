import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sidewidget.dart';
import 'animatedbackground.dart';
import 'addordeletedrain.dart'; // import maintenance screen

final Color primaryColor = Color.fromARGB(255, 69, 87, 244);

enum NotificationSeverity { info, warning, critical }

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentScreen: 'Notifications'),
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 6,
        shadowColor: primaryColor.withAlpha(100),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: BackgroundWrapper(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                NotificationTile(
                  title: 'Drain 004: Battery drop below 30%',
                  timestamp: '5 mins ago',
                  severity: NotificationSeverity.warning,
                ),
                const SizedBox(height: 12),
                NotificationTile(
                  title: 'Drain 006: Offline',
                  timestamp: '10 mins ago',
                  severity: NotificationSeverity.critical,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddDeleteDrainScreen(
                          initialSelectedDrain: 'Drain 006',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                NotificationTile(
                  title: 'System Update Available',
                  subtitle: 'Extra feature added: Real-time analytics dashboard',
                  timestamp: 'Today, 08:00 AM',
                  severity: NotificationSeverity.info,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String timestamp;
  final NotificationSeverity severity;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.timestamp,
    required this.severity,
    this.onTap,
  });

  Color _getSeverityColor() {
    switch (severity) {
      case NotificationSeverity.info:
        return Colors.green.shade100;
      case NotificationSeverity.warning:
        return Colors.orange.shade100;
      case NotificationSeverity.critical:
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  IconData _getSeverityIcon() {
    switch (severity) {
      case NotificationSeverity.info:
        return Icons.system_update_alt;
      case NotificationSeverity.warning:
        return Icons.warning_amber_rounded;
      case NotificationSeverity.critical:
        return Icons.error_outline;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getSeverityColor(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: ListTile(
          leading: Icon(_getSeverityIcon(), color: Colors.black54),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                )
              : null,
          trailing: Text(
            timestamp,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
