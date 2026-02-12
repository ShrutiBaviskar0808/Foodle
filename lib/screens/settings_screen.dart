import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import '../reset_password.dart';
import 'request_deletion_screen.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  
  const SettingsScreen({super.key, this.onBackPressed});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = false;
  bool location = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pushNotifications = prefs.getBool('push_notifications') ?? false;
      location = prefs.getBool('location') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', pushNotifications);
    await prefs.setBool('location', location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 10),
            _buildSectionHeader('SETTING'),
            const SizedBox(height: 10),
            
            _buildNavigationTile('Reset Password', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordPage()));
            }),
            
            _buildSwitchTile(
              'Push Notification',
              pushNotifications,
              (value) {
                setState(() => pushNotifications = value);
                _saveSettings();
              },
            ),
            
            _buildSwitchTile(
              'Location',
              location,
              (value) {
                setState(() => location = value);
                _saveSettings();
              },
            ),
            
            const SizedBox(height: 30),
            _buildSectionHeader('SUPPORT'),
            const SizedBox(height: 10),
            
            _buildNavigationTile('Account Deletion', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestDeletionScreen()));
            }),
            
            const SizedBox(height: 30),
            _buildSectionHeader('OTHER'),
            const SizedBox(height: 10),
            
            _buildNavigationTile('Privacy Policy', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
            }),
            _buildNavigationTile('T&C', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsConditionsScreen()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.orange;
            }
            return Colors.grey[400];
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.orange.withValues(alpha: 0.3);
            }
            return Colors.grey[300];
          }),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      ),
    );
  }

  Widget _buildNavigationTile(String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      ),
    );
  }
}