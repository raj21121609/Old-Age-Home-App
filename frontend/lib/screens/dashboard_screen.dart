import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Attempt to extract the user details safely passed via Navigator route arguments
    final userArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String name = userArgs?['name'] ?? 'Guest User';
    final String role = userArgs?['role'] ?? 'guest';

    return Scaffold(
      appBar: AppBar(
        title: Text('${role.toUpperCase()} Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome, $name!', 
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Role Role: $role', 
                  style: TextStyle(fontSize: 16, color: Colors.blue.shade900),
                ),
              ),
              const SizedBox(height: 60),
              
              // Minimal role-based UI indication wrapper:
              if (role == 'admin') ...[
                const Icon(Icons.admin_panel_settings, size: 80, color: Colors.blueGrey),
                const SizedBox(height: 16),
                const Text('Administrator system access controls are located here.', textAlign: TextAlign.center),
              ] else if (role == 'government') ...[
                const Icon(Icons.account_balance, size: 80, color: Colors.indigo),
                const SizedBox(height: 16),
                const Text('Regional oversight and report aggregate visualization.', textAlign: TextAlign.center),
              ] else if (role == 'caretaker') ...[
                const Icon(Icons.health_and_safety, size: 80, color: Colors.teal),
                const SizedBox(height: 16),
                const Text('Manage records of the elderly assigned to your home facility.', textAlign: TextAlign.center),
              ] else ...[
                const Icon(Icons.person, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Please login with valid credentials.'),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
