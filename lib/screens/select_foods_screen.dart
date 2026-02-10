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

class _SelectFoodsScreenState extends State<SelectFoodsScreen> {
  Set<String> selectedFoods = {};
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredFoods = [];
  List<Map<String, String>> allFoods = [];

  @override
  void initState() {
    super.initState();
    allFoods = List.from(widget.availableFoods);
    selectedFoods = (widget.initialFoods ?? []).toSet();
    filteredFoods = allFoods;
  }

  void _filterFoods(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredFoods = allFoods;
      } else {
        filteredFoods = allFoods
            .where((food) => food['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showAddFoodDialog() {
    final nameController = TextEditingController();
    final restaurantController = TextEditingController();
    final caloriesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFFF5E6D3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Custom Food', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: restaurantController,
                decoration: InputDecoration(
                  labelText: 'Restaurant/Place',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.brown)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isNotEmpty) {
                        final newFood = {
                          'name': nameController.text,
                          'restaurant': restaurantController.text.isEmpty ? 'Custom' : restaurantController.text,
                          'calories': caloriesController.text.isEmpty ? '0' : caloriesController.text,
                          'image': '',
                        };
                        setState(() {
                          allFoods.add(newFood);
                          selectedFoods.add(nameController.text);
                          filteredFoods = allFoods;
                        });
                        // Save to SharedPreferences
                        final prefs = await SharedPreferences.getInstance();
                        final customFoods = allFoods.where((f) => f['image']!.isEmpty).toList();
                        await prefs.setString('custom_foods', json.encode(customFoods));
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Add', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.brown),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Text('Select Favorite Foods', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400)),
            const SizedBox(height: 20),
            if (selectedFoods.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 120),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    children: selectedFoods.map((food) => Chip(
                      label: Text(food),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => setState(() => selectedFoods.remove(food)),
                      backgroundColor: const Color(0xFFE8D4B8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    )).toList(),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: searchController,
                onChanged: _filterFoods,
                decoration: InputDecoration(
                  hintText: 'Search or add new food...',
                  prefixIcon: const Icon(Icons.search, size: 28),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.orange),
                    onPressed: _showAddFoodDialog,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD4B896)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD4B896)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                itemCount: filteredFoods.length,
                itemBuilder: (context, index) {
                  final food = filteredFoods[index];
                  final foodName = food['name']!;
                  final isSelected = selectedFoods.contains(foodName);
                  final hasImage = food['image']!.isNotEmpty;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedFoods.remove(foodName);
                          } else {
                            selectedFoods.add(foodName);
                          }
                        });
                      },
                      child: Row(
                        children: [
                          if (hasImage)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(food['image']!, width: 50, height: 50, fit: BoxFit.cover),
                            )
                          else
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  foodName[0].toUpperCase(),
                                  style: const TextStyle(fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(foodName, style: const TextStyle(fontSize: 18))),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(4),
                              color: isSelected ? Colors.orange : Colors.transparent,
                            ),
                            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(fontSize: 18, color: Colors.brown)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, selectedFoods.toList()),
                    child: const Text('Done', style: TextStyle(fontSize: 18, color: Colors.brown)),
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
