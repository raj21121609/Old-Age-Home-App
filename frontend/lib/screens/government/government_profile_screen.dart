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
      color: const Color(0xFFF7F8FA),
      child: Column(
        children: [
          _buildTopHeader(),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 8),
                _buildProfileBadge(lang),
                const SizedBox(height: 24),
                _buildSectionHeader('ACCOUNT SETTINGS'),
                _buildSettingsCard([
                  _buildSettingRow(Icons.person_outline, lang.t('User Details', 'उपयोगकर्ता विवरण'), 'rajesh.singh@gov.in'),
                  _buildDivider(),
                  _buildSettingRow(Icons.language_rounded, lang.t('Language', 'भाषा'), lang.isHindi ? 'हिन्दी' : 'English', hasBadge: true),
                ]),
                const SizedBox(height: 24),
                _buildSectionHeader('NOTIFICATIONS'),
                _buildSettingsCard([
                  _buildToggleRow(Icons.notifications_none_rounded, lang.t('Push Notifications', 'पुश सूचनाएं'), pushNotifications, (v) => setState(() => pushNotifications = v)),
                  _buildDivider(),
                  _buildToggleRow(Icons.mail_outline_rounded, lang.t('Email Notifications', 'ईमेल सूचनाएं'), emailNotifications, (v) => setState(() => emailNotifications = v)),
                ]),
                const SizedBox(height: 24),
                _buildSectionHeader('SECURITY'),
                _buildSettingsCard([
                  _buildSettingRow(Icons.lock_outline_rounded, lang.t('Change Password', 'पासवर्ड बदलें'), ''),
                  _buildDivider(),
                  _buildSettingRow(Icons.description_outlined, lang.t('Terms of Service', 'सेवा की शर्तें'), ''),
                ]),
                const SizedBox(height: 32),
                _buildLogoutButton(context, lang),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'VERSION 1.0.4 • © 2026 DEPT OF SOCIAL WELFARE',
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

  Widget _buildTopHeader() {
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings & Preferences',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
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

  Widget _buildProfileBadge(LanguageProvider lang) {
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
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=admin'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.t('Officer Rajesh Singh', 'अधिकारी राजेश सिंह'),
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
                    lang.t('Senior Government Officer', 'वरिष्ठ सरकारी अधिकारी'),
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
          if (value.isNotEmpty)
            Text(value, style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: Colors.black26, size: 20),
        ],
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

  Widget _buildLogoutButton(BuildContext context, LanguageProvider lang) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade50,
        foregroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      onPressed: () {
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

