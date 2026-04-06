import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/caretaker_provider.dart';
import '../../providers/auth_provider.dart';

class DailyReportScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final dynamic resident;

  const DailyReportScreen({
    super.key,
    required this.onBack,
    required this.onSubmit,
    required this.resident,
  });

  @override
  State<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends State<DailyReportScreen> {
  // --- Form State ---
  bool breakfast = false;
  bool lunch = false;
  bool dinner = false;

  bool medicineGiven = false;
  String medicineTime = '--:--';

  String physicalActivity = 'Walking';

  bool bathingCompleted = false;
  bool clothesChanged = false;

  String mood = 'Happy';

  final TextEditingController _issuesController = TextEditingController();

  // --- Builders ---

  Widget _buildCard({required String title, required String emoji, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
          SizedBox(
            height: 24, // to make the switch feel tight like the UI image
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Colors.black,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioPill(String value) {
    bool isSelected = physicalActivity == value;
    return GestureDetector(
      onTap: () => setState(() => physicalActivity = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.circle : Icons.circle_outlined,
              size: 14,
              color: isSelected ? Colors.black : Colors.grey.shade300,
            ),
            const SizedBox(width: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(String label, IconData icon) {
    bool isSelected = mood == label;
    return GestureDetector(
      onTap: () => setState(() => mood = label),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.green : Colors.grey),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Blue Header
        Container(
          width: double.infinity,
          color: const Color(0xFF1E5EFC),
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text('Back', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Report for ${widget.resident['name']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text('Room ${widget.resident['room']} • 21 March 2026', style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),

        // Scrollable Body
        Expanded(
          child: Container(
            color: const Color(0xFFF6F9FF),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCard(
                  title: 'Meal Status',
                  emoji: '🍽️',
                  child: Column(
                    children: [
                      _buildSwitchRow('Breakfast', breakfast, (v) => setState(() => breakfast = v)),
                      _buildSwitchRow('Lunch', lunch, (v) => setState(() => lunch = v)),
                      _buildSwitchRow('Dinner', dinner, (v) => setState(() => dinner = v)),
                    ],
                  ),
                ),
                _buildCard(
                  title: 'Medicine',
                  emoji: '💊',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSwitchRow('Medicine Given', medicineGiven, (v) => setState(() => medicineGiven = v)),
                      const Text('Time', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(medicineTime, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                      ),
                    ],
                  ),
                ),
                _buildCard(
                  title: 'Physical Activity',
                  emoji: '🚶',
                  child: Column(
                    children: [
                      _buildRadioPill('Walking'),
                      _buildRadioPill('Light Exercise'),
                      _buildRadioPill('Bed Rest'),
                    ],
                  ),
                ),
                _buildCard(
                  title: 'Hygiene Care',
                  emoji: '🛁',
                  child: Column(
                    children: [
                      _buildSwitchRow('Bathing Completed', bathingCompleted, (v) => setState(() => bathingCompleted = v)),
                      _buildSwitchRow('Clothes Changed', clothesChanged, (v) => setState(() => clothesChanged = v)),
                    ],
                  ),
                ),
                _buildCard(
                  title: 'Mood Status',
                  emoji: '😊',
                  child: GridView.count(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.8,
                    children: [
                      _buildMoodCard('Happy', Icons.sentiment_very_satisfied),
                      _buildMoodCard('Normal', Icons.sentiment_neutral),
                      _buildMoodCard('Sad', Icons.sentiment_dissatisfied),
                      _buildMoodCard('Aggressive', Icons.warning_amber_rounded),
                    ],
                  ),
                ),
                _buildCard(
                  title: 'Any Issues or Injury',
                  emoji: '📝',
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _issuesController,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Describe any issues, injuries, or concerns...',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                _buildCard(
                  title: 'Photo Proof (Optional)',
                  emoji: '📷',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt_outlined, color: Colors.grey.shade500, size: 32),
                        const SizedBox(height: 8),
                        Text('Tap to upload photo', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final caretaker = context.read<CaretakerProvider>();
                    final auth = context.read<AuthProvider>();
                    
                    final success = await caretaker.submitDailyReport({
                      'elderly_id': widget.resident['id'],
                      'caretaker_id': auth.user?['id'],
                      'date': '2026-03-21', // Local date would be better but keeping consistency
                      'breakfast': breakfast,
                      'lunch': lunch,
                      'dinner': dinner,
                      'medicine_given': medicineGiven,
                      'medicine_time': medicineTime,
                      'physical_activity': physicalActivity,
                      'bathing': bathingCompleted,
                      'clothes_changed': clothesChanged,
                      'mood': mood,
                      'issues': _issuesController.text,
                      'photo_path': '', // Handle if needed
                    });

                    if (success) {
                      widget.onSubmit();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${caretaker.error}'))
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A843), // Exact matching green
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: context.watch<CaretakerProvider>().isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Submit Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
