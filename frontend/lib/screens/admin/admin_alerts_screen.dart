import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';

class AdminAlertsScreen extends StatefulWidget {
  final VoidCallback? onBack; // Optional back navigation for embedding

  const AdminAlertsScreen({super.key, this.onBack});

  @override
  State<AdminAlertsScreen> createState() => _AdminAlertsScreenState();
}

class _AdminAlertsScreenState extends State<AdminAlertsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Alerts'];

  @override
  Widget build(BuildContext context) {
    final systemAlerts = context.watch<AdminProvider>().systemAlerts;
    
    List<dynamic> filteredAlerts = _selectedFilter == 'All'
        ? systemAlerts
        : systemAlerts; // All are 'Alerts' mapped from issues.

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildPurpleHeader(),
            _buildFilterRow(),
            Expanded(
              child: filteredAlerts.isEmpty 
                  ? Center(child: Text('No $_selectedFilter found.', style: TextStyle(color: Colors.grey.shade600)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filteredAlerts.length,
                      itemBuilder: (context, index) {
                        final a = filteredAlerts[index];
                        return _buildAlertCard({
                          'title': 'Home Alert - ${a['home_name']}',
                          'desc': '${a['issues']}',
                          'meta': '${a['home_name']} • ${a['elderly_name']}',
                          'time': a['date'] ?? 'Recent',
                          'isNew': true,
                          'color': Colors.red,
                          'bg': Colors.red.shade50,
                          'icon': Icons.warning_amber_rounded
                        });
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPurpleHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          if (widget.onBack != null)
            GestureDetector(
              onTap: widget.onBack,
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Color(0xFF1E2125), size: 20),
              ),
            ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notifications', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1E2125))),
              Text('Stay updated with alerts', style: TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: const Icon(Icons.notifications_active, color: Color(0xFF16A34A), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: _filters.map((f) => Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedFilter == f ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedFilter == f ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
                ),
                child: Text(f, style: TextStyle(
                  color: _selectedFilter == f ? Colors.black87 : Colors.grey.shade700,
                  fontSize: 13,
                  fontWeight: _selectedFilter == f ? FontWeight.bold : FontWeight.w600,
                )),
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    Color mainColor = alert['color'];
    Color bgColor = alert['bg'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mainColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(alert['icon'], color: mainColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(alert['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)))),
                    if (alert['isNew']) 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF1D4ED8), borderRadius: BorderRadius.circular(12)),
                        child: const Text('New', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                  ],
                ),
                const SizedBox(height: 6),
                Text(alert['desc'], style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 13, height: 1.4)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.red.shade400, size: 12),
                    const SizedBox(width: 6),
                    Expanded(child: Text(alert['meta'], style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 11))),
                  ],
                ),
                const SizedBox(height: 6),
                Text(alert['time'], style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 11)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
