import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';

class AdminPastReportsScreen extends StatelessWidget {
  const AdminPastReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<AdminProvider>().reports;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B21C6),
        title: const Text('Past Reports', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/dashboard/admin', (route) => false),
        ),
      ),
      body: SafeArea(
        child: reports.isEmpty
            ? const Center(child: Text('No historical reports found.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final r = reports[index];
                  final isAttention = r['issues'] != null && r['issues'].toString().trim().isNotEmpty;
                  final color = isAttention ? Colors.red : Colors.green;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              r['elderly_name'] ?? 'Unknown',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isAttention ? 'Attention' : 'Good',
                                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Home: ${r['home_name']} | Room: ${r['room'] ?? 'N/A'}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('Date: ${r['date']}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        if (isAttention) ...[
                          const SizedBox(height: 8),
                          Text('Issues: ${r['issues']}', style: TextStyle(color: Colors.red.shade700, fontSize: 13, fontWeight: FontWeight.w500)),
                        ]
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
