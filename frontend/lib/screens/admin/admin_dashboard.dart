import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import 'admin_resident_profile_screen.dart';
import 'admin_alerts_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _residents = [
    {
      'name': 'Ramesh Kumar',
      'age': 72,
      'gender': 'Male',
      'room': 'Room 101',
      'medical': 'Diabetes, Hypertension',
      'emergency': '+91 9876543210',
      'admitted': '15 Jan 2023',
    },
    {
      'name': 'Lakshmi Devi',
      'age': 68,
      'gender': 'Female',
      'room': 'Room 102',
      'medical': 'Arthritis',
      'emergency': '+91 9876543211',
      'admitted': '20 Feb 2023',
    },
    {
      'name': 'Suresh Patel',
      'age': 75,
      'gender': 'Male',
      'room': 'Room 103',
      'medical': 'Heart Disease',
      'emergency': '+91 9876543212',
      'admitted': '10 Mar 2023',
    }
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchSystemOverview();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(int index, Map<String, dynamic> r) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This will permanently remove the resident from the system. This action cannot be undone.', style: TextStyle(color: Colors.black87)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _residents.remove(r);
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE50000),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          )
        ],
      )
    );
  }

  void _showAddResidentModal(BuildContext context) {
    final TextEditingController nameCtl = TextEditingController();
    final TextEditingController ageCtl = TextEditingController();
    final TextEditingController roomCtl = TextEditingController();
    String gender = 'Male';
    final TextEditingController medicalCtl = TextEditingController();
    final TextEditingController emergencyCtl = TextEditingController();
    final TextEditingController dateCtl = TextEditingController();
    
    String errorMsg = '';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Add New Resident', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close, size: 20, color: Colors.grey),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Enter the details of the new resident below.', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    const SizedBox(height: 24),
                    
                    _buildModalLabel('Full Name'),
                    _buildModalInput(nameCtl, 'Enter full name', hasBorder: true),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildModalLabel('Age'),
                            _buildModalInput(ageCtl, 'Age', hasBorder: false),
                          ],
                        )),
                        const SizedBox(width: 16),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildModalLabel('Room Number'),
                            _buildModalInput(roomCtl, 'Room #', hasBorder: false),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildModalLabel('Gender'),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: gender,
                          isExpanded: true,
                          items: ['Male', 'Female', 'Other'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                          onChanged: (val) {
                            if (val != null) setModalState(() => gender = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildModalLabel('Medical Conditions'),
                    _buildModalInput(medicalCtl, 'e.g., Diabetes, Hypertension', hasBorder: false),
                    const SizedBox(height: 16),

                    _buildModalLabel('Emergency Contact'),
                    _buildModalInput(emergencyCtl, '+91 XXXXXXXXXX', hasBorder: false),
                    const SizedBox(height: 16),

                    _buildModalLabel('Admission Date'),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: dateCtl,
                        decoration: InputDecoration(
                          hintText: '22-03-2026',
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          suffixIcon: Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey.shade400),
                        ),
                      ),
                    ),

                    if (errorMsg.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(errorMsg, style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Cancel', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameCtl.text.isEmpty || ageCtl.text.isEmpty || roomCtl.text.isEmpty || medicalCtl.text.isEmpty || emergencyCtl.text.isEmpty || dateCtl.text.isEmpty) {
                                setModalState(() {
                                  errorMsg = 'All fields are required';
                                });
                                return;
                              }
                              
                              setState(() {
                                _residents.insert(0, {
                                  'name': nameCtl.text,
                                  'age': int.tryParse(ageCtl.text) ?? 60,
                                  'gender': gender,
                                  'room': roomCtl.text.contains('Room') ? roomCtl.text : 'Room ${roomCtl.text}',
                                  'medical': medicalCtl.text,
                                  'emergency': emergencyCtl.text,
                                  'admitted': dateCtl.text,
                                });
                              });
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD8B4FE), // Light purple from reference
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Add Resident', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  Widget _buildModalLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }

  Widget _buildModalInput(TextEditingController controller, String hint, {required bool hasBorder}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: hasBorder ? Colors.white : Colors.grey.shade50,
        border: hasBorder ? Border.all(color: Colors.grey.shade400) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int total = _residents.length;
    int male = _residents.where((r) => r['gender'] == 'Male').length;
    int female = _residents.where((r) => r['gender'] == 'Female').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: Column(
          children: [
            if (_selectedIndex == 0) _buildPurpleHeader(total, male, female),
            Expanded(
              child: _selectedIndex == 0 
                  ? _buildDashboardContent()
                  : _selectedIndex == 1
                      ? AdminAlertsScreen(onBack: () => setState(() => _selectedIndex = 0))
                      : Center(child: Text('Profile', style: const TextStyle(fontSize: 18, color: Colors.grey))),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF8B21C6),
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name or room number...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9333EA), // Purple button
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            onPressed: () => _showAddResidentModal(context),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Add New Resident', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('All Residents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
                child: Text('${_residents.length} Residents', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Builder(
            builder: (context) {
              String query = _searchController.text.toLowerCase();
              List<Map<String, dynamic>> filteredList = _residents.where((r) {
                return r['name'].toString().toLowerCase().contains(query) ||
                       r['room'].toString().toLowerCase().contains(query);
              }).toList();

              if (filteredList.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text("No residents found.", style: TextStyle(color: Colors.grey.shade500))),
                );
              }

              return Column(
                children: filteredList.asMap().entries.map((entry) {
                  return _buildResidentCard(entry.value, entry.key);
                }).toList(),
              );
            }
          )
        ],
      ),
    );
  }

  Widget _buildResidentCard(Map<String, dynamic> r, int index) {
    String initial = r['name'].toString().substring(0, 1);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF9333EA),
                child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                    const SizedBox(height: 2),
                    Text('${r['age']} years  •  ${r['gender']}  •  ${r['room']}', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 13)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Medical:', r['medical']),
          const SizedBox(height: 8),
          _buildInfoRow('Emergency:', r['emergency']),
          const SizedBox(height: 8),
          _buildInfoRow('Admitted:', r['admitted']),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AdminResidentProfileScreen(resident: r)));
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('View Profile', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => _confirmDelete(index, r),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red.shade100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  backgroundColor: Colors.red.shade50,
                ),
                child: Icon(Icons.delete_outline, color: Colors.red.shade600, size: 20),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 80, child: Text(label, style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 13))),
        Expanded(child: Text(value, style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 13))),
      ],
    );
  }

  Widget _buildPurpleHeader(int total, int male, int female) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF8B21C6), // Deep purple
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 4),
                  Text('Manage Residents & Facilities', style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 1),
                child: Stack(
                  children: [
                    const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                    Positioned(
                      right: 0, top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: const Text('2', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildStatBox(total.toString(), 'Total')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatBox(male.toString(), 'Male')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatBox(female.toString(), 'Female')),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatBox(String val, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
