import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/stone_model.dart';

class StoneDetailScreen extends StatefulWidget {
  final String stoneName;
  final String imagePath;
  
  const StoneDetailScreen({super.key, required this.stoneName, required this.imagePath});

  @override
  State<StoneDetailScreen> createState() => _StoneDetailScreenState();
}

class _StoneDetailScreenState extends State<StoneDetailScreen> {
  StoneModel? _stoneData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStoneData();
  }

  Future<void> _fetchStoneData() async {
    try {
      final response = await http.get(Uri.parse('https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/stone_enhanced_version.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final stone = data.firstWhere(
          (item) => item['stoneName'].toString().toLowerCase() == widget.stoneName.toLowerCase(),
          orElse: () => data[0],
        );
        setState(() {
          _stoneData = StoneModel.fromJson(stone);
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
        title: Text(widget.stoneName),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.brown))
            : _stoneData == null
                ? const Center(child: Text('Stone data not found'))
                : SingleChildScrollView(
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
                            child: Image.network(
                              _stoneData!.thumbImageUrl,
                              fit: BoxFit.cover,
                              cacheWidth: 500,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: Colors.brown,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.landscape, size: 80, color: Colors.grey.shade400);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        Text(
                          _stoneData!.stoneName,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.brown.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _stoneData!.gemProperties.rarity,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.brown),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        _buildSection('Description', _stoneData!.stoneDescription),
                        
                        const Text(
                          'Properties',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                        const SizedBox(height: 8),
                        _buildPropertyRow('Colors', _stoneData!.gemProperties.colors),
                        _buildPropertyRow('Hardness', _stoneData!.gemProperties.hardness),
                        _buildPropertyRow('Transparency', _stoneData!.gemProperties.transparency),
                        _buildPropertyRow('Luster', _stoneData!.gemProperties.luster),
                        _buildPropertyRow('Durability', _stoneData!.gemProperties.durability),
                        _buildPropertyRow('Jewelry Use', _stoneData!.gemProperties.jewelryUse),
                        if (_stoneData!.gemProperties.opticalEffects.isNotEmpty)
                          _buildPropertyRow('Optical Effects', _stoneData!.gemProperties.opticalEffects),
                        const SizedBox(height: 20),
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

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
