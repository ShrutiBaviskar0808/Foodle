import 'package:flutter/material.dart';

class GuideDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const GuideDetailScreen({super.key, required this.title, required this.content});

  Color _getGradientColor() {
    if (title.contains('Identify')) return Colors.blue.shade700;
    if (title.contains('Photo')) return Colors.green.shade700;
    if (title.contains('Rocks')) return Colors.orange.shade700;
    if (title.contains('Geology')) return Colors.purple.shade700;
    if (title.contains('Facts')) return Colors.amber.shade700;
    return Colors.brown.shade700;
  }

  IconData _getIcon() {
    if (title.contains('Identify')) return Icons.search;
    if (title.contains('Photo')) return Icons.camera_alt;
    if (title.contains('Rocks')) return Icons.compare;
    if (title.contains('Geology')) return Icons.school;
    if (title.contains('Facts')) return Icons.lightbulb;
    return Icons.book;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getGradientColor();
    final icon = _getIcon();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withValues(alpha: 0.8), color],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Icon(icon, size: 200, color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Icon(icon, size: 150, color: Colors.white.withValues(alpha: 0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.05),
                    Colors.white,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon, color: color, size: 32),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Learn everything about $title',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ),
                        ],
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
    );
  }

  Widget _buildFormattedContent(String text, Color accentColor) {
    final lines = text.split('\n');
    final widgets = <Widget>[];

    for (var line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 12));
      } else if (line.startsWith('LESSON') || 
                 line.contains('FACTS') || 
                 line.contains('MINERALS') ||
                 line.contains('WONDERS') ||
                 line.contains('HOLDERS')) {
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
            child: Text(
              line.trim(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
        widgets.add(const SizedBox(height: 12));
      } else if (line.trim().startsWith('•') || line.trim().startsWith('-')) {
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
      } else if (line.trim().startsWith('🌋') || 
                 line.trim().startsWith('💎') ||
                 line.trim().startsWith('🏔️') ||
                 line.trim().startsWith('⚡') ||
                 line.trim().startsWith('🌈') ||
                 line.trim().startsWith('🔥') ||
                 line.trim().startsWith('✨') ||
                 line.trim().startsWith('🎨') ||
                 line.trim().startsWith('🧲') ||
                 line.trim().startsWith('💧') ||
                 line.trim().startsWith('🌟') ||
                 line.trim().startsWith('🌊') ||
                 line.trim().startsWith('⏰') ||
                 line.trim().startsWith('🌍')) {
        widgets.add(
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withValues(alpha: 0.1)),
            ),
            child: Text(
              line.trim(),
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ),
        );
      } else if (line.trim().endsWith(':')) {
        widgets.add(const SizedBox(height: 16));
        widgets.add(
          Text(
            line.trim(),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        );
        widgets.add(const SizedBox(height: 8));
      } else if (RegExp(r'^\d+\.').hasMatch(line.trim())) {
        widgets.add(const SizedBox(height: 12));
        widgets.add(
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              line.trim(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
}
