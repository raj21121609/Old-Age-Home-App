import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(String fallbackRole) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // AuthProvider manages the loading flag safely internally
    final success = await authProvider.login(
      _emailController.text, 
      _passwordController.text
    );
    
    if (!mounted) return;

    if (success) {
      final actualRole = authProvider.role;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Successful')));
      
      // Navigate utilizing the global user object accessible intrinsically now
      if (actualRole == 'caretaker') {
        Navigator.pushReplacementNamed(context, '/dashboard/caretaker');
      } else if (actualRole == 'government') {
         Navigator.pushReplacementNamed(context, '/dashboard/government');
      } else if (actualRole == 'admin') {
         Navigator.pushReplacementNamed(context, '/dashboard/admin');
      } else {
         Navigator.pushReplacementNamed(context, '/dashboard/caretaker');
      }
    } else {
      if (authProvider.error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authProvider.error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine target role metadata for branding only
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String role = args?['role'] ?? 'caretaker';
    String roleTitle = role == 'government' ? 'Government Officer' : role == 'admin' ? 'Administrator' : 'Caretaker';

    // Efficiently hook exactly onto AuthProvider's loading Boolean
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield_outlined, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 16),
                    const Text('Senior Care Monitoring', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    const Text('Secure Login', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios, size: 14, color: AppColors.primaryBlue),
                    SizedBox(width: 4),
                    Text('Back', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Enter Credentials', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text('Login as $roleTitle securely', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              
              const Text('Email Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: AppColors.inputBg,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: const Icon(Icons.lock_outline),
                  filled: true,
                  fillColor: AppColors.inputBg,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),
              isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : ElevatedButton(
                    onPressed: () => _login(role),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register', arguments: {'role': role}),
                  child: const Text('Don\'t have an account? Register here.', style: TextStyle(color: AppColors.primaryBlue)),
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text('Secured by Government of India', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
