import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
    final TextEditingController searchController = TextEditingController();
    final Set<String> tempSelected = Set.from(selectedAllergies);
    String searchQuery = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final filteredAllergies = searchQuery.isEmpty
              ? allAllergies
              : allAllergies.where((a) => a.toLowerCase().contains(searchQuery.toLowerCase())).toList();
          
          return AlertDialog(
            title: const Text('Select Allergies'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  if (tempSelected.isNotEmpty)
                    Container(
                      constraints: const BoxConstraints(maxHeight: 100),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tempSelected.map((allergy) {
                            return Chip(
                              label: Text(allergy),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setDialogState(() {
                                  tempSelected.remove(allergy);
                                });
                              },
                              backgroundColor: Colors.orange.withValues(alpha: 0.2),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search or add new allergy',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty && !allAllergies.any((a) => a.toLowerCase() == searchQuery.toLowerCase())
                          ? IconButton(
                              icon: const Icon(Icons.add_circle, color: Colors.orange),
                              onPressed: () {
                                if (searchQuery.isNotEmpty) {
                                  setDialogState(() {
                                    allAllergies.add(searchQuery);
                                    tempSelected.add(searchQuery);
                                    searchController.clear();
                                    searchQuery = '';
                                  });
                                }
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setDialogState(() {
                        searchQuery = value;
                      });
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty && !allAllergies.any((a) => a.toLowerCase() == value.toLowerCase())) {
                        setDialogState(() {
                          allAllergies.add(value);
                          tempSelected.add(value);
                          searchController.clear();
                          searchQuery = '';
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredAllergies.length,
                      itemBuilder: (context, index) {
                        final allergy = filteredAllergies[index];
                        final isSelected = tempSelected.contains(allergy);
                        return CheckboxListTile(
                          title: Text(allergy),
                          value: isSelected,
                          activeColor: Colors.orange,
                          onChanged: (bool? value) {
                            setDialogState(() {
                              if (value == true) {
                                tempSelected.add(allergy);
                              } else {
                                tempSelected.remove(allergy);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedAllergies = tempSelected;
                  });
                  _saveAllergies();
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
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
