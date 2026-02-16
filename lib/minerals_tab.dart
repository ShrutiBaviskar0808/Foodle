import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/mineral_model.dart';
import 'mineral_detail_screen.dart';

class MineralsTab extends StatefulWidget {
  const MineralsTab({super.key});

  @override
  State<MineralsTab> createState() => _MineralsTabState();
}

class _MineralsTabState extends State<MineralsTab> {
  int _currentPage = 1;
  int _visiblePage = 1;
  List<MineralModel> _minerals = [];
  List<MineralModel> _filteredMinerals = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final int _maxPages = 7;

  @override
  void initState() {
    super.initState();
    _fetchMinerals(_currentPage);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final position = _scrollController.position.pixels;
      final itemHeight = 200.0;
      final itemsPerRow = 2;
      final totalRows = (_filteredMinerals.length / itemsPerRow).ceil();
      final scrollableHeight = totalRows * itemHeight;
      
      if (_filteredMinerals.isNotEmpty) {
        final progress = position / scrollableHeight;
        final newVisiblePage = (progress * _currentPage).ceil().clamp(1, _currentPage);
        if (newVisiblePage != _visiblePage) {
          setState(() => _visiblePage = newVisiblePage);
        }
      }
    }
    
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore && _currentPage < _maxPages && _searchController.text.isEmpty) {
      _loadPagesUpTo(_currentPage + 1);
    }
  }

  Future<void> _loadPagesUpTo(int targetPage) async {
    if (_isLoadingMore || targetPage <= _currentPage) return;
    setState(() => _isLoadingMore = true);
    
    for (int page = _currentPage + 1; page <= targetPage; page++) {
      try {
        final response = await http.get(Uri.parse('https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/minerals_database/minerals_part_$page.json'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            _minerals.addAll(data.map((json) => MineralModel.fromJson(json)).toList());
            _filteredMinerals = _minerals;
            _currentPage = page;
          });
        }
      } catch (e) {
        break;
      }
    }
    
    setState(() => _isLoadingMore = false);
  }

  void _scrollToPage(int page) async {
    if (page > _currentPage) {
      await _loadPagesUpTo(page);
    }
    
    if (_scrollController.hasClients) {
      final itemsPerPage = 50;
      final itemsPerRow = 2;
      final itemHeight = 200.0;
      final targetIndex = (page - 1) * itemsPerPage;
      final targetRow = targetIndex ~/ itemsPerRow;
      final targetPosition = targetRow * itemHeight;
      
      _scrollController.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _fetchMinerals(int page) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('https://publicassetsdata.sfo3.cdn.digitaloceanspaces.com/smit/MockAPI/minerals_database/minerals_part_$page.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _minerals = data.map((json) => MineralModel.fromJson(json)).toList();
          _filteredMinerals = _minerals;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterMinerals(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMinerals = _minerals;
      } else {
        _filteredMinerals = _minerals.where((mineral) => mineral.name.toLowerCase().contains(query.toLowerCase())).toList();
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
                  onChanged: _filterMinerals,
                  decoration: InputDecoration(
                    hintText: 'Search minerals',
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
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _maxPages,
            itemBuilder: (context, index) {
              final page = index + 1;
              final isLoaded = page <= _currentPage;
              final isVisible = page == _visiblePage;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => _scrollToPage(page),
                  child: Chip(
                    label: Text('Page $page'),
                    backgroundColor: isVisible ? Colors.brown : (isLoaded ? Colors.brown.shade100 : Colors.grey.shade200),
                    labelStyle: TextStyle(
                      color: isVisible ? Colors.white : (isLoaded ? Colors.brown : Colors.grey.shade500),
                      fontWeight: isVisible ? FontWeight.bold : FontWeight.w600,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.brown))
              : GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _filteredMinerals.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _filteredMinerals.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(color: Colors.brown),
                        ),
                      );
                    }
                    final mineral = _filteredMinerals[index];
                    return _buildMineralCard(mineral);
                  },
                ),
        ),
      ],
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

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
