import 'package:flutter/material.dart';

class InfoDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const InfoDetailScreen({super.key, required this.title, required this.content});

  Color _getColor() {
    if (title.contains('About')) return Colors.blue;
    if (title.contains('How')) return Colors.green;
    if (title.contains('Privacy')) return Colors.purple;
    if (title.contains('Help') || title.contains('FAQ')) return Colors.orange;
    return Colors.brown;
  }

  IconData _getIcon() {
    if (title.contains('About')) return Icons.info;
    if (title.contains('How')) return Icons.help;
    if (title.contains('Privacy')) return Icons.privacy_tip;
    if (title.contains('Help') || title.contains('FAQ')) return Icons.question_answer;
    return Icons.article;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final icon = _getIcon();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withValues(alpha: 0.7)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        _buildFormattedContent(content, color),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormattedContent(String text, Color accentColor) {
    final lines = text.split('\n');
    final widgets = <Widget>[];

    for (var line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 12));
      } else if (line.trim().toUpperCase() == line.trim() && line.trim().length > 3 && !line.contains(':')) {
        widgets.add(const SizedBox(height: 20));
        widgets.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(_getSectionIcon(line), color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    line.trim(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        widgets.add(const SizedBox(height: 12));
      } else if (line.trim().startsWith('•') || line.trim().startsWith('-') || line.trim().startsWith('✓') || line.trim().startsWith('✗')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8, right: 12),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    line.trim().substring(1).trim(),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (line.trim().startsWith('Q:')) {
        widgets.add(const SizedBox(height: 16));
        widgets.add(
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.help_outline, color: accentColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    line.trim().substring(2).trim(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        widgets.add(const SizedBox(height: 8));
      } else if (line.trim().startsWith('A:')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 12),
            child: Text(
              line.trim().substring(2).trim(),
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ),
        );
      } else {
        widgets.add(
          Text(
            line.trim(),
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        );
        widgets.add(const SizedBox(height: 8));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  IconData _getSectionIcon(String section) {
    if (section.contains('MISSION')) return Icons.flag;
    if (section.contains('FEATURES')) return Icons.star;
    if (section.contains('SERVE')) return Icons.people;
    if (section.contains('DIFFERENT')) return Icons.verified;
    if (section.contains('CONTACT')) return Icons.email;
    if (section.contains('STEP')) return Icons.arrow_forward;
    if (section.contains('TIPS')) return Icons.tips_and_updates;
    if (section.contains('TECHNOLOGY')) return Icons.computer;
    if (section.contains('INFORMATION')) return Icons.info;
    if (section.contains('DATA')) return Icons.storage;
    if (section.contains('SECURITY')) return Icons.security;
    if (section.contains('RIGHTS')) return Icons.gavel;
    if (section.contains('GETTING')) return Icons.play_arrow;
    if (section.contains('IDENTIFICATION')) return Icons.search;
    if (section.contains('PHOTOS')) return Icons.camera_alt;
    if (section.contains('COLLECTION')) return Icons.collections;
    if (section.contains('LEARNING')) return Icons.school;
    if (section.contains('TECHNICAL')) return Icons.settings;
    if (section.contains('SUPPORT')) return Icons.support;
    return Icons.article;
  }
}
