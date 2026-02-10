import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'select_allergies_screen.dart';

class AllAllergiesScreen extends StatefulWidget {
  final Map<String, dynamic>? memberData;
  final int? memberIndex;
  
  const AllAllergiesScreen({super.key, this.memberData, this.memberIndex});

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
    if (widget.memberData != null) {
      debugPrint('Loading allergies for member: ${widget.memberData!['name']}');
      // Reload from SharedPreferences to get latest data
      final prefs = await SharedPreferences.getInstance();
      final String? membersJson = prefs.getString('all_members');
      if (membersJson != null) {
        final List<dynamic> members = json.decode(membersJson);
        final member = members.firstWhere(
          (m) => m['name'] == widget.memberData!['name'],
          orElse: () => widget.memberData,
        );
        final memberAllergies = member['allergies'];
        debugPrint('Member allergies: $memberAllergies');
        if (memberAllergies is List) {
          setState(() => selectedAllergies = List<String>.from(memberAllergies).toSet());
        } else if (memberAllergies is String && memberAllergies.isNotEmpty) {
          setState(() => selectedAllergies = memberAllergies.split(',').map((e) => e.trim()).toSet());
        }
      }
    } else {
      // Load from SharedPreferences for logged-in user
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('user_allergies') ?? [];
      setState(() => selectedAllergies = saved.toSet());
    }
  }

  Future<void> _toggleAllergy(String allergy) async {
    setState(() {
      if (selectedAllergies.contains(allergy)) {
        selectedAllergies.remove(allergy);
      } else {
        selectedAllergies.add(allergy);
      }
    });
    await _saveAllergies();
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
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectAllergiesScreen(initialAllergies: selectedAllergies.toList()),
                ),
              );
              if (result != null) {
                setState(() {
                  selectedAllergies = (result as List<String>).toSet();
                });
                await _saveAllergies();
              }
            },
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

  Future<void> _saveAllergies() async {
    if (widget.memberData != null) {
      debugPrint('Saving allergies for member: ${widget.memberData!['name']}');
      debugPrint('Selected allergies: ${selectedAllergies.toList()}');
      final prefs = await SharedPreferences.getInstance();
      final String? membersJson = prefs.getString('all_members');
      if (membersJson != null) {
        final List<dynamic> members = json.decode(membersJson);
        for (int i = 0; i < members.length; i++) {
          if (members[i]['name'] == widget.memberData!['name']) {
            members[i]['allergies'] = selectedAllergies.toList();
            debugPrint('Updated member at index $i');
            break;
          }
        }
        await prefs.setString('all_members', json.encode(members));
        debugPrint('Saved to SharedPreferences');
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('user_allergies', selectedAllergies.toList());
    }
  }
}
