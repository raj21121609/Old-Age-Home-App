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
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: filters.map((f) {
          bool isSelected = selectedFilter == f;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF048A39) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(f, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: isSelected ? Colors.white : Colors.grey.shade600, letterSpacing: 0.5)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    Color iconColor;
    IconData icon;

    switch (alert['type']) {
      case 'Emergency':
        icon = Icons.warning_amber_rounded;
        iconColor = const Color(0xFFDC2626);
        break;
      case 'Warning':
        icon = Icons.access_time_rounded;
        iconColor = const Color(0xFFD97706);
        break;
      case 'Update':
        icon = Icons.info_outline_rounded;
        iconColor = const Color(0xFF2563EB);
        break;
      case 'Success':
        icon = Icons.check_circle_outline_rounded;
        iconColor = const Color(0xFF16A34A);
        break;
      default:
        icon = Icons.notifications_none_rounded;
        iconColor = Colors.grey.shade600;
    }

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(alert['title'], 
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1E2125))),
                    ),
                    if (alert['isNew'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('NEW', style: TextStyle(color: Color(0xFF991B1B), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                      )
                  ],
                ),
                const SizedBox(height: 6),
                Text(alert['description'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: Colors.grey.shade400, size: 14),
                    const SizedBox(width: 4),
                    Expanded(child: Text(alert['location'].toString().toUpperCase(), style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(alert['time'], style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<CaretakerProvider>().alerts;
    return Column(
      children: [
        // Premium Header
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF1E2125), size: 20),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E2125), letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Text('STAY UPDATED WITH FACILITY ALERTS', style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
            ],
          ),
        ),

        // Scrollable Body
        Expanded(
          child: Container(
            color: const Color(0xFFF7F8FA),
            child: Column(
              children: [
                _buildFilterPills(),
                Expanded(
                  child: alerts.isEmpty
                      ? Center(child: Text('No alerts found.', style: TextStyle(color: Colors.grey.shade600)))
                      : ListView(
                          physics: const BouncingScrollPhysics(),
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
