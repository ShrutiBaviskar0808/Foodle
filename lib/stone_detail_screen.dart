import 'package:flutter/material.dart';
import 'stone_data.dart';

class StoneDetailScreen extends StatelessWidget {
  final StoneData stone;
  
  const StoneDetailScreen({super.key, required this.stone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(stone.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.brown.shade400, Colors.brown.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.landscape, size: 120, color: Colors.white.withValues(alpha: 0.5)),
                ),
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
                      stone.type,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.brown),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection('Formation', stone.formation),
                  _buildSection('Composition', stone.composition),
                  const SizedBox(height: 24),
                  const Text('Physical Properties', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildPropertyRow('Hardness', stone.hardness, Icons.hardware),
                  _buildPropertyRow('Color', stone.color, Icons.palette),
                  const SizedBox(height: 24),
                  _buildSection('Common Uses', stone.uses),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.verified, color: Colors.brown.shade700, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Confidence Score',
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                              ),
                              Text(
                                '${stone.confidence}%',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown.shade700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
          ),
        ],
      ),
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
