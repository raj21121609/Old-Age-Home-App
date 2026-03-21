import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/caretaker_provider.dart';

class CaretakerDashboard extends StatefulWidget {
  const CaretakerDashboard({super.key});

  @override
  State<CaretakerDashboard> createState() => _CaretakerDashboardState();
}

class _CaretakerDashboardState extends State<CaretakerDashboard> {
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

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(name),
            if (provider.error == 'EMERGENCY ALERT BROADCASTED SECURELY') 
               Container(width: double.infinity, color: Colors.red, padding: const EdgeInsets.all(12), child: Text(provider.error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            Expanded(
              child: provider.isLoading && provider.elderly.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : provider.error.isNotEmpty && provider.error != 'EMERGENCY ALERT BROADCASTED SECURELY'
                  ? Center(child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)))
                  : _buildElderlyList(provider.elderly),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildElderlyList(List<dynamic> residents) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Elderly Residents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
                child: Text('${residents.length} Total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (residents.isEmpty)
             const Padding(padding: EdgeInsets.all(16.0), child: Text("No residents assigned.")),
          ...residents.map((e) {
            String eName = e['name'] ?? 'Unknown';
            int eAge = e['age'] ?? 0;
            String eStatus = e['health_status'] ?? 'Good';
            bool isOk = eStatus.toLowerCase() == 'good';
            bool isAlert = eStatus.toLowerCase() == 'critical';
            bool isWarning = !isOk && !isAlert;
            
            return _buildResidentCard(
              eName, '$eAge years', 'Status: $eStatus', eName.isNotEmpty ? eName[0] : '?', Colors.blue, isOk, warning: isWarning, alert: isAlert
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopHeader(String name) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            color: Color(0xFF1E5EFC),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Welcome, $name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                      // Notifications System hook
                      Positioned(right: 0, top: 0, child: Container(padding: const EdgeInsets.all(3), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: const Text('3', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))))
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              const Text('Sunshine Old Age Home', style: TextStyle(fontSize: 14, color: Colors.white70)),
              const Spacer(),
              const Text('Today\'s Date', style: TextStyle(fontSize: 12, color: Colors.white70)),
              const Text('Friday, 20 March 2026', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Positioned(
          bottom: 0, left: 16, right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionCard('Add Report', Icons.description_outlined, Colors.blue, callback: () {}),
              _buildActionCard('Past Reports', Icons.home_outlined, Colors.green, callback: () {}),
              _buildActionCard('Emergency', Icons.error_outline, Colors.red, callback: _triggerEmergency),
            ],
          ),
        )
      ],
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
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
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
          if (ok) Icon(Icons.check_circle, color: Colors.green.shade300)
          else if (warning) Icon(Icons.hourglass_bottom, color: Colors.orange.shade300)
          else if (alert) Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.red.shade100, shape: BoxShape.circle), child: const Icon(Icons.priority_high, color: Colors.red, size: 16))
        ],
      ),
    );
  }
}
