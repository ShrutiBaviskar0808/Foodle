import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stone_data.dart';
import 'stone_detail_screen.dart';
import 'models/stone_model.dart';

class StonesTab extends StatefulWidget {
  const StonesTab({super.key});

  @override
  State<StonesTab> createState() => _StonesTabState();
}

class _StonesTabState extends State<StonesTab> {
  final TextEditingController _searchController = TextEditingController();
  List<StoneData> _filteredStones = stoneDatabase;
  Map<String, String> _stoneImages = {};
  bool _imagesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadStoneImages();
  }

  Future<void> _loadStoneImages() async {
    try {
      final response = await http.get(Uri.parse('https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/stone_enhanced_version.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          for (var item in data) {
            final stoneModel = StoneModel.fromJson(item);
            _stoneImages[stoneModel.stoneName] = stoneModel.thumbImageUrl;
          }
          _imagesLoaded = true;
        });
      }
    } catch (e) {
      setState(() => _imagesLoaded = true);
    }
  }

  void _filterStones(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStones = stoneDatabase;
      } else {
        _filteredStones = stoneDatabase.where((stone) => stone.name.toLowerCase().contains(query.toLowerCase()) || stone.type.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.tune, color: Colors.grey),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterStones,
                  decoration: InputDecoration(
                    hintText: 'Search stones',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.mic, color: Colors.brown),
                      onPressed: () {},
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'All Stones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
              ),
              const Spacer(),
              Text(
                '${_filteredStones.length} items',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: _filteredStones.length,
            itemBuilder: (context, index) {
              final stone = _filteredStones[index];
              return _buildStoneCard(stone);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStoneCard(StoneData stone) {
    final imageUrl = _stoneImages[stone.name];
    final imageMap = {
      'Granite': 'assets/images/granite.jpg',
      'Basalt': 'assets/images/basalt.jpg',
      'Marble': 'assets/images/marble.jpg',
      'Limestone': 'assets/images/limestone.jpg',
      'Quartz': 'assets/images/quartz.jpg',
      'Amethyst': 'assets/images/amethyst.jpg',
    };
    final localImage = imageMap[stone.name];

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StoneDetailScreen(stone: stone))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.brown.shade300, Colors.brown.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: imageUrl != null
                    ? Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity, cacheWidth: 240, loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null, color: Colors.white, strokeWidth: 2));
                      }, errorBuilder: (context, error, stackTrace) => localImage != null ? Image.asset(localImage, fit: BoxFit.cover, width: double.infinity) : Center(child: Icon(Icons.landscape, size: 50, color: Colors.white.withValues(alpha: 0.8))))
                    : localImage != null
                        ? Image.asset(localImage, fit: BoxFit.cover, width: double.infinity, errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.landscape, size: 50, color: Colors.white.withValues(alpha: 0.8))))
                        : Center(child: Icon(Icons.landscape, size: 50, color: Colors.white.withValues(alpha: 0.8))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stone.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    stone.type,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.palette, size: 14, color: Colors.brown.shade300),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          stone.color,
                          style: TextStyle(fontSize: 12, color: Colors.brown.shade300),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
