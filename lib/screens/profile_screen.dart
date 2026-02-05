import 'package:flutter/material.dart';
import '../forgot_password.dart';
import '../reset_password.dart';
import 'user_profile_screen.dart';
import 'personal_data_screen.dart';
import 'add_account_screen.dart';
import 'request_deletion_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                'Personal Data',
                Icons.data_usage,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalDataScreen())),
              ),
              _buildMenuItem(
                context,
                'Add Another Account',
                Icons.add_circle_outline,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAccountScreen())),
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
              _buildMenuItem(
                context,
                'Request Account Deletion',
                Icons.delete_forever,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestDeletionScreen())),
              ),
              _buildMenuItem(
                context,
                'Sign Out',
                Icons.logout,
                () => _signOut(context),
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

  void _signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}