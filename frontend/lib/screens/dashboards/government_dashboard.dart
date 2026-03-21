import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/government_provider.dart';

class GovernmentDashboard extends StatefulWidget {
  const GovernmentDashboard({super.key});

  @override
  State<GovernmentDashboard> createState() => _GovernmentDashboardState();
}

class _GovernmentDashboardState extends State<GovernmentDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GovernmentProvider>().fetchDashboardAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GovernmentProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildGreenHeader(provider),
            Expanded(
              child: provider.isLoading && provider.homes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : provider.error.isNotEmpty 
                  ? Center(child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)))
                  : _buildDashboardContent(provider),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF048A39),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(GovernmentProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildDropdown('All Districts')),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown('All Levels')),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF048A39), // Green
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text('Add Old Age Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Old Age Homes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('View All Alerts →', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          if (provider.homes.isEmpty)
             const Padding(padding: EdgeInsets.all(16.0), child: Text("No residential homes discovered yet.")),
          ...provider.homes.map((h) {
             bool pending = h['status'] == 'pending';
             return _buildHomeCard(
               h['name'] ?? 'Unknown Home',
               h['email'] ?? 'No contact',
               residents: 1,
               pending: pending ? 1 : 0, 
               alerts: 0,
               lastInspection: pending ? 'Awaiting Approval' : 'Approved',
               isOk: !pending,
               isWarning: pending,
               isAlert: false
             );
          }),
        ],
      ),
    );
  }

  Widget _buildGreenHeader(GovernmentProvider provider) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF059669),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Officer Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 4),
                  Text('Dept. of Social Welfare', style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
              Stack(
                children: [
                  const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                  Positioned(
                    right: 0, top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: const Text('8', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBox('${provider.homes.length}', 'Total Homes'),
              _buildStatBox('${provider.totalResidents}', 'Residents'),
              _buildStatBox('${provider.highRiskCount}', 'High Risk'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatBox(String val, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(fontSize: 14)),
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          items: const [],
          onChanged: (val) {},
        ),
      ),
    );
  }

  Widget _buildHomeCard(String name, String address, {required int residents, required int pending, required int alerts, required String lastInspection, bool isOk = false, bool isWarning = false, bool isAlert = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              if (isOk) Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.green, size: 16))
              else if (isWarning) Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.orange.shade100, shape: BoxShape.circle), child: const Icon(Icons.priority_high, color: Colors.orange, size: 16))
              else if (isAlert) Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.red.shade100, shape: BoxShape.circle), child: const Icon(Icons.priority_high, color: Colors.red, size: 16)),
            ],
          ),
          const SizedBox(height: 4),
          Text(address, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSmallDetailBox('$residents', 'Residents', Colors.blue)),
              const SizedBox(width: 8),
              Expanded(child: _buildSmallDetailBox('$pending', 'Pending', Colors.orange)),
              const SizedBox(width: 8),
              Expanded(child: _buildSmallDetailBox('$alerts', 'Alerts', Colors.red)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Last inspection: $lastInspection', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Review', style: TextStyle(color: Colors.black87)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSmallDetailBox(String val, String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color.shade700)),
          Text(label, style: TextStyle(fontSize: 11, color: color.shade700)),
        ],
      ),
    );
  }
}
