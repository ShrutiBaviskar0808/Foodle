import 'package:flutter/material.dart';

class FieldToolsScreen extends StatelessWidget {
  const FieldToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Tools'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildToolCard(
            'Streak Test',
            'Rub mineral on unglazed porcelain to see powder color',
            Icons.brush,
            Colors.red,
            ['Hematite: Red-brown streak', 'Pyrite: Greenish-black streak', 'Magnetite: Black streak'],
          ),
          _buildToolCard(
            'Hardness Test',
            'Scratch mineral with common objects to determine hardness',
            Icons.hardware,
            Colors.orange,
            ['Fingernail: 2.5', 'Copper coin: 3.5', 'Steel knife: 5.5', 'Glass: 5.5-6'],
          ),
          _buildToolCard(
            'Acid Test',
            'Apply dilute HCl to test for carbonate minerals',
            Icons.science,
            Colors.yellow.shade700,
            ['Calcite: Strong fizzing', 'Dolomite: Weak fizzing', 'Quartz: No reaction'],
          ),
          _buildToolCard(
            'Magnet Test',
            'Check if mineral is attracted to a magnet',
            Icons.trip_origin,
            Colors.purple,
            ['Magnetite: Strongly magnetic', 'Pyrrhotite: Weakly magnetic', 'Most minerals: Non-magnetic'],
          ),
          _buildToolCard(
            'Luster Observation',
            'Examine how light reflects off mineral surface',
            Icons.light_mode,
            Colors.blue,
            ['Metallic: Shiny like metal', 'Vitreous: Glassy', 'Pearly: Pearl-like', 'Dull: No shine'],
          ),
          _buildToolCard(
            'Crystal Form',
            'Identify the shape and structure of crystals',
            Icons.diamond,
            Colors.cyan,
            ['Cubic: Pyrite, Galena', 'Hexagonal: Quartz, Beryl', 'Prismatic: Tourmaline'],
          ),
          _buildToolCard(
            'Cleavage Test',
            'Observe how mineral breaks along flat planes',
            Icons.call_split,
            Colors.green,
            ['Perfect: Mica (1 direction)', 'Good: Feldspar (2 directions)', 'None: Quartz (fractures)'],
          ),
          _buildToolCard(
            'Specific Gravity',
            'Estimate density by hefting the specimen',
            Icons.scale,
            Colors.brown,
            ['Light: < 2.5 (Halite)', 'Average: 2.5-4 (Quartz)', 'Heavy: > 4 (Galena, Gold)'],
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Safety Tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSafetyItem('Always wear safety goggles when testing'),
                  _buildSafetyItem('Use dilute acids carefully and in ventilated areas'),
                  _buildSafetyItem('Wash hands after handling minerals'),
                  _buildSafetyItem('Never taste or ingest minerals'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(String title, String description, IconData icon, Color color, List<String> examples) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Examples:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...examples.map((e) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: color),
                      const SizedBox(width: 8),
                      Expanded(child: Text(e)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
