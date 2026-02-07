import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllAllergiesScreen extends StatefulWidget {
  const AllAllergiesScreen({super.key});

  @override
  State<AllAllergiesScreen> createState() => _AllAllergiesScreenState();
}

class _AllAllergiesScreenState extends State<AllAllergiesScreen> {
  Set<String> selectedAllergies = {};

  final List<String> allAllergies = [
    'Watermelon', 'Mustered', 'Humans', 'Cucumber', 'Bikes',
    'Peanuts', 'Tree Nuts', 'Milk', 'Eggs', 'Wheat',
    'Soy', 'Fish', 'Shellfish', 'Sesame', 'Corn',
    'Gluten', 'Lactose', 'Sulfites', 'Celery', 'Lupin',
    'Molluscs', 'Mustard', 'Pork', 'Beef', 'Chicken',
    'Garlic', 'Onion', 'Tomato', 'Strawberry', 'Kiwi',
    'Banana', 'Avocado', 'Mango', 'Peach', 'Apple',
    'Orange', 'Lemon', 'Lime', 'Grapefruit', 'Pineapple',
    'Coconut', 'Almond', 'Cashew', 'Walnut', 'Pistachio',
    'Hazelnut', 'Pecan', 'Macadamia', 'Brazil Nut', 'Pine Nut',
    'Chocolate', 'Coffee', 'Caffeine', 'Alcohol', 'Honey',
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedAllergies();
  }

  Future<void> _loadSelectedAllergies() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('user_allergies') ?? [];
    setState(() => selectedAllergies = saved.toSet());
  }

  Future<void> _toggleAllergy(String allergy) async {
    setState(() {
      if (selectedAllergies.contains(allergy)) {
        selectedAllergies.remove(allergy);
      } else {
        selectedAllergies.add(allergy);
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user_allergies', selectedAllergies.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Allergies'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showAddAllergyDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: allAllergies.length,
          itemBuilder: (context, index) {
            final allergy = allAllergies[index];
            final isSelected = selectedAllergies.contains(allergy);
            return GestureDetector(
              onTap: () => _toggleAllergy(allergy),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : const Color(0xFFFFE4CC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.orange : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        allergy,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.check, color: Colors.white, size: 14),
                    ],
                  ],
                ),
              ),
            );
          },
          ),
        ),
      ),
    );
  }

  void _showAddAllergyDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Allergy'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Allergy Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  allAllergies.add(controller.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
