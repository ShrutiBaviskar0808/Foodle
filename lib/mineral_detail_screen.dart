import 'package:flutter/material.dart';
import 'models/mineral_model.dart';

class MineralDetailScreen extends StatelessWidget {
  final MineralModel mineral;

  const MineralDetailScreen({super.key, required this.mineral});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  mineral.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 8.0,
                        color: Colors.black,
                      ),
                      Shadow(
                        offset: Offset(0, -2),
                        blurRadius: 8.0,
                        color: Colors.black,
                      ),
                      Shadow(
                        offset: Offset(2, 0),
                        blurRadius: 8.0,
                        color: Colors.black,
                      ),
                      Shadow(
                        offset: Offset(-2, 0),
                        blurRadius: 8.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    mineral.images.isNotEmpty
                        ? Image.network(mineral.images[0], fit: BoxFit.cover)
                        : Container(color: Colors.grey.shade300, child: const Icon(Icons.diamond, size: 100)),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.9),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection('Chemical Formula', mineral.formula),
                    const SizedBox(height: 16),
                    _buildSection('Description', mineral.description),
                    const SizedBox(height: 24),
                    const Text('Physical Properties', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildPropertyRow('Color', mineral.physicalProperties.color, Icons.palette),
                    _buildPropertyRow('Hardness', mineral.physicalProperties.hardness, Icons.hardware),
                    _buildPropertyRow('Luster', mineral.physicalProperties.luster, Icons.auto_awesome),
                    _buildPropertyRow('Crystal System', mineral.physicalProperties.crystalSystem, Icons.grid_4x4),
                    _buildPropertyRow('Specific Gravity', mineral.physicalProperties.specificGravity, Icons.scale),
                    _buildPropertyRow('Streak', mineral.physicalProperties.streak, Icons.brush),
                    _buildPropertyRow('Transparency', mineral.physicalProperties.transparency, Icons.visibility),
                    _buildPropertyRow('Cleavage', mineral.physicalProperties.cleavage, Icons.call_split),
                    if (mineral.images.length > 1) ...[
                      const SizedBox(height: 24),
                      const Text('Gallery', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mineral.images.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(mineral.images[index], width: 120, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 16, height: 1.5), textAlign: TextAlign.justify),
      ],
    );
  }

  Widget _buildPropertyRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.brown),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
