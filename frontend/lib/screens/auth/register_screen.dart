import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../core/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  List<dynamic> _homes = [];
  int? _selectedHomeId;

  @override
  void initState() {
    super.initState();
    _fetchHomes();
  }

  void _fetchHomes() async {
    print('DEBUG: Fetching homes for dropdown...');
    final homes = await ApiService.getAllHomes();
    print('DEBUG: Received ${homes.length} homes from API');
    if (mounted) {
      setState(() {
        _homes = homes;
        if (_homes.isNotEmpty) {
          _selectedHomeId = _homes[0]['id'];
        }
      });
    }
  }

  void _register(String role) async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if ((role == 'caretaker' || role == 'admin') && _selectedHomeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an old age home')));
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
      role,
      oldAgeHomeId: (role == 'caretaker' || role == 'admin') ? _selectedHomeId : null,
    );
    
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Successful')));
      Navigator.pushReplacementNamed(context, '/login', arguments: {'role': role});
    } else {
      if (authProvider.error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authProvider.error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String role = args?['role'] ?? 'caretaker';
    
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryBlue),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Create an Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('Signing up as a ${role.toUpperCase()}', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            
            _buildTextField('Full Name', Icons.person_outline, _nameController),
            const SizedBox(height: 16),
            _buildTextField('Email Address', Icons.email_outlined, _emailController),
            const SizedBox(height: 16),
            _buildTextField('Password', Icons.lock_outline, _passwordController, obscure: true),
            
            if (role == 'caretaker' || role == 'admin') ...[
              const SizedBox(height: 16),
              const Text('Assigned Old Age Home', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              _homes.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Loading homes or none available...', style: TextStyle(color: Colors.grey)),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedHomeId,
                        isExpanded: true,
                        hint: const Text('Select Home'),
                        items: _homes.map((h) => DropdownMenuItem<int>(
                          value: h['id'],
                          child: Text(h['name'].toString()),
                        )).toList(),
                        onChanged: (val) => setState(() => _selectedHomeId = val),
                      ),
                    ),
                  ),
            ],

            const SizedBox(height: 40),
            
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () => _register(role),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: AppColors.inputBg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
