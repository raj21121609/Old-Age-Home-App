import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/admin_provider.dart';
import '../../core/supabase_storage_service.dart';

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
      backgroundColor: const Color(0xFFF7F8FA), // Serenity light background
      body: SafeArea(
        child: Column(
          children: [
            _buildMinimalHeader(context, lang),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    _buildProfileAvatar(lang),
                    const SizedBox(height: 32),
                    _buildFacilityManagement(context, lang),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalHeader(BuildContext context, LanguageProvider lang) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          if (widget.onBack != null)
            GestureDetector(
              onTap: widget.onBack,
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Color(0xFF1E2125), size: 20),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lang.t('Profile & Settings', 'प्रोफ़ाइल और सेटिंग्स'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1E2125))),
              Text(lang.t('Manage your account preferences', 'अपनी खाता प्राथमिकताएं प्रबंधित करें'), style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(LanguageProvider lang) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF1E293B),
                child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 40),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFF16A34A), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              child: const Icon(Icons.edit, color: Colors.white, size: 14),
            )
          ],
        ),
        const SizedBox(height: 16),
        Text(lang.t('Admin Suresh Kumar', 'व्यवस्थापक सुरेश कुमार'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2125))),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(16)),
          child: Text(lang.t('Administrator', 'प्रशासक'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
        ),
      ],
    );
  }

  Widget _buildCardBase({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: child,
    );
  }

  Widget _buildFacilityManagement(BuildContext context, LanguageProvider lang) {
    final auth = context.watch<AuthProvider>();
    final admin = context.watch<AdminProvider>();
    final homeId = auth.user?['old_age_home_id'];
    final String? imageUrl = auth.user?['image_url']; 

    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(Icons.business_rounded, lang.t('Facility Management', 'सुविधा प्रबंधन')),
          const SizedBox(height: 20),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover, 
                      errorBuilder: (c, e, s) => Icon(Icons.business, color: Colors.grey.shade300, size: 64))
                  : Icon(Icons.business, color: Colors.grey.shade300, size: 64),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (homeId == null) return;
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                final newUrl = await SupabaseStorageService.uploadFacilityImage(
                  File(image.path), 
                  homeId.toString()
                );
                if (newUrl != null) {
                  final success = await admin.updateFacilityImage(homeId, newUrl);
                  if (success) {
                    auth.user?['image_url'] = newUrl;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Facility Image Updated!')));
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(lang.t('Update Facility Photo', 'सुविधा फोटो अपडेट करें'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: const Color(0xFF16A34A), size: 18), 
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(color: Color(0xFF1E2125), fontWeight: FontWeight.bold, fontSize: 15)),
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
          _buildInfoRow(lang.t('Location', 'स्थान'), lang.t('Central Administration', 'केंद्रीय प्रशासन')),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(color: Color(0xFF1E2125), fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildLanguageSelection(LanguageProvider lang) {
    return _buildCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(Icons.language, lang.t('Language', 'भाषा')),
          const SizedBox(height: 20),
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
          color: isSelected ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF16A34A) : Colors.grey.shade200, width: isSelected ? 1.5 : 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: isSelected ? const Color(0xFF166534) : Colors.black87, fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 20),
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
          const SizedBox(height: 20),
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
        Text(label, style: const TextStyle(color: Color(0xFF1E2125), fontSize: 13, fontWeight: FontWeight.w600)),
        SizedBox(
          height: 24,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF16A34A),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
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
          const SizedBox(height: 20),
          _buildArrowRow(context, lang.t('Change Password', 'पासवर्ड बदलें')),
          const SizedBox(height: 24),
          _buildArrowRow(context, lang.t('Privacy Policy', 'गोपनीयता नीति')),
          const SizedBox(height: 24),
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
          Text(label, style: const TextStyle(color: Color(0xFF1E2125), fontSize: 13, fontWeight: FontWeight.w600)),
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
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(lang.t('Serenity Care v2.1.0', 'सेरेनिटी केयर v2.1.0'), style: TextStyle(fontSize: 12, color: Colors.grey.shade800, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(lang.t('Ministry of Social Justice', 'सामाजिक न्याय मंत्रालय'), style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, LanguageProvider lang) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, 
        side: BorderSide(color: Colors.red.shade100, width: 1.5),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, color: Colors.red.shade600, size: 18),
          const SizedBox(width: 8),
          Text(lang.t('Logout', 'लॉग आउट'), style: TextStyle(color: Colors.red.shade600, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
