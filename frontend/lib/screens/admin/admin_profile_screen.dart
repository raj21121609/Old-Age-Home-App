import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class AdminProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AdminProfileScreen({super.key, this.onBack});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _alertSound = true;

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF), // Light blue background matching dashboard
      body: SafeArea(
        child: Column(
          children: [
            _buildPurpleHeader(context, lang),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildUserDetails(lang),
                    const SizedBox(height: 16),
                    _buildLanguageSelection(lang),
                    const SizedBox(height: 16),
                    _buildNotificationsSettings(lang),
                    const SizedBox(height: 16),
                    _buildSecurityPrivacy(context, lang),
                    const SizedBox(height: 24),
                    _buildFooter(lang),
                    const SizedBox(height: 24),
                    _buildLogoutButton(context, lang),
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

  Widget _buildPurpleHeader(BuildContext context, LanguageProvider lang) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF8B21C6), // Admin deep purple
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 40),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: widget.onBack ?? () => Navigator.pop(context),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(lang.t('Back', 'पीछे'), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFFB171DF), // Lighter purple for avatar
            child: Text('A', style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.normal)),
          ),
          const SizedBox(height: 16),
          Text(lang.t('Admin Suresh Kumar', 'व्यवस्थापक सुरेश कुमार'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(lang.t('Administrator', 'प्रशासक'), style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildCardBase({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _buildCardHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1D4ED8), size: 20), // Deep blue icon matching reference
        const SizedBox(width: 12),
        Text(title, style: TextStyle(color: Colors.blueGrey.shade900, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildUserDetails(LanguageProvider lang) {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(Icons.person_outline, lang.t('User Details', 'उपयोगकर्ता विवरण')),
          const SizedBox(height: 24),
          _buildInfoRow(lang.t('ID', 'आईडी'), 'ADMIN-2024-001'),
          const SizedBox(height: 16),
          _buildInfoRow(lang.t('Phone', 'फ़ोन'), '+91 98765 43210'),
          const SizedBox(height: 16),
          _buildInfoRow(lang.t('Email', 'ईमेल'), 'suresh.kumar@gov.in'),
          const SizedBox(height: 16),
          _buildInfoRow(lang.t('Location', 'स्थान'), lang.t('Central Administration, Delhi', 'केंद्रीय प्रशासन, दिल्ली')),
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

  Widget _buildLanguageSelection(LanguageProvider lang) {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(Icons.language, lang.t('Language', 'भाषा')),
          const SizedBox(height: 24),
          _buildLanguageOption(lang, 'English', false),
          const SizedBox(height: 12),
          _buildLanguageOption(lang, 'हिंदी (Hindi)', true),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(LanguageProvider lang, String title, bool isHindiOption) {
    bool isSelected = lang.isHindi == isHindiOption;
    return GestureDetector(
      onTap: () => lang.setHindi(isHindiOption),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFF1D4ED8) : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
            if (isSelected) const Icon(Icons.check, color: Color(0xFF1D4ED8), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSettings(LanguageProvider lang) {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(Icons.notifications_none, lang.t('Notifications', 'सूचनाएं')),
          const SizedBox(height: 24),
          _buildSwitchRow(lang.t('Push Notifications', 'पुश सूचनाएं'), _pushNotifications, (v) => setState(() => _pushNotifications = v)),
          const SizedBox(height: 16),
          _buildSwitchRow(lang.t('Email Notifications', 'ईमेल सूचनाएं'), _emailNotifications, (v) => setState(() => _emailNotifications = v)),
          const SizedBox(height: 16),
          _buildSwitchRow(lang.t('Alert Sound', 'अलर्ट ध्वनि'), _alertSound, (v) => setState(() => _alertSound = v)),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
        SizedBox(
          height: 24,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityPrivacy(BuildContext context, LanguageProvider lang) {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(Icons.shield_outlined, lang.t('Security & Privacy', 'सुरक्षा और गोपनीयता')),
          const SizedBox(height: 24),
          _buildArrowRow(context, lang.t('Change Password', 'पासवर्ड बदलें')),
          const SizedBox(height: 20),
          _buildArrowRow(context, lang.t('Privacy Policy', 'गोपनीयता नीति')),
          const SizedBox(height: 20),
          _buildArrowRow(context, lang.t('Terms of Service', 'सेवा की शर्तें')),
        ],
      ),
    );
  }

  Widget _buildArrowRow(BuildContext context, String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label available soon...')));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }

  Widget _buildFooter(LanguageProvider lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(lang.t('Senior Care Monitoring v1.0.0', 'सीनियर केयर मॉनिटरिंग v1.0.0'), style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade800, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(lang.t('Government of India Initiative', 'भारत सरकार की पहल'), style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade600)),
          const SizedBox(height: 4),
          Text(lang.t('© 2026 Ministry of Social Justice', '© 2026 सामाजिक न्याय मंत्रालय'), style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade600)),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, LanguageProvider lang) {
    return ElevatedButton(
      onPressed: () {
        // Redirect back to root role selection based on prompt requirement
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE50000), // Solid red matching reference
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.logout, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(lang.t('Logout', 'लॉग आउट'), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
