import 'package:flutter/material.dart';

class CrystalSystemsScreen extends StatelessWidget {
  const CrystalSystemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crystal Systems'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.cyan.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Crystals are classified into 7 systems based on their symmetry and axes. Each system has unique geometric properties.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildCrystalSystemCard(
            'Cubic (Isometric)',
            'Three equal axes at 90° angles',
            'Highest symmetry system',
            Colors.red,
            ['Halite (Salt)', 'Pyrite', 'Galena', 'Fluorite', 'Diamond', 'Garnet'],
            'a = b = c\nα = β = γ = 90°',
          ),
          _buildCrystalSystemCard(
            'Tetragonal',
            'Two equal axes, one different, all at 90°',
            'Square cross-section',
            Colors.orange,
            ['Zircon', 'Rutile', 'Cassiterite', 'Wulfenite', 'Scheelite'],
            'a = b ≠ c\nα = β = γ = 90°',
          ),
          _buildCrystalSystemCard(
            'Orthorhombic',
            'Three unequal axes at 90° angles',
            'Rectangular cross-section',
            Colors.yellow.shade700,
            ['Olivine', 'Aragonite', 'Topaz', 'Barite', 'Sulfur'],
            'a ≠ b ≠ c\nα = β = γ = 90°',
          ),
          _buildCrystalSystemCard(
            'Hexagonal',
            'Three equal axes at 120°, one perpendicular',
            'Six-fold symmetry',
            Colors.green,
            ['Quartz', 'Beryl', 'Apatite', 'Calcite', 'Corundum'],
            'a = b ≠ c\nα = β = 90°, γ = 120°',
          ),
          _buildCrystalSystemCard(
            'Trigonal (Rhombohedral)',
            'Three equal axes, equal angles not 90°',
            'Three-fold symmetry',
            Colors.blue,
            ['Calcite', 'Dolomite', 'Tourmaline', 'Cinnabar', 'Hematite'],
            'a = b = c\nα = β = γ ≠ 90°',
          ),
          _buildCrystalSystemCard(
            'Monoclinic',
            'Three unequal axes, two at 90°, one oblique',
            'Tilted rectangular shape',
            Colors.purple,
            ['Gypsum', 'Orthoclase', 'Mica', 'Azurite', 'Malachite'],
            'a ≠ b ≠ c\nα = γ = 90° ≠ β',
          ),
          _buildCrystalSystemCard(
            'Triclinic',
            'Three unequal axes, all at different angles',
            'Lowest symmetry system',
            Colors.pink,
            ['Plagioclase Feldspar', 'Kyanite', 'Turquoise', 'Rhodonite'],
            'a ≠ b ≠ c\nα ≠ β ≠ γ ≠ 90°',
          ),
        ],
      ),
    );
  }

  Widget _buildCrystalSystemCard(
    String name,
    String axes,
    String characteristic,
    Color color,
    List<String> minerals,
    String formula,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.diamond, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(axes),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: color, size: 20),
                          const SizedBox(width: 8),
                          const Text('Characteristic:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(characteristic),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calculate, color: color, size: 20),
                          const SizedBox(width: 8),
                          const Text('Formula:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(formula, style: const TextStyle(fontFamily: 'monospace')),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Common Minerals:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: minerals.map((mineral) => Chip(
                    label: Text(mineral),
                    backgroundColor: color.withValues(alpha: 0.2),
                    side: BorderSide(color: color),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
