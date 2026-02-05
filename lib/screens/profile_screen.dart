import 'package:flutter/material.dart';
import '../forgot_password.dart';
import '../reset_password.dart';
import 'user_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 40),
              _buildMenuItem(
                context,
                'User Profile',
                Icons.person_outline,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfileScreen())),
              ),
              _buildMenuItem(
                context,
                'Reset Password',
                Icons.lock_reset,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordPage())),
              ),
              _buildMenuItem(
                context,
                'Forgot Password',
                Icons.help_outline,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: Colors.grey[50],
      ),
    );
  }
}