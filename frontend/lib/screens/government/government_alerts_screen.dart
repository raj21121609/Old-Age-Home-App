import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/government_provider.dart';

class GovernmentAlertsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  
  const GovernmentAlertsScreen({super.key, this.onBack});

  @override
  State<GovernmentAlertsScreen> createState() => _GovernmentAlertsScreenState();
}

class _GovernmentAlertsScreenState extends State<GovernmentAlertsScreen> {
  String _selectedFilter = 'All Alerts';

  @override
  Widget build(BuildContext context) {
    final systemAlerts = context.watch<GovernmentProvider>().systemAlerts;

    return Container(
      color: const Color(0xFFF7F8FA),
      child: Column(
        children: [
          _buildTopHeader(),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Mark all as read', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildFilterChip('All Alerts', _selectedFilter == 'All Alerts', () => setState(() => _selectedFilter = 'All Alerts')),
                      _buildFilterChip('Critical', _selectedFilter == 'Critical', () => setState(() => _selectedFilter = 'Critical')),
                      _buildFilterChip('Pending', _selectedFilter == 'Pending', () => setState(() => _selectedFilter = 'Pending')),
                      _buildFilterChip('System', _selectedFilter == 'System', () => setState(() => _selectedFilter = 'System')),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (systemAlerts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No new alerts reported recently.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: systemAlerts.map((a) => _buildAlertCard(
                        title: 'ALERT: ${a['home_name']}',
                        description: '${a['issues']}',
                        subText: '${a['elderly_name']} • Room ${a['room'] ?? 'N/A'}',
                        time: a['date'] ?? 'Just now',
                        isCritical: true,
                      )).toList(),
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
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
              Text(
                'Monitoring Feed',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                'LIVE UPDATES',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red, letterSpacing: 0.5),
              )
            ],
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF048A39) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard({
    required String title,
    required String description,
    required String subText,
    required String time,
    bool isCritical = false,
  }) {
    Color iconColor = isCritical ? const Color(0xFFDC2626) : const Color(0xFF2563EB);
    IconData icon = isCritical ? Icons.warning_amber_rounded : Icons.info_outline_rounded;

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
                      child: Text(title, 
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1E2125))),
                    ),
                    if (isCritical)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('URGENT', style: TextStyle(color: Color(0xFF991B1B), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                      )
                  ],
                ),
                const SizedBox(height: 6),
                Text(description, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_rounded, color: Colors.grey.shade400, size: 14),
                    const SizedBox(width: 4),
                    Expanded(child: Text(subText.toUpperCase(), style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

