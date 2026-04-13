import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/caretaker_provider.dart';
import '../../providers/language_provider.dart';
import 'daily_report_screen.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';

class CaretakerDashboard extends StatefulWidget {
  const CaretakerDashboard({super.key});

  @override
  State<CaretakerDashboard> createState() => _CaretakerDashboardState();
}

class _CaretakerDashboardState extends State<CaretakerDashboard> {
  int _selectedIndex = 0;
  dynamic _selectedResident;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null && user['id'] != null) {
        context.read<CaretakerProvider>().fetchElderly(user['id']);
      }
    });
  }

  void _triggerEmergency() {
    context.read<CaretakerProvider>().triggerEmergency();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final String name = user?['name']?.split(' ')[0] ?? 'Admin';
    final provider = context.watch<CaretakerProvider>();
    final lang = context.watch<LanguageProvider>();

    // Dynamic Wellness Logic
    final total = provider.elderly.length;
    final goodCount = provider.elderly.where((e) => e != null && (e['health_status'] ?? 'good').toString().toLowerCase() == 'good').length;
    final attentionCount = total - goodCount;
    final wellnessPercentage = total == 0 ? 100 : ((goodCount / total) * 100).toInt();

    Widget body;
    switch (_selectedIndex) {
      case 1: // Residents (Placeholder or List)
        body = _buildDashboardHome(name, wellnessPercentage, attentionCount, provider, lang);
        break;
      case 2: // Vitals/Alerts (Preserving old Alerts functionality here)
        body = AlertsScreen(onBack: () => setState(() => _selectedIndex = 0));
        break;
      case 4: // Settings (Preserving old Profile functionality here)
        body = ProfileScreen(onBack: () => setState(() => _selectedIndex = 0));
        break;
      default:
        // Use index 1 if a resident is actually selected for report
        if (_selectedIndex == 1 && _selectedResident != null) {
          body = DailyReportScreen(
            resident: _selectedResident,
            onBack: () => setState(() => _selectedIndex = 0),
            onSubmit: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted securely!')));
              setState(() => _selectedIndex = 0);
            },
          );
        } else {
          body = _buildDashboardHome(name, wellnessPercentage, attentionCount, provider, lang);
        }
    }

    // Special case: If we are in "Report Mode" (triggered from card)
    if (_selectedResident != null && _selectedIndex == 1) {
       body = DailyReportScreen(
        resident: _selectedResident,
        onBack: () {
          setState(() {
            _selectedResident = null;
            _selectedIndex = 0;
          });
        },
        onSubmit: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted securely!')));
          setState(() {
            _selectedResident = null;
            _selectedIndex = 0;
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(child: body),
      bottomNavigationBar: _buildBottomNav(lang),
    );
  }

  Widget _buildDashboardHome(String name, int wellness, int attentionCount, CaretakerProvider provider, LanguageProvider lang) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _buildTopHeader(name),
        _buildWellnessCard(wellness, attentionCount),
        _buildCloudStatus(),
        _buildQuickActions(lang),
        _buildResidentsSection(provider, lang),
        _buildVitalsGrid(provider, wellness),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTopHeader(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=caretaker'),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good Morning,', style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
                child: const Icon(Icons.notifications_none_rounded, size: 24, color: Colors.black87),
              ),
              Positioned(right: 8, top: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWellnessCard(int wellness, int attentionCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20, bottom: -20,
            child: Icon(Icons.favorite, size: 140, color: Colors.green.withOpacity(0.05)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('FACILITY PULSE', style: TextStyle(color: Color(0xFF048A39), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
              const SizedBox(height: 8),
              Text('$wellness% Overall\nWellness', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, height: 1.1, color: Colors.black87)),
              const SizedBox(height: 16),
              Text(
                attentionCount == 0 
                  ? 'All residents are stable today. All morning check-ups completed.' 
                  : '$attentionCount residents require observation. Check the status feed below.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13, height: 1.5, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCloudStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.cloud_done_rounded, color: Color(0xFF048A39), size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Cloud Sync Active', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF048A39))),
              Text('LAST BACKUP: 2M AGO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade700.withOpacity(0.5), letterSpacing: 0.5)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickActions(LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          _buildActionButton('Submit Daily Report', Icons.description_rounded, const Color(0xFF048A39), Colors.white, () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang.t('Select a resident below to add a report', 'रिपोर्ट जोड़ने के लिए नीचे एक निवासी चुनें'))));
          }),
          const SizedBox(height: 12),
          _buildActionButton('Raise Facility Alert', Icons.warning_rounded, Colors.white, Colors.red, _triggerEmergency, isOutlined: true),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color bg, Color text, VoidCallback onTap, {bool isOutlined = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(40),
          border: isOutlined ? Border.all(color: Colors.red.withOpacity(0.1)) : null,
          boxShadow: bg != Colors.white ? [BoxShadow(color: bg.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: text, size: 20),
            const SizedBox(width: 12),
            Text(title, style: TextStyle(color: text, fontWeight: FontWeight.w900, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildResidentsSection(CaretakerProvider provider, LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Today\'s Residents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text('View All Schedule', style: TextStyle(color: const Color(0xFF048A39), fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          if (provider.isLoading && provider.elderly.isEmpty)
            const Center(child: CircularProgressIndicator())
          else if (provider.elderly.isEmpty)
             const Padding(padding: EdgeInsets.all(16.0), child: Text("No residents assigned."))
          else
            ...provider.elderly.where((e) => e != null).toList().asMap().entries.map((entry) => _buildResidentCard(entry.value, entry.key, lang)),
        ],
      ),
    );
  }

  Widget _buildResidentCard(dynamic e, int index, LanguageProvider lang) {
    final status = (e['health_status'] ?? 'good').toString().toLowerCase();
    final bool isStable = status == 'good';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade100,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${e['id']}'),
              ),
              Positioned(
                right: 2, bottom: 2,
                child: Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                    color: isStable ? Colors.green : Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e['name'] ?? 'Resident', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)),
                      child: Text('ROOM ${101 + index}', style: const TextStyle(color: Colors.blue, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Icon(isStable ? Icons.access_time_rounded : Icons.warning_amber_rounded, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      isStable ? 'Next Meds: 10:30 AM' : 'Needs Routine Check',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isStable ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isStable ? 'STABLE' : 'OBSERVATION',
                  style: TextStyle(color: isStable ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setState(() {
                  _selectedResident = e;
                  _selectedIndex = 1;
                }),
                child: Icon(Icons.add_circle, color: isStable ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3), size: 28),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildVitalsGrid(CaretakerProvider provider, int wellness) {
    // Dynamic offsets based on wellness
    final bpm = 72 + (100 - wellness) ~/ 5;
    final o2 = 98 - (100 - wellness) ~/ 10;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.6,
        children: [
          _buildVitalCard('AVERAGE BPM', '$bpm', 'bpm', Colors.green),
          _buildVitalCard('OXYGEN SAT.', '$o2', '%', Colors.blue),
          _buildVitalCard('HYDRATION', '84', '%', Colors.brown),
          _buildVitalCard('MOBILITY', '6.2', 'hr', Colors.black),
        ],
      ),
    );
  }

  Widget _buildVitalCard(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87)),
              const SizedBox(width: 4),
              Text(unit, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 3, width: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        ],
      ),
    );
  }

  Widget _buildBottomNav(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.grid_view_rounded, 'OVERVIEW', _selectedIndex == 0),
          _buildNavItem(1, Icons.people_alt_rounded, 'RESIDENTS', _selectedIndex == 1),
          _buildNavItem(2, Icons.analytics_rounded, 'VITALS', _selectedIndex == 2),
          _buildNavItem(3, Icons.task_alt_rounded, 'TASKS', _selectedIndex == 3),
          _buildNavItem(4, Icons.settings_rounded, 'SETTINGS', _selectedIndex == 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isActive) {
    final activeColor = const Color(0xFF048A39);
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: isActive ? BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(20)) : null,
            child: Icon(icon, color: isActive ? Colors.white : Colors.grey.shade400, size: 24),
          ),
          if (!isActive) ...[
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 9, fontWeight: FontWeight.w800)),
          ]
        ],
      ),
    );
  }
}

