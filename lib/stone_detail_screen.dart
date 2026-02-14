import 'package:flutter/material.dart';
import 'models/stone_model.dart';

class StoneDetailScreen extends StatelessWidget {
  final StoneModel stone;
  
  const StoneDetailScreen({super.key, required this.stone});

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
                title: Text(stone.stoneName, style: const TextStyle(fontWeight: FontWeight.bold)),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      stone.images.isNotEmpty ? stone.images.first : stone.thumbImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.brown.shade300,
                        child: const Icon(Icons.landscape, size: 100, color: Colors.white),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        stone.gemProperties.rarity,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.brown),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSection('Description', stone.stoneDescription),
                    const SizedBox(height: 24),
                    const Text('Properties', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildPropertyRow('Colors', stone.gemProperties.colors, Icons.palette),
                    _buildPropertyRow('Hardness', stone.gemProperties.hardness, Icons.hardware),
                    _buildPropertyRow('Luster', stone.gemProperties.luster, Icons.auto_awesome),
                    _buildPropertyRow('Transparency', stone.gemProperties.transparency, Icons.visibility),
                    _buildPropertyRow('Durability', stone.gemProperties.durability, Icons.shield),
                    _buildPropertyRow('Jewelry Use', stone.gemProperties.jewelryUse, Icons.diamond),
                    if (stone.gemProperties.opticalEffects.isNotEmpty)
                      _buildPropertyRow('Optical Effects', stone.gemProperties.opticalEffects, Icons.blur_on),
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
