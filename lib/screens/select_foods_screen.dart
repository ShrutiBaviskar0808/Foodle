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
    _tabController.addListener(() {
      setState(() {});
    });
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
            if (_tabController.index == 0)
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
            if (_tabController.index == 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Tag Your Own Food',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final horizontalPadding = screenWidth * 0.04;
        
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          itemCount: filteredFoods.length,
          itemBuilder: (context, index) {
            final food = filteredFoods[index];
            final foodName = food['name']!;
            final isSelected = selectedFoods.contains(foodName);
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: EdgeInsets.all(screenWidth * 0.03),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    food['image']!,
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: screenWidth * 0.15,
                        height: screenWidth * 0.15,
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.fastfood, color: Colors.orange, size: screenWidth * 0.08),
                      );
                    },
                  ),
                ),
                title: Text(foodName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(food['restaurant']!, style: TextStyle(color: Colors.grey[600], fontSize: screenWidth * 0.03)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.orange, size: screenWidth * 0.035),
                        const SizedBox(width: 4),
                        Text('${food['calories']} Calories', style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.orange)),
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
      },
    );
  }

  Widget _buildCustomFoodTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final horizontalPadding = screenWidth * 0.04;
        
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('What\'s the dish called?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Pepperoni pizza, Mac & cheese',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Where do they love it from?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                TextField(
                  controller: restaurantController,
                  decoration: InputDecoration(
                    hintText: 'Starbucks, Grandma\'s kitchen',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('How much do they love this?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Select Option',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'love', child: Text('❤️ Absolutely Love It')),
                    DropdownMenuItem(value: 'favorite', child: Text('😍 One of Their Favorites')),
                    DropdownMenuItem(value: 'enjoy', child: Text('😋 Really Enjoy It')),
                    DropdownMenuItem(value: 'good', child: Text('🙂 It\'s Pretty Good')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                const Text('When do they crave this?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Select Option',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'happy', child: Text('😊 When they\'re happy')),
                    DropdownMenuItem(value: 'low', child: Text('😔 When they\'re feeling low')),
                    DropdownMenuItem(value: 'celebration', child: Text('🎉 During celebrations')),
                    DropdownMenuItem(value: 'night', child: Text('🌙 Late night cravings')),
                    DropdownMenuItem(value: 'comfort', child: Text('😌 Comfort food moment')),
                    DropdownMenuItem(value: 'energy', child: Text('💪 Energy boost')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                const Text('Have a picture of it?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Upload', style: TextStyle(color: Colors.grey[400])),
                      const Icon(Icons.upload, color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text('Optional, but makes memories sweeter', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                const SizedBox(height: 20),
                const Text('How do they like it made?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                TextField(
                  controller: caloriesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Extra cheese, No onions, Gluten-free crust,\nLight sauce etc..',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isNotEmpty) {
                        final navigator = Navigator.of(context);
                        final newFood = {
                          'name': nameController.text,
                          'restaurant': restaurantController.text.isEmpty ? 'Custom' : restaurantController.text,
                          'calories': '0',
                          'image': '',
                        };
                        customFoods.add(newFood);
                        selectedFoods.add(nameController.text);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('custom_foods', json.encode(customFoods));
                        if (!mounted) return;
                        navigator.pop(selectedFoods.toList());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
