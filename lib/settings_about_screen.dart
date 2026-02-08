import 'package:flutter/material.dart';
import 'info_detail_screen.dart';
import 'feedback_screen.dart';

class SettingsAboutScreen extends StatelessWidget {
  const SettingsAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.brown.shade700, Colors.brown.shade500],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.landscape, size: 40, color: Colors.brown),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Rock Stone Identifier',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Version 1.0.0',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildOption(
                        context,
                        'About App',
                        Icons.info_outline,
                        Colors.blue,
                        () => _navigateToInfo(context, 'About App', _getAboutContent()),
                      ),
                      _buildOption(
                        context,
                        'How It Works',
                        Icons.help_outline,
                        Colors.green,
                        () => _navigateToInfo(context, 'How It Works', _getHowItWorksContent()),
                      ),
                      _buildOption(
                        context,
                        'Privacy Policy',
                        Icons.privacy_tip_outlined,
                        Colors.purple,
                        () => _navigateToInfo(context, 'Privacy Policy', _getPrivacyContent()),
                      ),
                      _buildOption(
                        context,
                        'Help & FAQ',
                        Icons.question_answer_outlined,
                        Colors.orange,
                        () => _navigateToInfo(context, 'Help & FAQ', _getFAQContent()),
                      ),
                      _buildOption(
                        context,
                        'Send Feedback',
                        Icons.feedback_outlined,
                        Colors.red,
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackScreen())),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _navigateToInfo(BuildContext context, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoDetailScreen(title: title, content: content),
      ),
    );
  }

  String _getAboutContent() {
    return '''About Rock Stone Identifier

Rock Stone Identifier is your pocket geology companion, designed to help you identify and learn about rocks, minerals, and crystals using advanced AI technology.

OUR MISSION
To make geology accessible and exciting for everyone - from curious beginners to passionate collectors and students.

KEY FEATURES
• AI-Powered Identification: Instantly identify stones from photos
• Comprehensive Database: Explore thousands of rocks and minerals
• Personal Collection: Save and organize your discoveries
• Educational Content: Learn geology basics and identification techniques
• Offline Capable: Access saved stones anytime, anywhere

WHO WE SERVE
• Geology Students
• Rock Collectors
• Hikers & Outdoor Enthusiasts
• Educators & Teachers
• Amateur Geologists
• Nature Lovers

WHAT MAKES US DIFFERENT
• User-friendly interface designed for all skill levels
• Detailed geological information for each stone
• Educational guides and tips
• Personal collection management
• Regular database updates

CONTACT US
Email: support@rockstoneidentifier.com
Website: www.rockstoneidentifier.com

Follow us on social media for updates, tips, and amazing stone discoveries!

© 2024 Rock Stone Identifier. All rights reserved.''';
  }

  String _getHowItWorksContent() {
    return '''How It Works

Rock Stone Identifier uses advanced AI and machine learning to help you identify stones quickly and accurately.

STEP 1: CAPTURE OR UPLOAD
• Take a photo using your device camera
• Upload an existing image from your gallery
• Ensure good lighting and clear focus

STEP 2: AI ANALYSIS
Our AI analyzes multiple features:
• Color and color patterns
• Texture and surface characteristics
• Crystal structure and formation
• Shape and physical properties
• Comparative database matching

STEP 3: IDENTIFICATION
Within seconds, you receive:
• Stone name and classification
• Confidence percentage
• Key identifying features
• Similar stones for comparison

STEP 4: LEARN MORE
Explore detailed information:
• Chemical composition
• Formation process
• Where it's found
• Interesting facts
• Educational content

STEP 5: SAVE & ORGANIZE
• Add to your personal collection
• Write custom notes
• Tag locations
• Build your digital geology journal

TIPS FOR BEST RESULTS
✓ Use natural daylight
✓ Clean the stone surface
✓ Take multiple angles
✓ Include size reference
✓ Avoid shadows and glare

TECHNOLOGY
Our AI is trained on thousands of geological specimens and continuously improves with each identification, ensuring accuracy and reliability.

OFFLINE MODE
Once identified, stones are saved locally, allowing you to access your collection anytime without internet connection.''';
  }

  String _getPrivacyContent() {
    return '''Privacy Policy

Last Updated: December 2024

Rock Stone Identifier is committed to protecting your privacy and ensuring the security of your personal information.

INFORMATION WE COLLECT

1. Photos and Images
• Stone photos you capture or upload
• Used only for identification purposes
• Stored locally on your device
• Not shared with third parties

2. Collection Data
• Saved stones and notes
• Location tags (if you provide them)
• Stored locally on your device

3. Usage Data
• App performance metrics
• Feature usage statistics
• Anonymous analytics for improvement

WHAT WE DON'T COLLECT
✗ Personal identification information
✗ Contact lists or phone numbers
✗ Location data (unless you manually add it)
✗ Financial information

HOW WE USE YOUR DATA
• Provide identification services
• Improve AI accuracy
• Enhance user experience
• Fix bugs and issues
• Develop new features

DATA STORAGE
• All personal data stored locally on your device
• You control your data
• Delete anytime through app settings

DATA SHARING
We do NOT sell, trade, or share your personal data with third parties.

SECURITY
• Industry-standard encryption
• Secure data transmission
• Regular security updates
• No unauthorized access

YOUR RIGHTS
• Access your data
• Delete your data
• Export your collection
• Opt-out of analytics

CHILDREN'S PRIVACY
Our app is safe for all ages. We do not knowingly collect data from children under 13.

CHANGES TO POLICY
We may update this policy. Check regularly for updates.

CONTACT
Questions? Email: privacy@rockstoneidentifier.com

By using Rock Stone Identifier, you agree to this privacy policy.''';
  }

  String _getFAQContent() {
    return '''Help & FAQ

GETTING STARTED

Q: How do I identify a stone?
A: Tap the camera button, take a clear photo of your stone, and our AI will analyze it within seconds.

Q: Can I use existing photos?
A: Yes! Use the "Upload from Gallery" option to identify stones from existing photos.

Q: Do I need internet connection?
A: Internet is needed for identification, but you can access saved stones offline.

IDENTIFICATION

Q: How accurate is the identification?
A: Our AI provides 85-95% accuracy. We show confidence levels with each result.

Q: What if the identification seems wrong?
A: Compare with similar stones, check the detailed information, or try taking another photo with better lighting.

Q: Can it identify any stone?
A: We cover thousands of common rocks, minerals, and crystals. Rare specimens may not be in our database yet.

PHOTOS

Q: What makes a good photo?
A: Natural lighting, clean stone surface, clear focus, and multiple angles work best.

Q: Why is my photo rejected?
A: Ensure the stone is clearly visible, well-lit, and in focus. Avoid blurry or dark images.

COLLECTION

Q: How do I save stones?
A: After identification, tap "Save to Collection" and add your notes.

Q: Can I edit saved stones?
A: Yes! Open any saved stone and tap the edit icon to modify notes and location.

Q: Is there a limit to my collection?
A: No limit! Save as many stones as you want.

LEARNING

Q: Where can I learn about geology?
A: Visit the "Learn & Guides" section for tutorials, tips, and fun facts.

Q: Can I use this for school?
A: Absolutely! Our educational content is perfect for students and teachers.

TECHNICAL

Q: Why is the app slow?
A: Check your internet connection. Clear app cache in settings if issues persist.

Q: How do I update the app?
A: Updates are available through your device's app store.

Q: Can I use this on multiple devices?
A: Yes, but collections are stored locally on each device.

SUPPORT

Q: How do I report a bug?
A: Use "Send Feedback" in Settings or email support@rockstoneidentifier.com

Q: Can I suggest new features?
A: We love feedback! Send suggestions through the feedback option.

Q: How do I contact support?
A: Email: support@rockstoneidentifier.com
Response time: 24-48 hours

Still have questions? Contact our support team!''';
  }
}
