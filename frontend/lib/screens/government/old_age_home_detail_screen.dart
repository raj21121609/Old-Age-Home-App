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
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(context),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildFacilitySummary(),
                  const SizedBox(height: 16),
                  _buildTabSection(),
                  const SizedBox(height: 16),
                  _buildReportsList(),
                  const SizedBox(height: 48),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onBack ?? () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black87),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.homeId == 0 ? 'Facility Network' : 'Facility Details',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                'MONITORING ACTIVE',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade700, letterSpacing: 0.5),
              )
            ],
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildFacilitySummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.homeName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(widget.homeLocation, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildSmallStat('RESIDENTS', '${widget.residents}', Colors.blue),
                const SizedBox(width: 12),
                _buildSmallStat('AVG. SCORE', '94.2%', Colors.green),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
            ],
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade600,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Reports'),
            Tab(text: 'Alerts'),
            Tab(text: 'Staff'),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    final provider = context.watch<GovernmentProvider>();
    final reports = provider.reports;

    if (provider.isLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()));
    }

    if (reports.isEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(48.0), child: Text('No entries found.', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold))));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: reports.map((r) {
          final bool isAttention = r['issues'] != null && r['issues'].toString().trim().isNotEmpty;
          return _buildReportCard(
            report: r,
            name: r['elderly_name'] ?? 'Unknown',
            status: isAttention ? 'ATTENTION' : 'STABLE',
            room: 'Room ${r['room'] ?? 'N/A'}',
            date: r['date'] ?? '',
            caretaker: r['caretaker_name'] ?? 'Staff',
            isAttention: isAttention,
          );
        }).toList(),
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
    bool isAttention = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReportDetailScreen(report: report)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))
          ],
          border: Border.all(color: isAttention ? Colors.red.shade100 : Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAttention ? Colors.red.shade50 : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: isAttention ? Colors.red : Colors.green, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.meeting_room_outlined, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text('$room • $date', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 10, backgroundColor: Colors.grey.shade200, child: const Icon(Icons.person, size: 12, color: Colors.black45)),
                    const SizedBox(width: 8),
                    Text(caretaker, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade300),
              ],
            )
          ],
        ),
      ),
    );
  }
}

