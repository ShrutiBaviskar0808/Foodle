import 'package:flutter/material.dart';

class MohsHardnessScaleScreen extends StatelessWidget {
  const MohsHardnessScaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal.shade700, Colors.teal.shade400, Colors.cyan.shade300],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mohs Hardness Scale',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            'Mineral Hardness Reference',
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildHardnessCard(
                      1,
                      'Talc',
                      'Softest mineral - Can be scratched by fingernail',
                      'Used in baby powder and cosmetics',
                      Colors.grey.shade300,
                      Colors.grey.shade500,
                      Icons.touch_app,
                    ),
                    _buildHardnessCard(
                      2,
                      'Gypsum',
                      'Can be scratched by fingernail',
                      'Used to make plaster and drywall',
                      Colors.blue.shade200,
                      Colors.blue.shade400,
                      Icons.construction,
                    ),
                    _buildHardnessCard(
                      3,
                      'Calcite',
                      'Can be scratched by copper coin',
                      'Main component of limestone and marble',
                      Colors.amber.shade200,
                      Colors.amber.shade500,
                      Icons.monetization_on,
                    ),
                    _buildHardnessCard(
                      4,
                      'Fluorite',
                      'Can be scratched by steel knife',
                      'Glows under UV light (fluorescence)',
                      Colors.purple.shade200,
                      Colors.purple.shade500,
                      Icons.lightbulb,
                    ),
                    _buildHardnessCard(
                      5,
                      'Apatite',
                      'Can be scratched by steel knife with difficulty',
                      'Found in teeth and bones',
                      Colors.green.shade300,
                      Colors.green.shade600,
                      Icons.health_and_safety,
                    ),
                    _buildHardnessCard(
                      6,
                      'Orthoclase',
                      'Can scratch glass',
                      'Common feldspar in granite',
                      Colors.pink.shade200,
                      Colors.pink.shade500,
                      Icons.window,
                    ),
                    _buildHardnessCard(
                      7,
                      'Quartz',
                      'Scratches glass easily',
                      'Second most abundant mineral on Earth',
                      Colors.orange.shade300,
                      Colors.orange.shade600,
                      Icons.star,
                    ),
                    _buildHardnessCard(
                      8,
                      'Topaz',
                      'Scratches quartz',
                      'Popular gemstone in jewelry',
                      Colors.yellow.shade300,
                      Colors.yellow.shade700,
                      Icons.diamond_outlined,
                    ),
                    _buildHardnessCard(
                      9,
                      'Corundum',
                      'Scratches topaz - Ruby & Sapphire',
                      'Second hardest natural mineral',
                      Colors.red.shade300,
                      Colors.red.shade700,
                      Icons.favorite,
                    ),
                    _buildHardnessCard(
                      10,
                      'Diamond',
                      'Hardest natural substance on Earth',
                      'Can only be scratched by another diamond',
                      Colors.indigo.shade300,
                      Colors.indigo.shade800,
                      Icons.diamond,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHardnessCard(
    int level,
    String mineral,
    String hardness,
    String fact,
    Color color1,
    Color color2,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color2.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Icon(icon, size: 140, color: Colors.white.withValues(alpha: 0.15)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '$level',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: Colors.white, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              mineral,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hardness,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fact,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
