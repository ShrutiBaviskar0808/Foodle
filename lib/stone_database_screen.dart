import 'package:flutter/material.dart';
import 'stone_detail_screen.dart';
import 'stone_data.dart';

class StoneDatabaseScreen extends StatelessWidget {
  const StoneDatabaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Stone Database'),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search stones...',
              prefixIcon: const Icon(Icons.search, color: Colors.brown),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.brown, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Categories
          const Text(
            'Categories',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildCategoryCard('Rocks', Icons.terrain, Colors.brown)),
              const SizedBox(width: 12),
              Expanded(child: _buildCategoryCard('Minerals', Icons.diamond, Colors.purple)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildCategoryCard('Crystals', Icons.auto_awesome, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildCategoryCard('Gems', Icons.star, Colors.orange)),
            ],
          ),
          const SizedBox(height: 24),
          
          // Popular Stones
          const Text(
            'Popular Stones',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildStoneItem(context, 'Granite', 'Igneous Rock'),
          _buildStoneItem(context, 'Quartz', 'Mineral'),
          _buildStoneItem(context, 'Marble', 'Metamorphic Rock'),
          _buildStoneItem(context, 'Basalt', 'Igneous Rock'),
          _buildStoneItem(context, 'Limestone', 'Sedimentary Rock'),
          _buildStoneItem(context, 'Amethyst', 'Crystal'),
        ],
      ),
      ),
    );
  }

  Widget _buildCategoryCard(String name, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoneItem(BuildContext context, String name, String type) {
    final stone = stoneDatabase.firstWhere((s) => s.name == name, orElse: () => stoneDatabase[0]);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoneDetailScreen(stone: stone),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.landscape, size: 30, color: Colors.grey.shade400),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
