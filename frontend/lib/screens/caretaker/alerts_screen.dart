import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/caretaker_provider.dart';

class AlertsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AlertsScreen({super.key, required this.onBack});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String selectedFilter = 'All';

  final List<String> filters = ['All', 'Alerts', 'Warnings', 'Updates'];

  // Alerts will be fetched dynamically below.

  Widget _buildFilterPills() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: filters.map((f) {
          bool isSelected = selectedFilter == f;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedFilter = f),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
                ),
                child: Center(
                  child: Text(f, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: Colors.black87)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    Color bgColor;
    Color borderColor;
    IconData icon;
    Color iconColor;

    switch (alert['type']) {
      case 'Emergency':
        bgColor = Colors.red.shade50;
        borderColor = Colors.red.shade100;
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.red;
        break;
      case 'Warning':
        bgColor = Colors.amber.shade50;
        borderColor = Colors.amber.shade200;
        icon = Icons.access_time;
        iconColor = Colors.amber.shade700;
        break;
      case 'Update':
        bgColor = Colors.blue.shade50;
        borderColor = Colors.blue.shade100;
        icon = Icons.shield_outlined;
        iconColor = Colors.blue.shade700;
        break;
      case 'Success':
        bgColor = Colors.green.shade50;
        borderColor = Colors.green.shade200;
        icon = Icons.check_circle_outline;
        iconColor = Colors.green.shade600;
        break;
      default:
        bgColor = Colors.white;
        borderColor = Colors.grey.shade300;
        icon = Icons.info_outline;
        iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(alert['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                        if (alert['isNew'])
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E5EFC),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('New', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(alert['description'], style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red.shade400, size: 14),
                        const SizedBox(width: 6),
                        Expanded(child: Text(alert['location'], style: TextStyle(color: Colors.grey.shade700, fontSize: 12))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(alert['time'], style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<CaretakerProvider>().alerts;
    return Column(
      children: [
        // Blue Header
        Container(
          width: double.infinity,
          color: const Color(0xFF1E5EFC),
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text('Back', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              const Text('Stay updated with alerts', style: TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
        ),

        // Scrollable Body
        Expanded(
          child: Container(
            color: const Color(0xFFF6F9FF),
            child: Column(
              children: [
                _buildFilterPills(),
                Expanded(
                  child: alerts.isEmpty
                      ? Center(child: Text('No alerts found.', style: TextStyle(color: Colors.grey.shade600)))
                      : ListView(
                          padding: const EdgeInsets.only(top: 4, bottom: 24),
                          children: alerts.map((a) => _buildAlertCard(a)).toList(),
                        ),
                ),
              ],
            ),
          )
        )
      ],
    );
  }
}
