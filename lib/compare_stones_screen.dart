import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stone_detail_screen.dart';
import 'models/stone_model.dart';

class CompareStonesScreen extends StatefulWidget {
  const CompareStonesScreen({super.key});

  @override
  State<CompareStonesScreen> createState() => _CompareStonesScreenState();
}

class _CompareStonesScreenState extends State<CompareStonesScreen> {
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Compare Similar Stones'),
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator(color: Colors.brown)),
      );
    }

    final granite = _stones.firstWhere((s) => s.stoneName.contains('Granite'), orElse: () => _stones.isNotEmpty ? _stones[0] : _stones[0]);
    final similar = _stones.where((s) => !s.stoneName.contains('Granite')).take(3).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Compare Similar Stones'),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Your Stone',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildStoneCard(context, granite, true),
          const SizedBox(height: 24),
          const Text(
            'Similar Stones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (similar.isNotEmpty) _buildStoneCard(context, similar[0], false),
          const SizedBox(height: 12),
          if (similar.length > 1) _buildStoneCard(context, similar[1], false),
          const SizedBox(height: 12),
          if (similar.length > 2) _buildStoneCard(context, similar[2], false),
        ],
      ),
      ),
    );
  }

  Widget _buildStoneCard(BuildContext context, StoneModel stone, bool isYourStone) {
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
        decoration: BoxDecoration(
          color: isYourStone ? Colors.brown.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isYourStone ? Colors.brown : Colors.grey.shade300,
            width: isYourStone ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  stone.thumbImageUrl,
                  fit: BoxFit.cover,
                  cacheWidth: 200,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.landscape,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          stone.stoneName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isYourStone) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Match',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      stone.gemProperties.colors,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.arrow_forward, size: 16, color: Colors.brown.shade400),
                        const SizedBox(width: 4),
                        Text(
                          'Tap to view details',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.brown.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
