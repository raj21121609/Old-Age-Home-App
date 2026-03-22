import 'package:flutter/material.dart';

class AdminAlertsScreen extends StatefulWidget {
  final VoidCallback? onBack; // Optional back navigation for embedding

  const AdminAlertsScreen({super.key, this.onBack});

  @override
  State<AdminAlertsScreen> createState() => _AdminAlertsScreenState();
}

class _AdminAlertsScreenState extends State<AdminAlertsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Alerts', 'Warnings', 'Updates'];

  final List<Map<String, dynamic>> _alerts = [
    {
      'type': 'Alerts',
      'title': 'Emergency Alert',
      'desc': 'Health emergency reported for Ramesh Kumar at Sunshine Old Age Home',
      'meta': 'Sunshine Old Age Home • Ramesh Kumar',
      'time': '10 mins ago',
      'isNew': true,
      'color': Colors.red,
      'bg': Colors.red.shade50,
      'icon': Icons.warning_amber_rounded
    },
    {
      'type': 'Warnings',
      'title': 'Missing Reports',
      'desc': '5 daily reports not submitted at Seva Sadan',
      'meta': 'Seva Sadan',
      'time': '2 hours ago',
      'isNew': true,
      'color': Colors.orangeAccent.shade700,
      'bg': Colors.orange.shade50,
      'icon': Icons.schedule
    },
    {
      'type': 'Updates',
      'title': 'Inspection Scheduled',
      'desc': 'Site visit scheduled for Golden Years Care Center on Jan 10',
      'meta': 'Golden Years Care Center',
      'time': '1 day ago',
      'isNew': false,
      'color': Colors.blue.shade600,
      'bg': Colors.blue.shade50,
      'icon': Icons.shield_outlined
    },
    {
      'type': 'Updates',
      'title': 'Report Verified',
      'desc': 'All reports verified for Aashray Care Home',
      'meta': 'Aashray Care Home',
      'time': '2 days ago',
      'isNew': false,
      'color': Colors.green.shade600,
      'bg': Colors.green.shade50,
      'icon': Icons.check_circle_outline
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAlerts = _selectedFilter == 'All'
        ? _alerts
        : _alerts.where((a) => a['type'] == _selectedFilter).toList();

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
                        return _buildAlertCard(filteredAlerts[index]);
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
      width: double.infinity,
      color: const Color(0xFF8B21C6), // Admin deep purple
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.pop(context),
            child: const Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Back', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          const Text('Stay updated with alerts', style: TextStyle(fontSize: 14, color: Colors.white70)),
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
