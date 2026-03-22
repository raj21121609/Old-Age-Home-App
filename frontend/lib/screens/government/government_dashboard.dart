import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/government_provider.dart';
import 'old_age_home_detail_screen.dart';
import 'government_alerts_screen.dart';
import 'government_profile_screen.dart';

class GovernmentDashboard extends StatefulWidget {
  const GovernmentDashboard({super.key});

  @override
  State<GovernmentDashboard> createState() => _GovernmentDashboardState();
}

class _GovernmentDashboardState extends State<GovernmentDashboard> {
  int _selectedIndex = 0;
  String _selectedDistrict = 'All Districts';
  String _selectedLevel = 'All Levels';

  final List<String> _districts = ['All Districts', 'New Delhi', 'Noida', 'Gurgaon'];
  final List<String> _levels = ['All Levels', 'High Risk', 'Medium Risk', 'Low Risk'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GovernmentProvider>().fetchDashboardAnalytics();
    });
  }

  void _showAddHomeDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final districtCtrl = TextEditingController();
    final residentsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(24),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 24, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add New Old Age Home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Register a new old age home for monitoring.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(
                padding: const EdgeInsets.only(top: 24, right: 16),
                icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                onPressed: () => Navigator.pop(ctx),
              )
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Home Name'),
                _buildTextField(nameCtrl, 'Enter home name'),
                const SizedBox(height: 16),
                _buildLabel('Location'),
                _buildTextField(locationCtrl, 'e.g., Connaught Place'),
                const SizedBox(height: 16),
                _buildLabel('District'),
                _buildTextField(districtCtrl, 'e.g., New Delhi'),
                const SizedBox(height: 16),
                _buildLabel('Total Residents'),
                _buildTextField(residentsCtrl, 'Number of residents', keyboardType: TextInputType.number),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6ED196), // light green matching the screenshot
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // basic validation
                          if (nameCtrl.text.isNotEmpty && locationCtrl.text.isNotEmpty) {
                            context.read<GovernmentProvider>().addHome({
                              'name': nameCtrl.text,
                              'location': locationCtrl.text,
                              'district': districtCtrl.text,
                              'residents': residentsCtrl.text,
                            });
                            Navigator.pop(ctx);
                          }
                        },
                        child: const Text('Add Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, {TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.green)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GovernmentProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Column(
          children: [
            if (_selectedIndex == 0) _buildGreenHeader(provider),
            Expanded(
              child: _selectedIndex == 1 
                  ? OldAgeHomeDetailScreen(
                      homeName: 'All Old Age Homes',
                      homeLocation: 'Consolidated Overview',
                      residents: provider.totalResidents,
                      onBack: () => setState(() => _selectedIndex = 0),
                    )
                  : _selectedIndex == 2 
                      ? GovernmentAlertsScreen(onBack: () => setState(() => _selectedIndex = 0)) 
                      : _selectedIndex == 3 
                          ? GovernmentProfileScreen(onBack: () => setState(() => _selectedIndex = 0))
                          : provider.isLoading && provider.homes.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : provider.error.isNotEmpty 
                                  ? Center(child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)))
                                  : _buildDashboardContent(provider, context),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF048A39),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildGreenHeader(GovernmentProvider provider) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF048A39),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 32),
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
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 2),
                child: Stack(
                  children: [
                    const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                    Positioned(
                      right: 0, top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: const Text('8', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(GovernmentProvider provider, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildDropdown('All Districts', _selectedDistrict, _districts, (val) => setState(() => _selectedDistrict = val ?? 'All Districts'))),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown('All Levels', _selectedLevel, _levels, (val) => setState(() => _selectedLevel = val ?? 'All Levels'))),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF048A39), // Green
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: () => _showAddHomeDialog(context),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Add Old Age Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Old Age Homes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 2),
                child: Text('View All Alerts →', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600, fontSize: 14)),
              )
            ],
          ),
          const SizedBox(height: 16),
          if (provider.homes.isEmpty)
             const Padding(padding: EdgeInsets.all(16.0), child: Text("No residential homes discovered yet.", style: TextStyle(color: Colors.grey))),
          ...(() {
            final mappedList = provider.homes.map((h) {
              bool pending = h['status'] == 'pending';
              int residents = h['residents_count'] ?? 32;
              int pendingReports = h['pending_count'] ?? (pending ? 1 : 0);
              int alerts = h['alerts_count'] ?? 0;
              String lastInspection = pending ? 'Awaiting Approval' : '5 days ago';
              String name = h['name'] ?? 'Unknown Home';
              String address = h['location'] ?? 'Location not specified';
              if (h['city'] != null && h['city'].toString().isNotEmpty) {
                address += ', ${h['city']}';
              }
              bool isOk = false;
              bool isWarning = false;
              bool isAlert = false;
              if (pending) {
                isWarning = true; pendingReports = 8; alerts = 2; lastInspection = '12 days ago';
              } else {
                if (alerts > 0) {
                  isAlert = true;
                } else {
                  isOk = true; residents = 45; pendingReports = 2; alerts = 0;
                }
              }
              return {
                'h': h, 'name': name, 'address': address, 'residents': residents,
                'pending': pendingReports, 'alerts': alerts, 'lastInspection': lastInspection,
                'isOk': isOk, 'isWarning': isWarning, 'isAlert': isAlert
              };
            }).where((data) {
              String riskLevel = 'Low Risk';
              if (data['isAlert'] == true) riskLevel = 'High Risk';
              else if (data['isWarning'] == true) riskLevel = 'Medium Risk';
              
              String addressStr = data['address'].toString();
              String cityStr = (data['h'] as Map)['city']?.toString() ?? '';
              
              bool matchDistrict = _selectedDistrict == 'All Districts' || addressStr.contains(_selectedDistrict) || cityStr == _selectedDistrict;
              bool matchLevel = _selectedLevel == 'All Levels' || riskLevel == _selectedLevel;
              return matchDistrict && matchLevel;
            }).toList();

            if (mappedList.isEmpty && provider.homes.isNotEmpty) {
              return [const Padding(padding: EdgeInsets.all(16.0), child: Text("No homes match the selected filters.", style: TextStyle(color: Colors.grey)))];
            }

            return mappedList.map((data) => _buildHomeCard(
              context,
              data['name'].toString(),
              data['address'].toString(),
              residents: data['residents'] as int,
              pending: data['pending'] as int,
              alerts: data['alerts'] as int,
              lastInspection: data['lastInspection'].toString(),
              isOk: data['isOk'] as bool,
              isWarning: data['isWarning'] as bool,
              isAlert: data['isAlert'] as bool,
            ));
          })(),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(fontSize: 14)),
          icon: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey.shade600),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildHomeCard(BuildContext context, String name, String address, {required int residents, required int pending, required int alerts, required String lastInspection, bool isOk = false, bool isWarning = false, bool isAlert = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OldAgeHomeDetailScreen(
              homeName: name,
              homeLocation: address,
              residents: residents,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                if (isOk) Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.green.shade200)), child: const Icon(Icons.check, color: Colors.green, size: 16))
                else if (isWarning) Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.amber.shade300)), child: const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 16))
                else if (isAlert) Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.red.shade200)), child: const Icon(Icons.priority_high, color: Colors.red, size: 16)),
              ],
            ),
            const SizedBox(height: 6),
            Text(address, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 13)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildSmallDetailBox('$residents', 'Residents', Colors.blue)),
                const SizedBox(width: 8),
                Expanded(child: _buildSmallDetailBox('$pending', 'Pending', Colors.amber)),
                const SizedBox(width: 8),
                Expanded(child: _buildSmallDetailBox('$alerts', 'Alerts', Colors.red)),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Last inspection: $lastInspection', style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 12)),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OldAgeHomeDetailScreen(
                          homeName: name,
                          homeLocation: address,
                          residents: residents,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: const Text('Review Reports', style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSmallDetailBox(String val, String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: color.shade700)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: color.shade800)),
        ],
      ),
    );
  }
}
