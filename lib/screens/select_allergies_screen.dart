import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectAllergiesScreen extends StatefulWidget {
  final List<String>? initialAllergies;
  
  const SelectAllergiesScreen({super.key, this.initialAllergies});

  @override
  State<SelectAllergiesScreen> createState() => _SelectAllergiesScreenState();
}

class _SelectAllergiesScreenState extends State<SelectAllergiesScreen> {
  final List<String> availableAllergies = [
    'Watermelon', 'Mustered', 'Humans', 'Cucumber', 'Bikes',
    'Peanuts', 'Tree Nuts', 'Milk', 'Eggs', 'Wheat',
    'Soy', 'Fish', 'Shellfish', 'Sesame', 'Corn',
    'Gluten', 'Lactose', 'Sulfites', 'Celery', 'Lupin',
    'Molluscs', 'Mustard', 'Pork', 'Beef', 'Chicken',
    'Garlic', 'Onion', 'Tomato', 'Strawberry', 'Kiwi',
    'Banana', 'Avocado', 'Mango', 'Peach', 'Apple',
    'Orange', 'Lemon', 'Lime', 'Grapefruit', 'Pineapple',
  ];
  
  Set<String> selectedAllergies = {};
  TextEditingController searchController = TextEditingController();
  List<String> filteredAllergies = [];

  @override
  void initState() {
    super.initState();
    selectedAllergies = (widget.initialAllergies ?? []).toSet();
    filteredAllergies = availableAllergies;
  }

  void _filterAllergies(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAllergies = availableAllergies;
      } else {
        filteredAllergies = availableAllergies
            .where((allergy) => allergy.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _addCustomAllergy() async {
    final query = searchController.text.trim();
    if (query.isNotEmpty && !availableAllergies.any((a) => a.toLowerCase() == query.toLowerCase())) {
      setState(() {
        availableAllergies.add(query);
        selectedAllergies.add(query);
        searchController.clear();
        filteredAllergies = availableAllergies;
      });
      // Save custom allergies
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('custom_allergies', availableAllergies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Allergies',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
        children: [
          const SizedBox(height: 10),
          if (selectedAllergies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selected Allergies', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: selectedAllergies.map((allergy) => Chip(
                      label: Text(allergy),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => setState(() => selectedAllergies.remove(allergy)),
                      backgroundColor: const Color(0xFFFFE4CC),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    )).toList(),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: searchController,
              onChanged: _filterAllergies,
              decoration: InputDecoration(
                hintText: 'Search or add custom allergy',
                filled: true,
                fillColor: Colors.grey[100],
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.orange, size: 28),
                  onPressed: _addCustomAllergy,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredAllergies.length,
              itemBuilder: (context, index) {
                final allergy = filteredAllergies[index];
                final isSelected = selectedAllergies.contains(allergy);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedAllergies.remove(allergy);
                        } else {
                          selectedAllergies.add(allergy);
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(child: Text(allergy, style: const TextStyle(fontSize: 18))),
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
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, selectedAllergies.toList()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Save', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
