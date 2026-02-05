import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
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
                'Terms and Conditions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Last updated: December 2024',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              
              _buildSection(
                'Acceptance of Terms',
                'By downloading, installing, or using the Foodle app, you agree to be bound by these Terms and Conditions. '
                'If you do not agree to these terms, please do not use our service.'
              ),
              
              _buildSection(
                'Description of Service',
                'Foodle is a food preference tracking application that helps users:\n\n'
                '• Track food preferences and allergies for family and friends\n'
                '• Discover and save favorite restaurants\n'
                '• Plan meals based on dietary restrictions\n'
                '• Manage food-related information for social gatherings\n'
                '• Receive personalized food recommendations'
              ),
              
              _buildSection(
                'User Responsibilities',
                'You agree to:\n\n'
                '• Provide accurate and truthful information\n'
                '• Keep your account credentials secure\n'
                '• Use the app only for lawful purposes\n'
                '• Respect the privacy of others whose information you add\n'
                '• Not attempt to hack or compromise the app security\n'
                '• Report any bugs or security issues promptly'
              ),
              
              _buildSection(
                'Data Accuracy',
                'While Foodle helps track food preferences and allergies, users are responsible for:\n\n'
                '• Verifying all food allergy and dietary information\n'
                '• Consulting healthcare professionals for medical dietary advice\n'
                '• Double-checking restaurant information and menus\n'
                '• Updating preferences when they change'
              ),
              
              _buildSection(
                'Limitation of Liability',
                'Foodle is not responsible for:\n\n'
                '• Allergic reactions or dietary issues\n'
                '• Inaccurate restaurant information\n'
                '• Third-party content or services\n'
                '• Data loss due to device issues\n'
                '• Service interruptions or technical problems'
              ),
              
              _buildSection(
                'Account Termination',
                'We reserve the right to terminate accounts that:\n\n'
                '• Violate these terms of service\n'
                '• Engage in fraudulent activities\n'
                '• Compromise app security\n'
                '• Abuse the service or other users'
              ),
              
              _buildSection(
                'Changes to Terms',
                'We may update these Terms and Conditions periodically. '
                'Users will be notified of significant changes through the app. '
                'Continued use of the service constitutes acceptance of updated terms.'
              ),
              
              _buildSection(
                'Contact Information',
                'For questions about these Terms and Conditions:\n\n'
                'Email: legal@foodle.app\n'
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