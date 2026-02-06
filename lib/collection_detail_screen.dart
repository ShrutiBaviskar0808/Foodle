import 'package:flutter/material.dart';

class CollectionDetailScreen extends StatelessWidget {
  final String stoneName;

  const CollectionDetailScreen({super.key, required this.stoneName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(stoneName),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
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
              child: Icon(Icons.landscape, size: 80, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 20),
            Text(
              stoneName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Igneous Rock',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.brown),
              ),
            ),
            const SizedBox(height: 20),
            _buildSection('My Notes', 'Found during hiking trip. Beautiful specimen with visible crystals.'),
            _buildSection('Location', 'Rocky Mountains, Colorado'),
            _buildSection('Date Added', 'December 15, 2024'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('View Full Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
