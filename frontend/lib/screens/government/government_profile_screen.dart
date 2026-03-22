import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class GovernmentProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const GovernmentProfileScreen({super.key, this.onBack});

  @override
  State<GovernmentProfileScreen> createState() => _GovernmentProfileScreenState();
}

class _GovernmentProfileScreenState extends State<GovernmentProfileScreen> {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool alertSound = true;

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Container(
      color: const Color(0xFFF4F7FB),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(context, lang),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildUserDetails(lang),
                const SizedBox(height: 16),
                _buildLanguageOptions(lang),
                const SizedBox(height: 16),
                _buildNotificationsList(lang),
                const SizedBox(height: 16),
                _buildSecurityList(lang),
                const SizedBox(height: 16),
                _buildFooterInfo(lang),
                const SizedBox(height: 24),
                _buildLogoutButton(context, lang),
                const SizedBox(height: 24),
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, LanguageProvider lang) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF048A39), // Green theme
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 32),
      child: Column(
        children: [
          if (widget.onBack != null)
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: widget.onBack,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(lang.t('Back', 'पीछे'), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Text('O', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          Text(lang.t('Officer Rajesh Singh', 'अधिकारी राजेश सिंह'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(lang.t('Government Officer', 'सरकारी अधिकारी'), style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildUserDetails(LanguageProvider lang) {
    return _buildCardSection(
      icon: Icons.person_outline,
      title: lang.t('User Details', 'उपयोगकर्ता विवरण'),
      children: [
        _buildInfoRow(lang.t('ID', 'आईडी'), 'GOV-2024-001'),
        const SizedBox(height: 16),
        _buildInfoRow(lang.t('Phone', 'फ़ोन'), '+91 98765 43210'),
        const SizedBox(height: 16),
        _buildInfoRow(lang.t('Email', 'ईमेल'), 'rajesh.singh@gov.in'),
        const SizedBox(height: 16),
        _buildInfoRow(lang.t('Location', 'स्थान'), lang.t('Dept. of Social Welfare, Delhi', 'समाज कल्याण विभाग, दिल्ली')),
      ],
    );
  }

  Widget _buildLanguageOptions(LanguageProvider lang) {
    return _buildCardSection(
      icon: Icons.language,
      title: lang.t('Language', 'भाषा'),
      children: [
        GestureDetector(
          onTap: () => lang.setHindi(false),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: !lang.isHindi ? Colors.blue.shade50 : Colors.transparent,
              border: Border.all(color: !lang.isHindi ? Colors.blue.shade400 : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('English', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
                if (!lang.isHindi) Icon(Icons.check, color: Colors.blue.shade600, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => lang.setHindi(true),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: lang.isHindi ? Colors.blue.shade50 : Colors.transparent,
              border: Border.all(color: lang.isHindi ? Colors.blue.shade400 : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('हिंदी (Hindi)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
                if (lang.isHindi) Icon(Icons.check, color: Colors.blue.shade600, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsList(LanguageProvider lang) {
    return _buildCardSection(
      icon: Icons.notifications_none,
      title: lang.t('Notifications', 'सूचनाएं'),
      children: [
        _buildSwitchRow(lang.t('Push Notifications', 'पुश सूचनाएं'), pushNotifications, (val) => setState(() => pushNotifications = val)),
        const SizedBox(height: 16),
        _buildSwitchRow(lang.t('Email Notifications', 'ईमेल सूचनाएं'), emailNotifications, (val) => setState(() => emailNotifications = val)),
        const SizedBox(height: 16),
        _buildSwitchRow(lang.t('Alert Sound', 'अलर्ट ध्वनि'), alertSound, (val) => setState(() => alertSound = val)),
      ],
    );
  }

  Widget _buildSecurityList(LanguageProvider lang) {
    return _buildCardSection(
      icon: Icons.shield_outlined,
      title: lang.t('Security & Privacy', 'सुरक्षा और गोपनीयता'),
      children: [
        _buildArrowRow(lang.t('Change Password', 'पासवर्ड बदलें'), () {}),
        const SizedBox(height: 20),
        _buildArrowRow(lang.t('Privacy Policy', 'गोपनीयता नीति'), () {}),
        const SizedBox(height: 20),
        _buildArrowRow(lang.t('Terms of Service', 'सेवा की शर्तें'), () {}),
      ],
    );
  }

  Widget _buildFooterInfo(LanguageProvider lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Text(lang.t('Senior Care Monitoring v1.0.0', 'सीनियर केयर मॉनिटरिंग v1.0.0'), style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(lang.t('Government of India Initiative', 'भारत सरकार की पहल'), style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 11)),
          const SizedBox(height: 4),
          Text(lang.t('© 2026 Ministry of Social Justice', '© 2026 सामाजिक न्याय मंत्रालय'), style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, LanguageProvider lang) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE50000), // Pure red as shown
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: () {
        // "redirect it on the role page"
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      },
      icon: const Icon(Icons.logout, color: Colors.white, size: 20),
      label: Text(lang.t('Logout', 'लॉग आउट'), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  // --- Helpers ---

  Widget _buildCardSection({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
              Icon(icon, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: Colors.blueGrey.shade900, fontWeight: FontWeight.bold, fontSize: 15)),
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

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(
          height: 24,
          child: Switch(
            value: value,
            activeColor: Colors.black,
            onChanged: onChanged,
          ),
        )
      ],
    );
  }

  Widget _buildArrowRow(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }
}
