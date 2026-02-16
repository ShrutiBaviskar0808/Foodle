import 'package:flutter/material.dart';

class RockFormationTimelineScreen extends StatelessWidget {
  const RockFormationTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown.shade800, Colors.brown.shade600, Colors.orange.shade300],
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
                            'Rock Formation',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            'Journey Through Time',
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
                    _buildTimelineCard(
                      'Seconds to Minutes',
                      'Volcanic Glass Formation',
                      'Obsidian forms when lava cools so rapidly that crystals cannot form. This creates a natural glass with sharp edges.',
                      Icons.flash_on,
                      Colors.black,
                      Colors.grey.shade800,
                    ),
                    _buildTimelineCard(
                      'Hours to Days',
                      'Lava Rock Solidification',
                      'Basalt forms as lava flows cool and solidify. The rapid cooling creates fine-grained rocks with small crystals.',
                      Icons.whatshot,
                      Colors.red.shade900,
                      Colors.red.shade700,
                    ),
                    _buildTimelineCard(
                      'Months to Years',
                      'Cave Formation',
                      'Stalactites and stalagmites form as mineral-rich water drips and evaporates, leaving behind calcite deposits.',
                      Icons.water_drop,
                      Colors.blue.shade800,
                      Colors.blue.shade600,
                    ),
                    _buildTimelineCard(
                      'Thousands of Years',
                      'Sedimentary Layering',
                      'Sandstone forms as sand grains are compressed and cemented together over millennia in ancient riverbeds and beaches.',
                      Icons.layers,
                      Colors.amber.shade800,
                      Colors.amber.shade600,
                    ),
                    _buildTimelineCard(
                      'Millions of Years',
                      'Deep Earth Crystallization',
                      'Granite forms deep underground as magma slowly cools, allowing large crystals to grow over millions of years.',
                      Icons.diamond,
                      Colors.pink.shade800,
                      Colors.pink.shade600,
                    ),
                    _buildTimelineCard(
                      'Hundreds of Millions',
                      'Metamorphic Transformation',
                      'Marble forms as limestone is subjected to extreme heat and pressure deep within mountain ranges over vast time periods.',
                      Icons.compress,
                      Colors.purple.shade800,
                      Colors.purple.shade600,
                    ),
                    _buildTimelineCard(
                      'Billions of Years',
                      'Ancient Earth Rocks',
                      'The oldest rocks on Earth are over 4 billion years old, preserving evidence of our planet\'s early history.',
                      Icons.public,
                      Colors.teal.shade900,
                      Colors.teal.shade700,
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

  Widget _buildTimelineCard(String time, String title, String description, IconData icon, Color color1, Color color2) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(icon, size: 120, color: Colors.white.withValues(alpha: 0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.8),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.5,
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
