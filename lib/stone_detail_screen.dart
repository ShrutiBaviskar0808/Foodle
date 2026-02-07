import 'package:flutter/material.dart';

class StoneDetailScreen extends StatelessWidget {
  final String stoneName;
  final String imagePath;
  
  const StoneDetailScreen({super.key, required this.stoneName, required this.imagePath});

  @override
  Widget build(BuildContext context) {
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
            // Stone Image
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
            
            // Stone Name & Alternate Names
            Text(
              stoneName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 8),
            Text(
              'Also known as: Granitic Rock, Granitoid',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            
            // Type and Classification
            _buildSection('Type & Classification', 'Igneous Rock - Intrusive (Plutonic)'),
            
            // Chemical Composition
            _buildSection('Chemical Composition', 'Quartz (20-60%), Alkali Feldspar (10-65%), Plagioclase Feldspar (10-65%), Mica and Amphibole minerals'),
            
            // Formation Process
            _buildSection('Formation Process', 'Forms from the slow crystallization of magma deep beneath Earth\'s surface. The slow cooling allows large crystals to develop, giving granite its characteristic coarse-grained texture.'),
            
            // Hardness
            _buildSection('Hardness (Mohs Scale)', '6-7 - Hard and durable, resistant to scratching'),
            
            // Luster & Texture
            _buildSection('Luster & Texture', 'Vitreous to dull luster. Coarse-grained (phaneritic) texture with visible crystals ranging from 1mm to several centimeters.'),
            
            // Where Found
            _buildSection('Where It Is Found', 'Abundant worldwide. Major deposits in Brazil, India, China, USA (especially New England), Canada, Norway, and Scotland. Forms the foundation of continental crust.'),
            
            // Interesting Facts
            _buildSection('Interesting Facts', '• Granite is one of the oldest rocks on Earth\n• Used in construction for over 4,000 years\n• The word "granite" comes from Latin "granum" meaning grain\n• Makes up a large part of Earth\'s continental crust\n• Can contain small amounts of radioactive elements'),
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
