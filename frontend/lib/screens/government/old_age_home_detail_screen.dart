import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/government_provider.dart';
import 'report_detail_screen.dart';

class OldAgeHomeDetailScreen extends StatefulWidget {
  final int homeId;
  final String homeName;
  final String homeLocation;
  final int residents;
  final VoidCallback? onBack;

  const OldAgeHomeDetailScreen({
    super.key,
    required this.homeId,
    required this.homeName,
    required this.homeLocation,
    required this.residents,
    this.onBack,
  });

  @override
  State<OldAgeHomeDetailScreen> createState() => _OldAgeHomeDetailScreenState();
}

class _OldAgeHomeDetailScreenState extends State<OldAgeHomeDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.homeId != 0) {
        context.read<GovernmentProvider>().fetchHomeReports(widget.homeId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                          ]
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey.shade700,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                        tabs: const [
                          Tab(text: 'Reports'),
                          Tab(text: 'Alerts'),
                          Tab(text: 'History'),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildReportsTab(context, filter: 'today'),
                      _buildReportsTab(context, filter: 'alerts'),
                      _buildReportsTab(context, filter: 'history'),
                    ],
                  ),
                ),
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
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.pop(context),
            child: const Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Back', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(widget.homeName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(widget.homeLocation, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildReportsTab(BuildContext context, {required String filter}) {
    final provider = context.watch<GovernmentProvider>();
    
    // Simple filter logic
    // We assume 'date' is YYYY-MM-DD. For now, we simulate filter behavior based on the requirement.
    // Real app might compare with DateTime.now().
    final nowStr = DateTime.now().toIso8601String().split('T')[0];
    
    List<dynamic> filteredReports = provider.reports.where((r) {
      final rDate = r['date'] ?? '';
      final isAttention = r['issues'] != null && r['issues'].toString().trim().isNotEmpty;
      
      if (filter == 'alerts') return isAttention;
      if (filter == 'history') return true; // Just show all past reports for now or rDate != nowStr if we were strict
      return true; // default 'today' / all
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                filter == 'alerts' ? 'Active Alerts' : filter == 'history' ? 'Report History' : 'Daily Reports', 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list, size: 16, color: Colors.blue),
                label: const Text('Filter', style: TextStyle(color: Colors.blue)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              )
            ],
          ),
          const SizedBox(height: 16),
          if (provider.isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator())),
          if (!provider.isLoading && filteredReports.isEmpty)
            Center(child: Padding(padding: const EdgeInsets.all(32.0), child: Text('No entries found for ${filter == 'alerts' ? 'alerts' : filter}.'))),
          ...filteredReports.map((r) {
            final bool isAttention = r['issues'] != null && r['issues'].toString().trim().isNotEmpty;
            return _buildReportCard(
              report: r,
              name: r['elderly_name'] ?? 'Unknown',
              status: isAttention ? 'Attention' : 'Normal',
              room: 'Room ${r['room'] ?? 'N/A'}',
              date: r['date'] ?? '',
              caretaker: r['caretaker_name'] ?? 'Assigned Staff',
              isNormal: !isAttention,
              isAttention: isAttention,
              issueText: isAttention ? r['issues'] : null,
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required dynamic report,
    required String name,
    required String status,
    required String room,
    required String date,
    required String caretaker,
    bool isNormal = false,
    bool isAttention = false,
    bool isMissing = false,
    String? issueText,
  }) {
    Color cardBorder = Colors.grey.shade200;
    Color cardBg = Colors.white;

    if (isAttention) {
      cardBorder = Colors.red.shade200;
      cardBg = Colors.red.shade50.withOpacity(0.3);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportDetailScreen(
              report: report,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cardBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(width: 8),
                    _buildBadge(status, isNormal, isAttention, isMissing),
                  ],
                ),
                if (isNormal) const Icon(Icons.image_outlined, color: Colors.blue, size: 20),
              ],
            ),
            const SizedBox(height: 6),
            Text('$room • $date', style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 13)),
            const SizedBox(height: 16),
            if (!isMissing)
              Text('Caretaker: $caretaker', style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 13)),
            if (issueText != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMissing ? Colors.grey.shade100 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 16, color: isMissing ? Colors.grey.shade600 : Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(child: Text(issueText, style: TextStyle(color: isMissing ? Colors.grey.shade700 : Colors.red.shade700, fontSize: 13))),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String status, bool isNormal, bool isAttention, bool isMissing) {
    Color bg = Colors.grey.shade100;
    Color border = Colors.grey.shade300;
    Color text = Colors.grey.shade700;

    if (isNormal) {
      bg = Colors.green.shade50;
      border = Colors.green.shade200;
      text = Colors.green.shade700;
    } else if (isAttention) {
      bg = Colors.red.shade50;
      border = Colors.red.shade200;
      text = Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Text(status, style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
