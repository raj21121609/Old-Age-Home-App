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
        : systemAlerts; 

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildPremiumHeader(),
            _buildFilterRow(),
            Expanded(
              child: filteredAlerts.isEmpty 
                  ? Center(child: Text('No $_selectedFilter found.', style: TextStyle(color: Colors.grey.shade600)))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filteredAlerts.length,
                      itemBuilder: (context, index) {
                        final a = filteredAlerts[index];
                        return _buildAlertCard({
                          'title': 'Facility Alert - ${a['home_name']}',
                          'desc': '${a['issues']}',
                          'meta': '${a['home_name']?.toString()?.toUpperCase()} • ${a['elderly_name']}',
                          'time': a['date'] ?? 'Recent',
                          'isNew': true,
                          'color': const Color(0xFFDC2626),
                          'bg': Colors.white,
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

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: const Color(0xFFF7F8FA),
      child: Row(
        children: [
          if (widget.onBack != null)
            IconButton(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black87),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (widget.onBack != null) const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('System Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text('CENTRAL ALERT MONITORING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red, letterSpacing: 0.5)),
            ],
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _filters.map((f) {
            bool isSelected = _selectedFilter == f;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF048A39) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    Color mainColor = alert['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              color: mainColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(alert['icon'], color: mainColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(alert['title'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1E2125)))),
                    if (alert['isNew']) 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(6)),
                        child: const Text('NEW', style: TextStyle(color: Color(0xFF991B1B), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                      )
                  ],
                ),
                const SizedBox(height: 6),
                Text(alert['desc'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_rounded, color: Colors.grey.shade400, size: 14),
                    const SizedBox(width: 4),
                    Expanded(child: Text(alert['meta'], style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(alert['time'], style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
