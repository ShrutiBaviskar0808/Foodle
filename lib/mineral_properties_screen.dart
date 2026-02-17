import 'package:flutter/material.dart';

class MineralPropertiesScreen extends StatelessWidget {
  const MineralPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mineral Properties'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
          Card(
            color: Colors.pink.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Minerals are identified by their physical and chemical properties. Understanding these properties helps in accurate identification.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildPropertyCard(
            'Color',
            'The visible color of the mineral',
            Icons.palette,
            Colors.red,
            [
              PropertyDetail('Reliable', 'Some minerals have consistent colors (Sulfur - yellow, Malachite - green)'),
              PropertyDetail('Variable', 'Many minerals vary in color due to impurities (Quartz, Corundum)'),
              PropertyDetail('Caution', 'Color alone is not sufficient for identification'),
            ],
          ),
          _buildPropertyCard(
            'Streak',
            'Color of mineral powder on unglazed porcelain',
            Icons.brush,
            Colors.orange,
            [
              PropertyDetail('More Reliable', 'Streak color is more consistent than surface color'),
              PropertyDetail('Hematite', 'Red-brown streak despite black/gray appearance'),
              PropertyDetail('Pyrite', 'Greenish-black streak despite golden color'),
            ],
          ),
          _buildPropertyCard(
            'Luster',
            'How light reflects from the mineral surface',
            Icons.light_mode,
            Colors.yellow.shade700,
            [
              PropertyDetail('Metallic', 'Shiny like polished metal (Pyrite, Galena)'),
              PropertyDetail('Vitreous', 'Glassy appearance (Quartz, Feldspar)'),
              PropertyDetail('Pearly', 'Pearl-like sheen (Talc, Gypsum)'),
              PropertyDetail('Silky', 'Fibrous, silk-like (Asbestos, Satin Spar)'),
              PropertyDetail('Dull/Earthy', 'No shine (Kaolinite, Chalk)'),
            ],
          ),
          _buildPropertyCard(
            'Hardness',
            'Resistance to scratching (Mohs Scale 1-10)',
            Icons.hardware,
            Colors.green,
            [
              PropertyDetail('Soft (1-3)', 'Talc, Gypsum, Calcite - scratched by fingernail/coin'),
              PropertyDetail('Medium (4-6)', 'Fluorite, Apatite, Orthoclase - scratched by steel'),
              PropertyDetail('Hard (7-10)', 'Quartz, Topaz, Diamond - scratch glass'),
            ],
          ),
          _buildPropertyCard(
            'Cleavage',
            'Tendency to break along flat planes',
            Icons.call_split,
            Colors.blue,
            [
              PropertyDetail('Perfect', 'Mica (1 direction), Halite (3 directions)'),
              PropertyDetail('Good', 'Feldspar (2 directions), Calcite (3 directions)'),
              PropertyDetail('Poor/None', 'Quartz shows conchoidal fracture instead'),
            ],
          ),
          _buildPropertyCard(
            'Fracture',
            'How mineral breaks when not along cleavage',
            Icons.broken_image,
            Colors.purple,
            [
              PropertyDetail('Conchoidal', 'Smooth, curved surfaces like broken glass (Quartz, Obsidian)'),
              PropertyDetail('Uneven', 'Rough, irregular surfaces (Most minerals)'),
              PropertyDetail('Splintery', 'Sharp, elongated fragments (Asbestos)'),
            ],
          ),
          _buildPropertyCard(
            'Specific Gravity',
            'Density relative to water',
            Icons.scale,
            Colors.teal,
            [
              PropertyDetail('Light (< 2.5)', 'Halite (2.1), Sulfur (2.0)'),
              PropertyDetail('Average (2.5-4)', 'Quartz (2.65), Calcite (2.71)'),
              PropertyDetail('Heavy (> 4)', 'Galena (7.5), Gold (19.3)'),
            ],
          ),
          _buildPropertyCard(
            'Crystal Form',
            'External shape of well-formed crystals',
            Icons.diamond,
            Colors.cyan,
            [
              PropertyDetail('Cubic', 'Pyrite, Halite, Galena'),
              PropertyDetail('Hexagonal', 'Quartz, Beryl'),
              PropertyDetail('Prismatic', 'Tourmaline, Hornblende'),
              PropertyDetail('Tabular', 'Feldspar, Barite'),
            ],
          ),
          _buildPropertyCard(
            'Special Properties',
            'Unique characteristics of certain minerals',
            Icons.star,
            Colors.indigo,
            [
              PropertyDetail('Magnetism', 'Magnetite attracts magnets'),
              PropertyDetail('Fluorescence', 'Fluorite glows under UV light'),
              PropertyDetail('Radioactivity', 'Uraninite is radioactive'),
              PropertyDetail('Taste', 'Halite tastes salty (DO NOT taste unknown minerals!)'),
              PropertyDetail('Reaction to Acid', 'Calcite fizzes with dilute HCl'),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildPropertyCard(
    String title,
    String description,
    IconData icon,
    Color color,
    List<PropertyDetail> details,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details.map((detail) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_right, color: color, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black87, fontSize: 14),
                          children: [
                            TextSpan(
                              text: '${detail.title}: ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: detail.description),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyDetail {
  final String title;
  final String description;

  PropertyDetail(this.title, this.description);
}
