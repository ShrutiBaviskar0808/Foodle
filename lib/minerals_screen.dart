import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/mineral_model.dart';
import 'mineral_detail_screen.dart';

class MineralsScreen extends StatefulWidget {
  const MineralsScreen({super.key});

  @override
  State<MineralsScreen> createState() => _MineralsScreenState();
}

class _MineralsScreenState extends State<MineralsScreen> {
  int _currentPage = 1;
  List<MineralModel> _minerals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMinerals(_currentPage);
  }

  Future<void> _fetchMinerals(int page) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/minerals_database/minerals_part_$page.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _minerals = data.map((json) => MineralModel.fromJson(json)).toList();
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
        title: const Text('Minerals Database'),
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'Page $_currentPage/7',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: _minerals.length,
              itemBuilder: (context, index) {
                final mineral = _minerals[index];
                return _buildMineralCard(mineral);
              },
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_currentPage > 1)
            FloatingActionButton(
              heroTag: 'prev',
              mini: true,
              backgroundColor: Colors.brown,
              onPressed: () {
                setState(() => _currentPage--);
                _fetchMinerals(_currentPage);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          const SizedBox(width: 16),
          if (_currentPage < 7)
            FloatingActionButton(
              heroTag: 'next',
              mini: true,
              backgroundColor: Colors.brown,
              onPressed: () {
                setState(() => _currentPage++);
                _fetchMinerals(_currentPage);
              },
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildMineralCard(MineralModel mineral) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MineralDetailScreen(mineral: mineral))),
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
              color: Colors.grey.shade200,
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
              child: mineral.images.isNotEmpty
                  ? Image.network(
                      mineral.images[0],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      cacheWidth: 240,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.brown,
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.diamond, size: 50, color: Colors.grey.shade400),
                        );
                      },
                    )
                  : Center(
                      child: Icon(Icons.diamond, size: 50, color: Colors.grey.shade400),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mineral.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  mineral.formula,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.diamond_outlined, size: 14, color: Colors.brown.shade300),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        mineral.physicalProperties.color,
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
}
