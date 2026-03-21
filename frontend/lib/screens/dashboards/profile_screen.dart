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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade700, size: 20),
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
        // Blue Header
        Container(
          width: double.infinity,
          color: const Color(0xFF1E5EFC),
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: widget.onBack,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(langProvider.t('Back', 'वापस'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CircleAvatar(radius: 40, backgroundColor: Colors.blue.shade300, child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w500))),
              const SizedBox(height: 12),
              Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text(langProvider.t('Caretaker', 'देखभालकर्ता'), style: const TextStyle(color: Colors.white70, fontSize: 14)),
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
                          decoration: BoxDecoration(border: Border.all(color: !langProvider.isHindi ? Colors.blue : Colors.grey.shade300), borderRadius: BorderRadius.circular(8), color: !langProvider.isHindi ? Colors.blue.shade50 : Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('English', style: TextStyle(fontWeight: !langProvider.isHindi ? FontWeight.bold : FontWeight.normal, color: !langProvider.isHindi ? Colors.blue : Colors.black87)),
                              if (!langProvider.isHindi) const Icon(Icons.check, color: Colors.blue, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => langProvider.setHindi(true),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(border: Border.all(color: langProvider.isHindi ? Colors.blue : Colors.grey.shade300), borderRadius: BorderRadius.circular(8), color: langProvider.isHindi ? Colors.blue.shade50 : Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('हिंदी (Hindi)', style: TextStyle(fontWeight: langProvider.isHindi ? FontWeight.bold : FontWeight.normal, color: langProvider.isHindi ? Colors.blue : Colors.black87)),
                              if (langProvider.isHindi) const Icon(Icons.check, color: Colors.blue, size: 18),
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
                  icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                  label: Text(tLogout, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914), // Red matching image
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
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
          SizedBox(
            height: 24,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Colors.black,
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
