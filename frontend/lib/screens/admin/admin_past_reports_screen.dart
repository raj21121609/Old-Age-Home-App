import 'package:flutter/material.dart';

class AdminPastReportsScreen extends StatelessWidget {
  const AdminPastReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF), // Light blue background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.description_outlined, size: 40, color: Colors.blue.shade700),
              ),
              const SizedBox(height: 24),
              const Text('Past Reports', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 8),
              Text('View historical reports here', style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade500)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Redirects back to home page (roles are registered in main.dart)
                  Navigator.pushNamedAndRemoveUntil(context, '/dashboard/admin', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D4ED8), // Deep Blue solid
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Back to Dashboard', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
