import 'package:flutter/material.dart';

class StoneDetailScreen extends StatelessWidget {
  final String stoneName;
  final String imagePath;
  
  const StoneDetailScreen({super.key, required this.stoneName, required this.imagePath});

  Map<String, dynamic> _getStoneData(String name) {
    final data = {
      'Granite': {
        'altNames': 'Granitic Rock, Granitoid',
        'type': 'Igneous Rock - Intrusive (Plutonic)',
        'composition': 'Quartz (20-60%), Alkali Feldspar (10-65%), Plagioclase Feldspar (10-65%), Mica and Amphibole minerals',
        'formation': 'Forms from the slow crystallization of magma deep beneath Earth\'s surface. The slow cooling allows large crystals to develop.',
        'hardness': '6-7 - Hard and durable, resistant to scratching',
        'luster': 'Vitreous to dull luster. Coarse-grained texture with visible crystals.',
        'location': 'Brazil, India, China, USA, Canada, Norway, Scotland',
        'facts': '• One of the oldest rocks on Earth\n• Used in construction for over 4,000 years\n• Word comes from Latin "granum" meaning grain',
      },
      'Quartz': {
        'altNames': 'Rock Crystal, Silicon Dioxide',
        'type': 'Mineral - Silicate',
        'composition': 'Silicon Dioxide (SiO₂)',
        'formation': 'Forms in igneous, metamorphic, and sedimentary rocks through crystallization.',
        'hardness': '7 - Very hard, can scratch glass',
        'luster': 'Vitreous (glassy) luster. Transparent to translucent.',
        'location': 'Found worldwide, abundant in Earth\'s crust',
        'facts': '• Second most abundant mineral\n• Used in watches and electronics\n• Comes in many color varieties',
      },
      'Marble': {
        'altNames': 'Metamorphosed Limestone',
        'type': 'Metamorphic Rock',
        'composition': 'Calcite (CaCO₃), Dolomite',
        'formation': 'Forms from limestone under heat and pressure during metamorphism.',
        'hardness': '3-4 - Relatively soft, can be scratched',
        'luster': 'Vitreous to pearly luster. Fine to coarse-grained texture.',
        'location': 'Italy, Greece, Turkey, India, USA',
        'facts': '• Used by ancient sculptors\n• Michelangelo\'s David is marble\n• Reacts with acid (fizzes)',
      },
      'Basalt': {
        'altNames': 'Volcanic Rock, Trap Rock',
        'type': 'Igneous Rock - Extrusive (Volcanic)',
        'composition': 'Pyroxene, Plagioclase Feldspar, Olivine',
        'formation': 'Forms from rapid cooling of lava at Earth\'s surface.',
        'hardness': '5-6 - Moderately hard',
        'luster': 'Dull to glassy. Fine-grained, sometimes with vesicles.',
        'location': 'Hawaii, Iceland, India (Deccan Traps), Columbia River',
        'facts': '• Most common volcanic rock\n• Forms ocean floor\n• Can form hexagonal columns',
      },
      'Limestone': {
        'altNames': 'Calcareous Rock',
        'type': 'Sedimentary Rock - Chemical/Organic',
        'composition': 'Calcium Carbonate (CaCO₃)',
        'formation': 'Forms from accumulation of shell, coral, and algae remains.',
        'hardness': '3-4 - Soft, easily scratched',
        'luster': 'Dull to earthy. Fine to coarse-grained.',
        'location': 'Worldwide, especially in shallow marine environments',
        'facts': '• Used to make cement\n• Forms caves and stalactites\n• Fizzes with vinegar',
      },
      'Amethyst': {
        'altNames': 'Purple Quartz',
        'type': 'Crystal - Quartz Variety',
        'composition': 'Silicon Dioxide with iron impurities',
        'formation': 'Forms in geodes and cavities through hydrothermal processes.',
        'hardness': '7 - Very hard',
        'luster': 'Vitreous (glassy). Transparent to translucent purple crystals.',
        'location': 'Brazil, Uruguay, Zambia, Russia, USA',
        'facts': '• February birthstone\n• Color from iron and radiation\n• Name means "not intoxicated" in Greek',
      },
    };
    return data[name] ?? data['Granite']!;
  }

  @override
  Widget build(BuildContext context) {
    final stoneData = _getStoneData(stoneName);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(stoneName),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.landscape, size: 80, color: Colors.grey.shade400);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Text(
              stoneName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 8),
            Text(
              'Also known as: ${stoneData['altNames']}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            
            _buildSection('Type & Classification', stoneData['type']),
            _buildSection('Chemical Composition', stoneData['composition']),
            _buildSection('Formation Process', stoneData['formation']),
            _buildSection('Hardness (Mohs Scale)', stoneData['hardness']),
            _buildSection('Luster & Texture', stoneData['luster']),
            _buildSection('Where It Is Found', stoneData['location']),
            _buildSection('Interesting Facts', stoneData['facts']),
          ],
        ),
      ),
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
}
