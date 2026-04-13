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
  String _selectedDistrict = 'All Regions';
  String _selectedRating = 'Rating: All';

  Set<String> _availableRegions = {'All Regions'};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GovernmentProvider>().fetchDashboardAnalytics();
    });
  }

  int _calculateComplianceScore(Map<String, dynamic> h) {
    int score = 100;
    int alerts = (h['alerts_count'] as num?)?.toInt() ?? 0;
    bool pending = h['status'] == 'pending';
    int pendingCount = (h['pending_count'] as num?)?.toInt() ?? (pending ? 1 : 0);
    score -= (alerts * 15);
    score -= (pendingCount * 10);
    return score < 0 ? 0 : score;
  }
  
  String _getRatingText(int score) {
    if (score >= 90) return 'Outstanding';
    if (score >= 75) return 'Good';
    return 'Requires Imp.';
  }

  Color _getRatingColor(int score) {
    if (score >= 90) return Colors.green.shade700;
    if (score >= 75) return Colors.blue.shade700;
    return Colors.red.shade700;
  }

  void _showAddHomeDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final districtCtrl = TextEditingController();

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
                    Text('Register a new facility for monitoring.', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                _buildLabel('Facility Name'),
                _buildTextField(nameCtrl, 'Enter facility name'),
                const SizedBox(height: 16),
                _buildLabel('Location/Region'),
                _buildTextField(locationCtrl, 'e.g., South East'),
                const SizedBox(height: 16),
                _buildLabel('City (Optional)'),
                _buildTextField(districtCtrl, 'e.g., London'),
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
                          backgroundColor: const Color(0xFF048A39), // Dark green
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (nameCtrl.text.isNotEmpty && locationCtrl.text.isNotEmpty) {
                            context.read<GovernmentProvider>().addHome({
                              'name': nameCtrl.text,
                              'location': locationCtrl.text,
                              'district': districtCtrl.text,
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF048A39))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GovernmentProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            if (_selectedIndex == 0) _buildTopHeader(),
            Expanded(
              child: _selectedIndex == 1 
                  ? OldAgeHomeDetailScreen(
                      homeId: 0,
                      homeName: 'All Active Facilities',
                      homeLocation: 'Consolidated View',
                      residents: provider.totalResidents,
                      onBack: () => setState(() => _selectedIndex = 0),
                    )
                  : _selectedIndex == 2 
                      ? GovernmentAlertsScreen(onBack: () => setState(() => _selectedIndex = 0)) 
                      : _selectedIndex == 3 
                          ? GovernmentProfileScreen(onBack: () => setState(() => _selectedIndex = 0))
                          : provider.isLoading && provider.homes.isEmpty
                              ? const Center(child: CircularProgressIndicator(color: Color(0xFF048A39)))
                              : provider.error.isNotEmpty 
                                  ? Center(child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)))
                                  : _buildDashboardContent(provider, context),
            )
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 0 
          ? FloatingActionButton(
              onPressed: () => _showAddHomeDialog(context),
              backgroundColor: const Color(0xFF048A39),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ]
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: const Color(0xFF048A39),
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedIndex == 0 ? const Color(0xFF048A39) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.grid_view_rounded, color: _selectedIndex == 0 ? Colors.white : Colors.grey.shade500),
              ),
              label: 'OVERVIEW',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.people_alt_outlined, color: _selectedIndex == 1 ? const Color(0xFF048A39) : Colors.grey.shade500),
              ),
              label: 'FACILITIES',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.bar_chart_rounded, color: _selectedIndex == 2 ? const Color(0xFF048A39) : Colors.grey.shade500),
              ),
              label: 'ALERTS',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.settings_outlined, color: _selectedIndex == 3 ? const Color(0xFF048A39) : Colors.grey.shade500),
              ),
              label: 'SETTINGS',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: const Color(0xFFF7F8FA),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.orange.shade100,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=admin'),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Compliance & Monitoring',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                'GOOD MORNING, ADMIN',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade700, letterSpacing: 0.5),
              )
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(onPressed: () => setState(() => _selectedIndex = 2), icon: const Icon(Icons.notifications_none_rounded, color: Colors.black54)),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              )
            ],
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(GovernmentProvider provider, BuildContext context) {
    _availableRegions.clear();
    _availableRegions.add('All Regions');
    for (var h in provider.homes) {
      if (h['location'] != null && h['location'].toString().isNotEmpty) {
        _availableRegions.add(h['location'].toString());
      } else if (h['district'] != null && h['district'].toString().isNotEmpty) {
        _availableRegions.add(h['district'].toString());
      }
    }

    final mappedList = provider.homes.map((h) {
      bool pending = h['status'] == 'pending';
      int residents = (h['actual_residents_count'] as num?)?.toInt() ?? 0;
      int pendingReports = (h['pending_count'] as num?)?.toInt() ?? (pending ? 1 : 0);
      int alerts = (h['alerts_count'] as num?)?.toInt() ?? 0;
      
      String name = h['name'] ?? 'Unknown Facility';
      String region = h['location'] ?? h['district'] ?? 'General Region';
      
      int score = _calculateComplianceScore(h);
      
      bool isOk = false;
      bool isWarning = false;
      bool isAlert = false;
      
      if (pending || pendingReports > 0) {
        isWarning = true;
      } else if (alerts > 0) {
        isAlert = true;
      } else {
        isOk = true;
      }

      return {
        'homeId': h['id'], 'name': name, 'region': region, 'residents': residents,
        'pending': pendingReports, 'alerts': alerts, 'score': score,
        'isOk': isOk, 'isWarning': isWarning, 'isAlert': isAlert
      };
    }).where((data) {
      if (_selectedDistrict != 'All Regions' && data['region'] != _selectedDistrict) return false;
      if (_selectedRating != 'Rating: All') {
        String rating = _getRatingText(data['score'] as int);
        if (_selectedRating == 'Rating: Outstanding' && rating != 'Outstanding') return false;
        if (_selectedRating == 'Rating: Good' && rating != 'Good') return false;
        if (_selectedRating == 'Rating: Requires Imp.' && rating != 'Requires Imp.') return false;
      }
      return true;
    }).toList();

    int totalScore = 0;
    int pendingReviewsTotal = 0;
    for (var m in mappedList) {
      totalScore += m['score'] as int;
      pendingReviewsTotal += m['pending'] as int;
    }
    double averageScore = mappedList.isNotEmpty ? (totalScore / mappedList.length) : 0.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Regional Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.download_rounded, color: Colors.green.shade600, size: 16),
                    const SizedBox(width: 4),
                    Text('Export Report', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Filters
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ..._availableRegions.map((region) => _buildFilterChip(
                  region, 
                  _selectedDistrict == region,
                  () => setState(() => _selectedDistrict = region),
                )),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRating,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                      style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
                      items: ['Rating: All', 'Rating: Outstanding', 'Rating: Good', 'Rating: Requires Imp.'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedRating = val);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Metrics Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Global Compliance Average', style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${averageScore.toStringAsFixed(1)}%', style: TextStyle(color: Colors.green.shade800, fontSize: 42, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: averageScore / 100,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('+2.4% from LY', style: TextStyle(color: Colors.green.shade800, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6E2FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.verified_rounded, color: Colors.blue, size: 18),
                            ),
                            const SizedBox(height: 16),
                            const Text('Total Facilities', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${mappedList.length}', style: TextStyle(color: Colors.blue.shade900, fontSize: 24, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFBBA4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
                              child: const Icon(Icons.warning_amber_rounded, color: Colors.deepOrange, size: 18),
                            ),
                            const SizedBox(height: 16),
                            const Text('Pending Reviews', style: TextStyle(color: Colors.brown, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('$pendingReviewsTotal', style: TextStyle(color: Colors.brown.shade900, fontSize: 24, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Active Facilities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.grid_view_rounded, size: 16, color: Colors.black87),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.menu_rounded, size: 20, color: Colors.black45),
                  ],
                )
              ],
            ),
          ),
          
          const SizedBox(height: 16),

          // Facility Cards
          if (mappedList.isEmpty)
             const Padding(padding: EdgeInsets.all(20.0), child: Text("No facilities match the criteria.", style: TextStyle(color: Colors.grey))),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: mappedList.length,
            itemBuilder: (context, index) {
              final data = mappedList[index];
              return _buildFacilityCard(
                context,
                data['homeId'] as int,
                data['name'].toString(),
                data['region'].toString(),
                data['score'] as int,
                data['isOk'] as bool,
                data['isWarning'] as bool,
                data['isAlert'] as bool,
              );
            },
          ),
          const SizedBox(height: 80), // Padding for bottom nav and FAB
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

  Widget _buildFacilityCard(BuildContext context, int homeId, String name, String region, int score, bool isOk, bool isWarning, bool isAlert) {
    String badgeText = 'MONITORING';
    Color badgeColor = Colors.blue;
    if (isOk) {
      badgeText = 'COMPLIANT';
      badgeColor = Colors.green;
    } else if (isWarning || isAlert) {
      badgeText = 'REVIEW REQUIRED';
      badgeColor = Colors.red;
    }
    
    // Fallback images based on hash of id to keep them consistent
    final imageUrl = 'https://picsum.photos/seed/$homeId/600/300';
    
    String ratingText = _getRatingText(score);
    Color ratingColor = _getRatingColor(score);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OldAgeHomeDetailScreen(
              homeId: homeId,
              homeName: name,
              homeLocation: region,
              residents: 0,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  child: Image.network(
                    imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      height: 140, width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.home_work_rounded, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text(badgeText, style: TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('RATING', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black45)),
                          Text(ratingText, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ratingColor)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(region, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Compliance Score', style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('$score', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                            const Text('/100', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

