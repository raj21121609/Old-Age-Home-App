import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ProfileScreen({super.key, required this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool alertSound = true;

  Widget _buildCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: const Color(0xFF048A39), size: 18),
              ),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final user = authProvider.user;
    final name = user?['name'] ?? 'Priya Sharma';
    final initial = name.isNotEmpty ? name[0] : 'P';
    
    final tUserDetails = langProvider.t('User Details', 'उपयोगकर्ता विवरण');
    final tLanguage = langProvider.t('Language', 'भाषा');
    final tNotifications = langProvider.t('Notifications', 'सूचनाएं');
    final tSecurity = langProvider.t('Security & Privacy', 'सुरक्षा एवं गोपनीयता');
    final tLogout = langProvider.t('Logout', 'लॉग आउट');

    return Column(
      children: [
        // Premium Header
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: widget.onBack,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 14),
                        const SizedBox(width: 8),
                        Text(langProvider.t('Back', 'वापस'), style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 44, 
                    backgroundColor: const Color(0xFFE2E8F0), 
                    child: Text(initial, style: const TextStyle(color: Color(0xFF048A39), fontSize: 32, fontWeight: FontWeight.w900))
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFF048A39), shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87, letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Text(langProvider.t('CERTIFIED CARETAKER', 'प्रमाणित देखभालकर्ता'), style: TextStyle(color: const Color(0xFF048A39), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
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
                  title: tUserDetails,
                  icon: Icons.person_outline,
                  child: Column(
                    children: [
                      _buildDetailRow('ID', 'CT-2024-045'),
                      _buildDetailRow(langProvider.t('Phone', 'फ़ोन'), '+91 98765 43210'),
                      _buildDetailRow(langProvider.t('Email', 'ईमेल'), 'priya.sharma@sunshine.com'),
                      _buildDetailRow(langProvider.t('Location', 'स्थान'), langProvider.t('Sunshine Old Age Home', 'सनशाइन ओल्ड एज होम')),
                    ],
                  ),
                ),
                _buildCard(
                  title: tLanguage,
                  icon: Icons.language,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => langProvider.setHindi(false),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(border: Border.all(color: !langProvider.isHindi ? const Color(0xFF048A39) : Colors.grey.shade300), borderRadius: BorderRadius.circular(8), color: !langProvider.isHindi ? const Color(0xFF048A39).withOpacity(0.05) : Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('English', style: TextStyle(fontWeight: !langProvider.isHindi ? FontWeight.bold : FontWeight.normal, color: !langProvider.isHindi ? const Color(0xFF048A39) : Colors.black87)),
                              if (!langProvider.isHindi) const Icon(Icons.check_circle_rounded, color: Color(0xFF048A39), size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => langProvider.setHindi(true),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(border: Border.all(color: langProvider.isHindi ? const Color(0xFF048A39) : Colors.grey.shade300), borderRadius: BorderRadius.circular(8), color: langProvider.isHindi ? const Color(0xFF048A39).withOpacity(0.05) : Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('हिंदी (Hindi)', style: TextStyle(fontWeight: langProvider.isHindi ? FontWeight.bold : FontWeight.normal, color: langProvider.isHindi ? const Color(0xFF048A39) : Colors.black87)),
                              if (langProvider.isHindi) const Icon(Icons.check_circle_rounded, color: Color(0xFF048A39), size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildCard(
                  title: tNotifications,
                  icon: Icons.notifications_none,
                  child: Column(
                    children: [
                      _buildSwitchRow(langProvider.t('Push Notifications', 'पुश सूचनाएँ'), pushNotifications, (v) => setState(() => pushNotifications = v)),
                      _buildSwitchRow(langProvider.t('Email Notifications', 'ईमेल सूचनाएँ'), emailNotifications, (v) => setState(() => emailNotifications = v)),
                      _buildSwitchRow(langProvider.t('Alert Sound', 'अलर्ट ध्वनि'), alertSound, (v) => setState(() => alertSound = v)),
                    ],
                  ),
                ),
                _buildCard(
                  title: tSecurity,
                  icon: Icons.shield_outlined,
                  child: Column(
                    children: [
                      _buildActionRow(langProvider.t('Change Password', 'पासवर्ड बदलें')),
                      const Divider(height: 24),
                      _buildActionRow(langProvider.t('Privacy Policy', 'गोपनीयता नीति')),
                      const Divider(height: 24),
                      _buildActionRow(langProvider.t('Terms of Service', 'सेवा की शर्तें')),
                    ],
                  ),
                ),
                
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100)
                  ),
                  child: Column(
                    children: [
                      Text('Senior Care Monitoring v1.0.0', style: TextStyle(fontSize: 13, color: Colors.blue.shade900)),
                      const SizedBox(height: 4),
                      Text(langProvider.t('Government of India Initiative', 'भारत सरकार की पहल'), style: TextStyle(fontSize: 12, color: Colors.blue.shade700)),
                      const SizedBox(height: 4),
                      Text(langProvider.t('© 2026 Ministry of Social Justice', '© 2026 सामाजिक न्याय मंत्रालय'), style: TextStyle(fontSize: 11, color: Colors.blue.shade700)),
                    ]
                  )
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    authProvider.logout();
                    Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                  label: Text(tLogout, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444), 
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: const Color(0xFFEF4444).withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
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
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF048A39),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
        Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
      ],
    );
  }
}
