import 'package:flutter/material.dart';
import 'admin_past_reports_screen.dart';

class AdminResidentProfileScreen extends StatelessWidget {
  final Map<String, dynamic> resident;

  const AdminResidentProfileScreen({super.key, required this.resident});

  @override
  Widget build(BuildContext context) {
    String name = resident['name'] ?? 'Unknown';
    String initial = name.isNotEmpty ? name.substring(0, 1) : '?';
    String age = resident['age']?.toString() ?? 'Unknown';
    String room = resident['room'] ?? 'Unknown';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildBlueHeader(context, name, initial, age, room),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    _buildBasicInfo(),
                    const SizedBox(height: 16),
                    _buildEmergencyContact(resident['emergency'] ?? '+91 9876543210'),
                    const SizedBox(height: 16),
                    _buildMedicalConditions(resident['medical'] ?? ''),
                    const SizedBox(height: 16),
                    _buildDailyMedications(),
                    const SizedBox(height: 16),
                    _buildDietaryRestrictions(),
                    const SizedBox(height: 32),
                    _buildActionButtons(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBlueHeader(BuildContext context, String name, String initial, String age, String room) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1D4ED8), // Deep Blue theme as shown in Image 3
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 40),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Back', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: Text(initial, style: const TextStyle(fontSize: 36, color: Color(0xFF1D4ED8), fontWeight: FontWeight.normal)),
          ),
          const SizedBox(height: 16),
          Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text('$age years • $room', style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return _buildCardSection(
      icon: Icons.person_outline,
      title: 'Basic Information',
      children: [
        _buildInfoRow('Blood Group', 'B+'),
        const SizedBox(height: 16),
        _buildInfoRow('Admission Date', '15 Jan 2024'),
        const SizedBox(height: 16),
        _buildInfoRow('Assigned Caretaker', 'Priya Sharma'),
      ],
    );
  }

  Widget _buildEmergencyContact(String number) {
    return _buildCardSection(
      icon: Icons.phone_in_talk_outlined,
      iconColor: Colors.green.shade600,
      title: 'Emergency Contact',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(number, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF048A39), // Green
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Call Now', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            )
          ],
        )
      ],
    );
  }

  Widget _buildMedicalConditions(String medicalStr) {
    List<String> conditions = medicalStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (medicalStr.isEmpty || medicalStr == 'Arthritis') {
      conditions = ['Diabetes', 'High Blood Pressure', 'Arthritis']; // Default explicitly mimicking mockup
    }

    return _buildCardSection(
      icon: Icons.favorite_outline,
      iconColor: Colors.red.shade600,
      title: 'Medical Conditions',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: conditions.map((c) => _buildRedPill(c)).toList(),
        )
      ],
    );
  }

  Widget _buildDailyMedications() {
    return _buildCardSection(
      icon: Icons.vaccines_outlined,
      iconColor: Colors.blue.shade600,
      title: 'Daily Medications',
      children: [
        _buildBlueListItem('Metformin 500mg - Morning'),
        const SizedBox(height: 12),
        _buildBlueListItem('Amlodipine 5mg - Evening'),
        const SizedBox(height: 12),
        _buildBlueListItem('Calcium tablets - Night'),
      ],
    );
  }

  Widget _buildDietaryRestrictions() {
    return _buildCardSection(
      icon: Icons.restaurant_outlined,
      iconColor: Colors.green.shade600,
      title: 'Dietary Restrictions',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildGreenPill('Low sugar'),
            _buildGreenPill('Low salt'),
            _buildGreenPill('High fiber'),
          ],
        )
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D4ED8), // Deep blue
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Add Daily Report', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPastReportsScreen()));
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('View Reports', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        )
      ],
    );
  }

  // Helpers

  Widget _buildCardSection({required IconData icon, required String title, required List<Widget> children, Color iconColor = const Color(0xFF1D4ED8)}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: Colors.blueGrey.shade900, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildRedPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(text, style: TextStyle(color: Colors.red.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildGreenPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Text(text, style: TextStyle(color: Colors.green.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildBlueListItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 6, color: Colors.blue.shade600),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
