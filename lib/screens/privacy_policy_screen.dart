import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Last updated: December 2024',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              
              _buildSection(
                'Information We Collect',
                'Foodle collects the following information to provide personalized food preference tracking:\n\n'
                '• Personal Information: Name, email, phone number, date of birth\n'
                '• Food Preferences: Dietary restrictions, allergies, favorite cuisines\n'
                '• Family & Friends Data: Names and food preferences of your contacts\n'
                '• Location Data: Restaurant locations and favorite places\n'
                '• Usage Data: App interactions and feature usage statistics'
              ),
              
              _buildSection(
                'How We Use Your Information',
                'Your data is used to:\n\n'
                '• Provide personalized meal planning recommendations\n'
                '• Track food allergies and dietary restrictions\n'
                '• Suggest restaurants based on preferences\n'
                '• Improve app functionality and user experience\n'
                '• Send notifications about dietary reminders'
              ),
              
              _buildSection(
                'Data Storage and Security',
                'We implement industry-standard security measures:\n\n'
                '• Data is encrypted during transmission and storage\n'
                '• Local data is stored securely on your device\n'
                '• Server data is protected with advanced encryption\n'
                '• Regular security audits and updates\n'
                '• Limited access to authorized personnel only'
              ),
              
              _buildSection(
                'Data Sharing',
                'Foodle does not sell or share your personal data with third parties. '
                'Your food preferences and family information remain private and are only '
                'used within the app to provide you with better meal planning services.'
              ),
              
              _buildSection(
                'Your Rights',
                'You have the right to:\n\n'
                '• Access your personal data\n'
                '• Update or correct your information\n'
                '• Delete your account and data\n'
                '• Export your data\n'
                '• Opt-out of notifications'
              ),
              
              _buildSection(
                'Contact Us',
                'If you have questions about this Privacy Policy, contact us at:\n\n'
                'Email: privacy@foodle.app\n'
                'Address: 123 Food Street, Culinary City, FC 12345'
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}