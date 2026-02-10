import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SelectFoodsScreen extends StatefulWidget {
  final List<String>? initialFoods;
  final List<Map<String, String>> availableFoods;
  
  const SelectFoodsScreen({super.key, this.initialFoods, required this.availableFoods});

  @override
  State<SelectFoodsScreen> createState() => _SelectFoodsScreenState();
}

class _SelectFoodsScreenState extends State<SelectFoodsScreen> with SingleTickerProviderStateMixin {
  Set<String> selectedFoods = {};
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredFoods = [];
  List<Map<String, String>> allFoods = [];
  List<Map<String, String>> customFoods = [];
  List<Map<String, String>> filteredCustomFoods = [];
  late TabController _tabController;
  bool showAddForm = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController restaurantController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    allFoods = List.from(widget.availableFoods);
    selectedFoods = (widget.initialFoods ?? []).toSet();
    filteredFoods = allFoods;
    _loadCustomFoods();
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    nameController.dispose();
    restaurantController.dispose();
    caloriesController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final String? customFoodsJson = prefs.getString('custom_foods');
    if (customFoodsJson != null) {
      final List<dynamic> decoded = json.decode(customFoodsJson);
      setState(() {
        customFoods = decoded.map((f) => Map<String, String>.from(f)).toList();
        filteredCustomFoods = customFoods;
      });
    }
  }

  void _filterFoods(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredFoods = allFoods;
        filteredCustomFoods = customFoods;
      } else {
        filteredFoods = allFoods
            .where((food) => food['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
        filteredCustomFoods = customFoods
            .where((food) => food['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.orange, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Favorite Food', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text('Help', style: TextStyle(color: Colors.orange, fontSize: 18)),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Favorite Food'),
              Tab(text: 'Custom Food'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.grey),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: _filterFoods,
                      decoration: InputDecoration(
                        hintText: 'Search online',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        suffixIcon: const Icon(Icons.mic, color: Colors.orange),
                        filled: true,
                        fillColor: Colors.grey[100],
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
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFavoriteFoodTab(),
                  _buildCustomFoodTab(),
                ],
              ),
            ),
            if (selectedFoods.isNotEmpty && _tabController.index == 0)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Colors.orange, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, selectedFoods.toList()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Done', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteFoodTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredFoods.length,
      itemBuilder: (context, index) {
        final food = filteredFoods[index];
        final foodName = food['name']!;
        final isSelected = selectedFoods.contains(foodName);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(food['image']!, width: 60, height: 60, fit: BoxFit.cover),
            ),
            title: Text(foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food['restaurant']!, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text('${food['calories']} Calories', style: const TextStyle(fontSize: 12, color: Colors.orange)),
                  ],
                ),
              ],
            ),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedFoods.add(foodName);
                  } else {
                    selectedFoods.remove(foodName);
                  }
                });
              },
              activeColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedFoods.remove(foodName);
                } else {
                  selectedFoods.add(foodName);
                }
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildCustomFoodTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add Custom Food', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Food Name',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: restaurantController,
            decoration: InputDecoration(
              labelText: 'Restaurant/Place',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: caloriesController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Calories',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final newFood = {
                    'name': nameController.text,
                    'restaurant': restaurantController.text.isEmpty ? 'Custom' : restaurantController.text,
                    'calories': caloriesController.text.isEmpty ? '0' : caloriesController.text,
                    'image': '',
                  };
                  customFoods.add(newFood);
                  selectedFoods.add(nameController.text);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('custom_foods', json.encode(customFoods));
                  if (mounted) Navigator.pop(context, selectedFoods.toList());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
