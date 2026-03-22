import 'package:flutter/material.dart';

class GovernmentAlertsScreen extends StatelessWidget {
  final VoidCallback? onBack;
  
  const GovernmentAlertsScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F7FB),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTabPill('All', isSelected: true),
                          const SizedBox(width: 8),
                          _buildTabPill('Alerts'),
                          const SizedBox(width: 8),
                          _buildTabPill('Warnings'),
                          const SizedBox(width: 8),
                          _buildTabPill('Updates'),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildAlertCard(
                        title: 'Emergency Alert',
                        description: 'Health emergency reported for Ramesh Kumar at Sunshine Old Age Home',
                        location: 'Sunshine Old Age Home • Ramesh Kumar',
                        time: '10 mins ago',
                        icon: Icons.warning_amber_rounded,
                        color: Colors.red,
                        isNew: true,
                      ),
                      _buildAlertCard(
                        title: 'Missing Reports',
                        description: '5 daily reports not submitted at Seva Sadan',
                        location: 'Seva Sadan',
                        time: '2 hours ago',
                        icon: Icons.schedule,
                        color: Colors.amber,
                        isNew: true,
                      ),
                      _buildAlertCard(
                        title: 'Inspection Scheduled',
                        description: 'Site visit scheduled for Golden Years Care Center on Jan 10',
                        location: 'Golden Years Care Center',
                        time: '1 day ago',
                        icon: Icons.shield_outlined,
                        color: Colors.blue,
                        isNew: false,
                      ),
                      _buildAlertCard(
                        title: 'Report Verified',
                        description: 'All reports verified for Aashray Care Home',
                        location: 'Aashray Care Home',
                        time: '2 days ago',
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                        isNew: false,
                      ),
                      const SizedBox(height: 24),
                    ]),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF048A39), // Green theme
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null)
            GestureDetector(
              onTap: onBack,
              child: const Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Back', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          if (onBack != null) const SizedBox(height: 16),
          const Text('Notifications', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          const Text('Stay updated with alerts', style: TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildTabPill(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSelected 
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
            : [],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildAlertCard({
    required String title,
    required String description,
    required String location,
    required String time,
    required IconData icon,
    required MaterialColor color,
    required bool isNew,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade50.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: color.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              if (isNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('New', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                )
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 13, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on, size: 12, color: color.shade700),
              const SizedBox(width: 4),
              Expanded(child: Text(location, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 12))),
            ],
          ),
          const SizedBox(height: 8),
          Text(time, style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 12)),
        ],
      ),
    );
  }
}
