import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stone_detail_screen.dart';
import 'models/stone_model.dart';

class StoneDatabaseScreen extends StatefulWidget {
  const StoneDatabaseScreen({super.key});

  @override
  State<StoneDatabaseScreen> createState() => _StoneDatabaseScreenState();
}

class _StoneDatabaseScreenState extends State<StoneDatabaseScreen> {
  List<StoneModel> _stones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStones();
  }

  Future<void> _loadStones() async {
    try {
      final response = await http.get(Uri.parse('https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/stone_enhanced_version.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _stones = data.map((json) => StoneModel.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Stone Database'),
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.brown))
            : _stones.isEmpty
                ? const Center(child: Text('No stones available'))
                : ListView(
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
          ..._stones.map((stone) => _buildStoneItem(context, stone)),
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

  Widget _buildStoneItem(BuildContext context, StoneModel stone) {
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  stone.images.isNotEmpty ? stone.images.first : stone.thumbImageUrl,
                  fit: BoxFit.cover,
                  cacheWidth: 120,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.landscape, size: 30, color: Colors.grey.shade400),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stone.stoneName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stone.gemProperties.rarity,
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
