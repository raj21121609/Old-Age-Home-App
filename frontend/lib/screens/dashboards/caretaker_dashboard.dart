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
    final String name = user?['name'] ?? 'Priya';
    final provider = context.watch<CaretakerProvider>();
    final langProvider = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: _selectedIndex == 1
            ? DailyReportScreen(
                onBack: () => setState(() => _selectedIndex = 0),
                onSubmit: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted securely to the Government portal!')));
                  setState(() => _selectedIndex = 0);
                },
              )
            : _selectedIndex == 2
                ? AlertsScreen(
                    onBack: () => setState(() => _selectedIndex = 0),
                  )
                : _selectedIndex == 3
                    ? ProfileScreen(
                        onBack: () => setState(() => _selectedIndex = 0),
                      )
                    : Column(
                        children: [
                          _buildTopHeader(name, langProvider),
                          if (provider.error == 'EMERGENCY ALERT BROADCASTED SECURELY') 
                             Container(width: double.infinity, color: Colors.red, padding: const EdgeInsets.all(12), child: Text(provider.error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          Expanded(
                            child: provider.isLoading && provider.elderly.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : provider.error.isNotEmpty && provider.error != 'EMERGENCY ALERT BROADCASTED SECURELY'
                                ? Center(child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)))
                                : _buildElderlyList(provider.elderly, langProvider),
                          ),
                        ],
                      ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
        },
        backgroundColor: Colors.white,
        elevation: 0,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined, color: Colors.blue), selectedIcon: const Icon(Icons.home, color: Colors.blue), label: langProvider.t('Home', 'होम')),
          NavigationDestination(icon: const Icon(Icons.description_outlined, color: Colors.grey), label: langProvider.t('Report', 'रिपोर्ट')),
          NavigationDestination(icon: const Icon(Icons.notifications_outlined, color: Colors.grey), label: langProvider.t('Alerts', 'अलर्ट')),
          NavigationDestination(icon: const Icon(Icons.person_outline, color: Colors.grey), label: langProvider.t('Profile', 'प्रोफ़ाइल')),
        ],
      ),
    );
  }

  Widget _buildElderlyList(List<dynamic> residents, LanguageProvider lang) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lang.t('Elderly Residents', 'बुजुर्ग निवासी'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
                child: Text('${residents.length} ${lang.t("Total", "कुल")}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (residents.isEmpty)
             Padding(padding: const EdgeInsets.all(16.0), child: Text(lang.t("No residents assigned.", "कोई निवासी नियुक्त नहीं है।"))),
          ...residents.asMap().entries.map((entry) {
            int idx = entry.key;
            var e = entry.value;
            String eName = e['name'] ?? 'Unknown';
            int eAge = e['age'] ?? 0;
            String eStatus = e['health_status'] ?? 'Good';
            bool isOk = eStatus.toLowerCase() == 'good';
            bool isAlert = eStatus.toLowerCase() == 'critical';
            bool isWarning = !isOk && !isAlert;
            
            String roomStr = lang.t('Room ${101 + idx}', 'कमरा ${101 + idx}');
            String ageStr = lang.t('years', 'वर्ष');
            
            String lastReportText;
            if (idx == 0) lastReportText = lang.t('Last report: 2 hours ago', 'अंतिम रिपोर्ट: 2 घंटे पहले');
            else if (idx == 1 || idx == 4) lastReportText = lang.t('Last report: Today', 'अंतिम रिपोर्ट: आज');
            else if (idx == 2) lastReportText = lang.t('Last report: 1 hour ago', 'अंतिम रिपोर्ट: 1 घंटे पहले');
            else lastReportText = lang.t('Last report: Yesterday', 'अंतिम रिपोर्ट: कल');

            return _buildResidentCard(
              eName, '$eAge $ageStr • $roomStr', lastReportText, eName.isNotEmpty ? eName[0] : '?', Colors.blue, isOk, warning: isWarning, alert: isAlert
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopHeader(String name, LanguageProvider lang) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 210,
            decoration: const BoxDecoration(
              color: Color(0xFF1E5EFC),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${lang.t("Welcome", "स्वागत है")}, $name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    GestureDetector(
                      onTap: () => setState(() => _selectedIndex = 2),
                      child: Stack(
                        children: [
                          const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                          Positioned(right: 0, top: 0, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: const Text('3', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))))
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(lang.t('Sunshine Old Age Home', 'सनशाइन ओल्ड एज होम'), style: const TextStyle(fontSize: 14, color: Colors.white)),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lang.t('Today\'s Date', 'आज की तिथि'), style: const TextStyle(fontSize: 12, color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text(lang.t('Saturday, 21 March 2026', 'शनिवार, 21 मार्च 2026'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Positioned(
            bottom: 0, left: 16, right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionCard(lang.t('Add Report', 'रिपोर्ट जोड़ें'), Icons.description_outlined, Colors.blue, callback: () {
                  setState(() { _selectedIndex = 1; });
                }),
                _buildActionCard(lang.t('Past Reports', 'पिछली रिपोर्ट'), Icons.home_outlined, Colors.green, callback: () {}),
                _buildActionCard(lang.t('Emergency', 'आपातकालीन'), Icons.error_outline, Colors.red, callback: _triggerEmergency),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, {required VoidCallback callback}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      )
    );
  }

  Widget _buildResidentCard(String name, String details, String lastReport, String initial, Color color, bool ok, {bool warning = false, bool alert = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundColor: color, child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(details, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                const SizedBox(height: 4),
                Text(lastReport, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          if (ok) 
            Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.green.shade200)), child: const Icon(Icons.check, color: Colors.green, size: 16))
          else if (warning) 
            Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.orange.shade200)), child: const Icon(Icons.hourglass_bottom, color: Colors.orange, size: 16))
          else if (alert) 
            Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.red.shade200)), child: const Icon(Icons.priority_high, color: Colors.red, size: 16))
        ],
      ),
    );
  }
}
