import 'package:flutter/material.dart';
import 'collection_detail_screen.dart';

class MyCollectionScreen extends StatefulWidget {
  const MyCollectionScreen({super.key});

  @override
  State<MyCollectionScreen> createState() => _MyCollectionScreenState();
}

class _MyCollectionScreenState extends State<MyCollectionScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  
  final List<Map<String, String>> _allStones = [
    {'name': 'Granite', 'type': 'Igneous Rock', 'image': 'assets/images/granite.jpg'},
    {'name': 'Quartz', 'type': 'Mineral', 'image': 'assets/images/quartz.jpg'},
    {'name': 'Marble', 'type': 'Metamorphic Rock', 'image': 'assets/images/marble.jpg'},
    {'name': 'Basalt', 'type': 'Igneous Rock', 'image': 'assets/images/basalt.jpg'},
    {'name': 'Limestone', 'type': 'Sedimentary Rock', 'image': 'assets/images/limestone.jpg'},
    {'name': 'Amethyst', 'type': 'Crystal', 'image': 'assets/images/amethyst.jpg'},
  ];

  List<Map<String, String>> get _filteredStones {
    return _allStones.where((stone) {
      final matchesSearch = stone['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' || stone['type'] == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Collection'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter stone name...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('All'),
            _buildFilterOption('Igneous Rock'),
            _buildFilterOption('Sedimentary Rock'),
            _buildFilterOption('Metamorphic Rock'),
            _buildFilterOption('Mineral'),
            _buildFilterOption('Crystal'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String filter) {
    return RadioListTile<String>(
      title: Text(filter),
      value: filter,
      groupValue: _selectedFilter,
      onChanged: (value) {
        setState(() {
          _selectedFilter = value!;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredStones = _filteredStones;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('My Collection'),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _showSearchDialog),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterDialog),
        ],
      ),
      body: SafeArea(
        child: filteredStones.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No stones found',
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _selectedFilter = 'All';
                        });
                      },
                      child: const Text('Clear filters'),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredStones.length,
                itemBuilder: (context, index) {
                  final stone = filteredStones[index];
                  return _buildCollectionItem(
                    context,
                    stone['name']!,
                    stone['type']!,
                    stone['image']!,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildCollectionItem(BuildContext context, String name, String type, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionDetailScreen(stoneName: name, imagePath: imagePath),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  cacheWidth: 300,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(Icons.landscape, size: 50, color: Colors.grey.shade400),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    type,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.brown.shade300),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Saved',
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
