import 'package:flutter/material.dart';
import 'stone_data.dart';
import 'stone_detail_screen.dart';

class StonesTab extends StatefulWidget {
  const StonesTab({super.key});

  @override
  State<StonesTab> createState() => _StonesTabState();
}

class _StonesTabState extends State<StonesTab> {
  final TextEditingController _searchController = TextEditingController();
  List<StoneData> _filteredStones = stoneDatabase;

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
              child: Center(
                child: Icon(Icons.landscape, size: 50, color: Colors.white.withValues(alpha: 0.8)),
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
