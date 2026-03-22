import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  final String name;
  final String status;
  final String room;
  final String date;
  final String caretaker;
  final bool isAttention;

  const ReportDetailScreen({
    super.key,
    required this.name,
    required this.status,
    required this.room,
    required this.date,
    required this.caretaker,
    this.isAttention = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  _buildProfileCard(),
                  const SizedBox(height: 16),
                  _buildMealsCard(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildMedicineCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildActivityCard()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildHygieneCard(),
                  const SizedBox(height: 16),
                  _buildMoodCard(),
                  if (isAttention) ...[
                    const SizedBox(height: 16),
                    _buildIssuesCard(),
                  ],
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                ],
              ),
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
            onTap: () => Navigator.pop(context),
            child: const Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Back to Reports', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Report Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
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
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue.shade600,
                child: Text(name.isNotEmpty ? name[0] : 'U', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isAttention ? Colors.red.shade50 : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isAttention ? Colors.red.shade200 : Colors.green.shade200),
                          ),
                          child: Text(status, style: TextStyle(color: isAttention ? Colors.red.shade700 : Colors.green.shade700, fontSize: 11, fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(room, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 13)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          Text('Caretaker: $caretaker', style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildMealsCard() {
    return _buildDetailSection(
      icon: Icons.restaurant,
      title: 'Meals',
      child: Column(
        children: [
          _buildRowItem('Breakfast', isAttention ? false : true, yesText: 'Yes', noText: 'No'),
          const SizedBox(height: 12),
          _buildRowItem('Lunch', isAttention ? false : true, yesText: 'Yes', noText: 'No'),
          const SizedBox(height: 12),
          _buildRowItem('Dinner', isAttention ? false : true, yesText: 'Yes', noText: 'No'),
        ],
      ),
    );
  }

  Widget _buildMedicineCard() {
    return _buildDetailSection(
      icon: Icons.medical_services_outlined,
      iconColor: Colors.red,
      title: 'Medicine',
      child: isAttention 
        ? const Row(
            children: [
              Icon(Icons.close, color: Colors.red, size: 16),
              SizedBox(width: 4),
              Text('Not Given', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          )
        : const Row(
            children: [
              Icon(Icons.check, color: Colors.green, size: 16),
              SizedBox(width: 4),
              Text('Given', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
    );
  }

  Widget _buildActivityCard() {
    return _buildDetailSection(
      icon: Icons.directions_walk,
      iconColor: Colors.orange,
      title: 'Activity',
      child: Text(isAttention ? 'Bed Rest' : 'Light Walk', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildHygieneCard() {
    return _buildDetailSection(
      icon: Icons.cleaning_services_outlined,
      iconColor: Colors.blue,
      title: 'Hygiene',
      child: Column(
        children: [
          _buildRowItem('Bathing', isAttention ? false : true, noText: 'Not Done', yesText: 'Done'),
          const SizedBox(height: 12),
          _buildRowItem('Clothes Changed', isAttention ? false : true, noText: 'Not Done', yesText: 'Done'),
        ],
      ),
    );
  }

  Widget _buildMoodCard() {
    return _buildDetailSection(
      icon: Icons.mood,
      iconColor: Colors.orange,
      title: 'Mood Status',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isAttention ? Colors.blue.shade50 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(isAttention ? 'Sad' : 'Happy', style: TextStyle(color: isAttention ? Colors.blue.shade700 : Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  Widget _buildIssuesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 20),
              const SizedBox(width: 8),
              Text('Issues Reported', style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Not feeling well, refused to eat', style: TextStyle(color: Colors.red.shade900, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF048A39),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                label: const Text('Verify', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: Colors.grey.shade300),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: const Text('Send Warning', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: Colors.blue.shade600),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text('Schedule Inspection', style: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: Colors.red.shade600),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text('Legal Action', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDetailSection({required IconData icon, Color? iconColor, required String title, required Widget child}) {
    return Container(
      width: double.infinity,
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
              Icon(icon, color: iconColor ?? Colors.grey.shade500, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildRowItem(String label, bool isYes, {required String yesText, required String noText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 13)),
        Row(
          children: [
            Icon(isYes ? Icons.check : Icons.close, color: isYes ? Colors.green : Colors.red, size: 16),
            const SizedBox(width: 4),
            Text(isYes ? yesText : noText, style: TextStyle(color: isYes ? Colors.green : Colors.red, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        )
      ],
    );
  }
}
