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
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final String userEmail = user?['email'] ?? 'suresh.kumar@gov.in';

    return Container(
      color: const Color(0xFFF7F8FA),
      child: Column(
        children: [
          _buildTopHeader(lang),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 8),
                _buildProfileBadge(lang, user),
                const SizedBox(height: 24),
                _buildSectionHeader('FACILITY'),
                _buildFacilityManagement(context, lang),
                const SizedBox(height: 24),
                _buildSectionHeader('ACCOUNT SETTINGS'),
                _buildSettingsCard([
                  _buildSettingRow(Icons.person_outline, lang.t('User Details', 'उपयोगकर्ता विवरण'), userEmail),
                  _buildDivider(),
                  _buildSettingRow(Icons.language_rounded, lang.t('Language', 'भाषा'), lang.isHindi ? 'हिन्दी' : 'English', hasBadge: true),
                ]),
                const SizedBox(height: 24),
                _buildSectionHeader('NOTIFICATIONS'),
                _buildSettingsCard([
                  _buildToggleRow(Icons.notifications_none_rounded, lang.t('Push Notifications', 'पुश सूचनाएं'), _pushNotifications, (v) => setState(() => _pushNotifications = v)),
                  _buildDivider(),
                  _buildToggleRow(Icons.mail_outline_rounded, lang.t('Email Notifications', 'ईमेल सूचनाएं'), _emailNotifications, (v) => setState(() => _emailNotifications = v)),
                  _buildDivider(),
                  _buildToggleRow(Icons.volume_up_outlined, lang.t('Alert Sound', 'अलर्ट ध्वनि'), _alertSound, (v) => setState(() => _alertSound = v)),
                ]),
                const SizedBox(height: 24),
                _buildSectionHeader('SECURITY'),
                _buildSettingsCard([
                  _buildSettingRow(Icons.lock_outline_rounded, lang.t('Change Password', 'पासवर्ड बदलें'), ''),
                  _buildDivider(),
                  _buildSettingRow(Icons.description_outlined, lang.t('Terms of Service', 'सेवा की शर्तें'), ''),
                ]),
                const SizedBox(height: 32),
                _buildLogoutButton(context, lang, auth),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'VERSION 2.1.0 • © 2026 MINISTRY OF SOCIAL JUSTICE',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopHeader(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: const Color(0xFFF7F8FA),
      child: Row(
        children: [
          if (widget.onBack != null)
            IconButton(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black87),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (widget.onBack != null) const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.t('Profile & Settings', 'प्रोफ़ाइल और सेटिंग्स'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Text(
                'MANAGE ACCOUNT',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF048A39), letterSpacing: 0.5),
              )
            ],
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline_rounded, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildProfileBadge(LanguageProvider lang, Map<String, dynamic>? user) {
    final String? userAvatarUrl = user?['avatar_url'];
    final String userName = user?['name'] ?? 'Admin Suresh Kumar';
    final String userRole = user?['role']?.toString().toUpperCase() ?? 'ADMINISTRATOR';
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF048A39),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048A39).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.2),
            backgroundImage: userAvatarUrl != null && userAvatarUrl.isNotEmpty
                ? NetworkImage(userAvatarUrl)
                : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    userRole,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_square, color: Colors.white70, size: 20),
        ],
      ),
    );
  }

  Widget _buildFacilityManagement(BuildContext context, LanguageProvider lang) {
    final auth = context.watch<AuthProvider>();
    final admin = context.watch<AdminProvider>();
    final homeId = auth.user?['old_age_home_id'];
    final String? imageUrl = auth.user?['image_url']; 

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF7F8FA), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.business_rounded, color: Colors.black54, size: 20),
              ),
              const SizedBox(width: 16),
              Text(lang.t('Facility Photo', 'सुविधा फोटो'), style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.business, color: Colors.black12, size: 64))
                  : const Icon(Icons.business, color: Colors.black12, size: 64),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (homeId == null) return;
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                final newUrl = await SupabaseStorageService.uploadFacilityImage(File(image.path), homeId.toString());
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
              backgroundColor: const Color(0xFF048A39),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(lang.t('Update Photo', 'फोटो अपडेट करें'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
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
        children: children,
      ),
    );
  }

  Widget _buildSettingRow(IconData icon, String title, String value, {bool hasBadge = false}) {
    return InkWell(
      onTap: () {
        if (title.contains('Language') || title.contains('भाषा')) {
          final lang = context.read<LanguageProvider>();
          lang.setHindi(!lang.isHindi);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF7F8FA), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: Colors.black54, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
            ),
            if (value.isNotEmpty)
              Text(value, style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: Colors.black26, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF7F8FA), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.black54, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF048A39),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey.shade100, indent: 60);
  }

  Widget _buildLogoutButton(BuildContext context, LanguageProvider lang, AuthProvider auth) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade50,
        foregroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      onPressed: () {
        auth.logout();
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.logout_rounded, size: 20),
          const SizedBox(width: 8),
          Text(lang.t('Logout Account', 'खाता लॉग आउट'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
