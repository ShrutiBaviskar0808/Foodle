import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = false;
  bool location = true;
  String selectedLanguage = 'English';

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
      selectedLanguage = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', pushNotifications);
    await prefs.setBool('location', location);
    await prefs.setString('language', selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 10),
            _buildSectionHeader('PROFILE'),
            const SizedBox(height: 10),
            
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
            
            _buildLanguageTile(),
            
            const SizedBox(height: 30),
            _buildSectionHeader('OTHER'),
            const SizedBox(height: 10),
            
            _buildNavigationTile('Privacy Policy', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
            }),
            _buildNavigationTile('Terms and Conditions', () {
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

  Widget _buildLanguageTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        title: const Text(
          'Language',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedLanguage,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
        onTap: () => _showLanguageDialog(),
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Spanish', 'French', 'German'].map((language) {
            return ListTile(
              title: Text(language),
              leading: Icon(
                selectedLanguage == language ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selectedLanguage == language ? Colors.orange : Colors.grey,
              ),
              onTap: () {
                setState(() => selectedLanguage = language);
                _saveSettings();
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}