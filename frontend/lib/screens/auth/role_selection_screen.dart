import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_outlined, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              const Text(
                'Senior Care Monitoring',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Secure Login',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 60),
              const Text(
                'Select Your Role',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 24),
              _buildRoleCard(
                context,
                title: 'Caretaker',
                subtitle: 'Record daily activities',
                icon: Icons.person_outline,
                iconBgColor: const Color(0xFFDBEAFE),
                iconColor: AppColors.primaryBlue,
                role: 'caretaker',
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                context,
                title: 'Government Officer',
                subtitle: 'Monitor & inspect',
                icon: Icons.admin_panel_settings_outlined,
                iconBgColor: const Color(0xFFD1FAE5),
                iconColor: AppColors.governmentGreen,
                role: 'government',
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                context,
                title: 'Administrator',
                subtitle: 'Manage residents & homes',
                icon: Icons.manage_accounts_outlined,
                iconBgColor: const Color(0xFFF3E8FF),
                iconColor: AppColors.adminPurple,
                role: 'admin',
              ),
              const SizedBox(height: 60),
              const Text(
                'Secured by Government of India',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String role,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/login', arguments: {'role': role}),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
