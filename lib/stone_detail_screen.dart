import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/stone_model.dart';

class StoneDetailScreen extends StatefulWidget {
  final StoneModel stone;
  
  const StoneDetailScreen({super.key, required this.stone});

  @override
  State<StoneDetailScreen> createState() => _StoneDetailScreenState();
}

class _StoneDetailScreenState extends State<StoneDetailScreen> {
  List<String> _relatedImages = [];
  bool _loadingImages = true;

  @override
  void initState() {
    super.initState();
    _fetchRelatedImages();
  }

  Future<void> _fetchRelatedImages() async {
    try {
      final query = Uri.encodeComponent('${widget.stone.stoneName} stone');
      final response = await http.get(
        Uri.parse('https://pixabay.com/api/?key=46894138-1d3e5fe98c5b8d8e5e0e0e0e0&q=$query&image_type=photo&per_page=3'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final images = (data['hits'] as List)
            .map((img) => img['largeImageURL'] as String)
            .toList();
        setState(() {
          _relatedImages = images.isNotEmpty ? images : widget.stone.images;
          _loadingImages = false;
        });
      } else {
        setState(() {
          _relatedImages = widget.stone.images;
          _loadingImages = false;
        });
      }
    } catch (e) {
      setState(() {
        _relatedImages = widget.stone.images;
        _loadingImages = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.stone.stoneName, style: const TextStyle(fontWeight: FontWeight.bold)),
                background: Image.network(
                  widget.stone.images.isNotEmpty ? widget.stone.images.first : widget.stone.thumbImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.brown.shade300,
                    child: const Icon(Icons.landscape, size: 100, color: Colors.white),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.stone.gemProperties.rarity,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.brown),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSection('Description', widget.stone.stoneDescription),
                    const SizedBox(height: 24),
                    const Text('Properties', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildPropertyRow('Colors', widget.stone.gemProperties.colors, Icons.palette),
                    _buildPropertyRow('Hardness', widget.stone.gemProperties.hardness, Icons.hardware),
                    _buildPropertyRow('Luster', widget.stone.gemProperties.luster, Icons.auto_awesome),
                    _buildPropertyRow('Transparency', widget.stone.gemProperties.transparency, Icons.visibility),
                    _buildPropertyRow('Durability', widget.stone.gemProperties.durability, Icons.shield),
                    _buildPropertyRow('Jewelry Use', widget.stone.gemProperties.jewelryUse, Icons.diamond),
                    if (widget.stone.gemProperties.opticalEffects.isNotEmpty)
                      _buildPropertyRow('Optical Effects', widget.stone.gemProperties.opticalEffects, Icons.blur_on),
                    const SizedBox(height: 24),
                    const Text('Gallery', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _loadingImages
                        ? const Center(child: CircularProgressIndicator(color: Colors.brown))
                        : SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _relatedImages.length,
                              itemBuilder: (context, index) => _buildGalleryImage(_relatedImages[index]),
                            ),
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

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
      ],
    );
  }

  Widget _buildPropertyRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.brown),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          cacheWidth: 400,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 200,
              height: 200,
              color: Colors.grey.shade200,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  color: Colors.brown,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            width: 200,
            height: 200,
            color: Colors.grey.shade200,
            child: const Icon(Icons.landscape, size: 60, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
