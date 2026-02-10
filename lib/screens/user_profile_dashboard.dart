import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'select_allergies_screen.dart';
import 'select_foods_screen.dart';

class UserProfileDashboard extends StatefulWidget {
  final Map<String, dynamic>? memberData;
  
  const UserProfileDashboard({super.key, this.memberData});

  @override
  State<UserProfileDashboard> createState() => _UserProfileDashboardState();
}

class _UserProfileDashboardState extends State<UserProfileDashboard> {
  List<String> allergies = [];
  List<String> favoriteFoods = [];

  final List<Map<String, String>> allFoodsData = [
    {'name': 'Mac N Cheeze', 'restaurant': 'McDonalds', 'calories': '295', 'image': 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=100'},
    {'name': 'Pizza With Extra Cheese', 'restaurant': 'Papa Johns Pizza', 'calories': '895', 'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=100'},
    {'name': 'Mexican Bowl', 'restaurant': 'Chipotle', 'calories': '650', 'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=100'},
    {'name': 'Chicken Burger', 'restaurant': 'Burger King', 'calories': '540', 'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=100'},
    {'name': 'Caesar Salad', 'restaurant': 'Panera Bread', 'calories': '320', 'image': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=100'},
    {'name': 'Sushi Roll', 'restaurant': 'Sushi Bar', 'calories': '280', 'image': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=100'},
    {'name': 'Chicken Wings', 'restaurant': 'Buffalo Wild Wings', 'calories': '720', 'image': 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=100'},
    {'name': 'Tacos', 'restaurant': 'Taco Bell', 'calories': '380', 'image': 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=100'},
    {'name': 'Pasta Carbonara', 'restaurant': 'Olive Garden', 'calories': '850', 'image': 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=100'},
    {'name': 'Fried Chicken', 'restaurant': 'KFC', 'calories': '620', 'image': 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=100'},
    {'name': 'Beef Burrito', 'restaurant': 'Chipotle', 'calories': '780', 'image': 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=100'},
    {'name': 'Pad Thai', 'restaurant': 'Thai Express', 'calories': '520', 'image': 'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=100'},
    {'name': 'Ramen Bowl', 'restaurant': 'Ramen House', 'calories': '680', 'image': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=100'},
    {'name': 'Fish and Chips', 'restaurant': 'Long John Silvers', 'calories': '920', 'image': 'https://images.unsplash.com/photo-1579208575657-c595a05383b7?w=100'},
    {'name': 'Veggie Wrap', 'restaurant': 'Subway', 'calories': '290', 'image': 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=100'},
    {'name': 'BBQ Ribs', 'restaurant': 'Texas Roadhouse', 'calories': '1050', 'image': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=100'},
    {'name': 'Pho Soup', 'restaurant': 'Pho Restaurant', 'calories': '450', 'image': 'https://images.unsplash.com/photo-1591814468924-caf88d1232e1?w=100'},
    {'name': 'Grilled Salmon', 'restaurant': 'Red Lobster', 'calories': '420', 'image': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=100'},
    {'name': 'Chicken Quesadilla', 'restaurant': 'Taco Bell', 'calories': '510', 'image': 'https://images.unsplash.com/photo-1618040996337-56904b7850b9?w=100'},
    {'name': 'Steak Fajitas', 'restaurant': 'Chilis', 'calories': '740', 'image': 'https://images.unsplash.com/photo-1599974579688-8dbdd335c77f?w=100'},
    {'name': 'Chicken Tikka Masala', 'restaurant': 'Indian Palace', 'calories': '620', 'image': 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=100'},
    {'name': 'Lobster Roll', 'restaurant': 'Seafood Shack', 'calories': '480', 'image': 'https://images.unsplash.com/photo-1619895092538-128341789043?w=100'},
    {'name': 'Chicken Parmesan', 'restaurant': 'Olive Garden', 'calories': '890', 'image': 'https://images.unsplash.com/photo-1632778149955-e80f8ceca2e8?w=100'},
    {'name': 'Pulled Pork Sandwich', 'restaurant': 'BBQ Joint', 'calories': '670', 'image': 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=100'},
    {'name': 'Shrimp Scampi', 'restaurant': 'Red Lobster', 'calories': '560', 'image': 'https://images.unsplash.com/photo-1633504581786-316c8002b1b9?w=100'},
    {'name': 'Beef Tacos', 'restaurant': 'Taco Bell', 'calories': '340', 'image': 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=100'},
    {'name': 'Chicken Fried Rice', 'restaurant': 'Panda Express', 'calories': '520', 'image': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=100'},
    {'name': 'Margherita Pizza', 'restaurant': 'Pizza Hut', 'calories': '720', 'image': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=100'},
    {'name': 'Chicken Sandwich', 'restaurant': 'Chick-fil-A', 'calories': '440', 'image': 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=100'},
    {'name': 'Beef Stir Fry', 'restaurant': 'Panda Express', 'calories': '580', 'image': 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143?w=100'},
    {'name': 'Clam Chowder', 'restaurant': 'Red Lobster', 'calories': '380', 'image': 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=100'},
    {'name': 'Chicken Nachos', 'restaurant': 'Taco Bell', 'calories': '820', 'image': 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=100'},
    {'name': 'Teriyaki Chicken', 'restaurant': 'Panda Express', 'calories': '490', 'image': 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=100'},
    {'name': 'Meatball Sub', 'restaurant': 'Subway', 'calories': '680', 'image': 'https://images.unsplash.com/photo-1607532941433-304659e8198a?w=100'},
    {'name': 'Chicken Caesar Wrap', 'restaurant': 'Panera Bread', 'calories': '520', 'image': 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=100'},
    {'name': 'Beef Enchiladas', 'restaurant': 'Chilis', 'calories': '760', 'image': 'https://images.unsplash.com/photo-1599974579688-8dbdd335c77f?w=100'},
    {'name': 'Shrimp Tacos', 'restaurant': 'Taco Bell', 'calories': '420', 'image': 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=100'},
    {'name': 'Chicken Alfredo', 'restaurant': 'Olive Garden', 'calories': '920', 'image': 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=100'},
    {'name': 'Veggie Pizza', 'restaurant': 'Pizza Hut', 'calories': '640', 'image': 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=100'},
    {'name': 'Chicken Tenders', 'restaurant': 'Raising Canes', 'calories': '580', 'image': 'https://images.unsplash.com/photo-1562967914-608f82629710?w=100'},
    {'name': 'Beef Pho', 'restaurant': 'Pho Restaurant', 'calories': '520', 'image': 'https://images.unsplash.com/photo-1591814468924-caf88d1232e1?w=100'},
    {'name': 'Chicken Burrito Bowl', 'restaurant': 'Chipotle', 'calories': '620', 'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=100'},
    {'name': 'Pepperoni Pizza', 'restaurant': 'Dominos', 'calories': '780', 'image': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=100'},
    {'name': 'Chicken Shawarma', 'restaurant': 'Mediterranean Grill', 'calories': '540', 'image': 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=100'},
    {'name': 'Beef Burger', 'restaurant': 'Five Guys', 'calories': '840', 'image': 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=100'},
    {'name': 'Chicken Gyro', 'restaurant': 'Greek Restaurant', 'calories': '480', 'image': 'https://images.unsplash.com/photo-1621852004158-f3bc188ace2d?w=100'},
    {'name': 'Shrimp Fried Rice', 'restaurant': 'Panda Express', 'calories': '560', 'image': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=100'},
    {'name': 'Chicken Fajitas', 'restaurant': 'Chilis', 'calories': '680', 'image': 'https://images.unsplash.com/photo-1599974579688-8dbdd335c77f?w=100'},
    {'name': 'Beef Tacos Supreme', 'restaurant': 'Taco Bell', 'calories': '420', 'image': 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=100'},
    {'name': 'Chicken Pad Thai', 'restaurant': 'Thai Express', 'calories': '580', 'image': 'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=100'},
    {'name': 'Veggie Burger', 'restaurant': 'Burger King', 'calories': '390', 'image': 'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=100'},
    {'name': 'Chicken Ramen', 'restaurant': 'Ramen House', 'calories': '720', 'image': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=100'},
    {'name': 'Beef Kebab', 'restaurant': 'Mediterranean Grill', 'calories': '620', 'image': 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143?w=100'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomFoods();
    _loadData();
  }

  Future<void> _loadCustomFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final String? customFoodsJson = prefs.getString('custom_foods');
    if (customFoodsJson != null) {
      final List<dynamic> customFoods = json.decode(customFoodsJson);
      for (var food in customFoods) {
        if (!allFoodsData.any((f) => f['name'] == food['name'])) {
          allFoodsData.add(Map<String, String>.from(food));
        }
      }
    }
  }

  Future<void> _loadData() async {
    if (widget.memberData != null) {
      // Reload fresh data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? membersJson = prefs.getString('all_members');
      if (membersJson != null) {
        final List<dynamic> members = json.decode(membersJson);
        final member = members.firstWhere(
          (m) => m['name'] == widget.memberData!['name'],
          orElse: () => widget.memberData,
        );
        
        setState(() {
          // Handle allergies
          if (member['allergies'] != null) {
            if (member['allergies'] is List) {
              allergies = List<String>.from(member['allergies']);
            } else if (member['allergies'] is String) {
              final allergyStr = member['allergies'] as String;
              allergies = allergyStr.isNotEmpty ? allergyStr.split(',').map((e) => e.trim()).toList() : [];
            }
          }
          
          // Handle favorite foods (likes)
          if (member['likes'] != null) {
            if (member['likes'] is List) {
              favoriteFoods = List<String>.from(member['likes']);
            } else if (member['likes'] is String) {
              final likesStr = member['likes'] as String;
              favoriteFoods = likesStr.isNotEmpty ? likesStr.split(',').map((e) => e.trim()).toList() : [];
            }
          }
        });
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        allergies = prefs.getStringList('user_allergies') ?? [];
        favoriteFoods = prefs.getStringList('favorite_foods') ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectFoodsScreen(
                initialFoods: favoriteFoods,
                availableFoods: allFoodsData,
              ),
            ),
          );
          if (result != null) {
            await _saveFoods(result as List<String>);
            _loadData();
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
        children: [
          // Header with profile image
          Container(
            height: 220,
            decoration: widget.memberData?['imagePath'] != null && File(widget.memberData!['imagePath']).existsSync()
                ? BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(widget.memberData!['imagePath'])),
                      fit: BoxFit.cover,
                    ),
                  )
                : BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.orange.withValues(alpha: 0.7)],
                    ),
                  ),
            child: Stack(
              children: [
                if (widget.memberData?['imagePath'] != null && File(widget.memberData!['imagePath']).existsSync())
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: 0.5), Colors.black.withValues(alpha: 0.7)],
                      ),
                    ),
                  ),
                if (widget.memberData?['imagePath'] == null || !File(widget.memberData!['imagePath']).existsSync())
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Text(
                        (widget.memberData?['name'] ?? 'D')[0].toUpperCase(),
                        style: const TextStyle(fontSize: 60, color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    widget.memberData?['name'] ?? 'Dale Hicks',
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Allergies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectAllergiesScreen(initialAllergies: allergies),
                            ),
                          );
                          if (result != null) {
                            await _saveAllergies(result as List<String>);
                            _loadData();
                          }
                        },
                        child: const Text('Add', style: TextStyle(color: Colors.orange)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: allergies.isEmpty
                        ? [const Text('No allergies added', style: TextStyle(color: Colors.grey))]
                        : allergies.map((allergy) => _buildAllergyChip(allergy)).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Favorite Food', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectFoodsScreen(
                                initialFoods: favoriteFoods,
                                availableFoods: allFoodsData,
                              ),
                            ),
                          );
                          if (result != null) {
                            await _saveFoods(result as List<String>);
                            _loadData();
                          }
                        },
                        child: const Text('Add', style: TextStyle(color: Colors.orange)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...(favoriteFoods.isEmpty
                      ? [const Text('No favorite foods added', style: TextStyle(color: Colors.grey))]
                      : favoriteFoods.map((foodName) {
                          final foodData = allFoodsData.firstWhere(
                            (f) => f['name'] == foodName,
                            orElse: () => {'name': foodName, 'restaurant': 'Custom', 'calories': '0', 'image': ''},
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildFoodItem(foodData['name']!, foodData['restaurant']!, foodData['calories']!, foodData['image']!),
                          );
                        }).toList()),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildAllergyChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4CC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildFoodItem(String name, String restaurant, String calories, String imageUrl) {
    final hasImage = imageUrl.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          hasImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                )
              : Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 24, color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(restaurant, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text('$calories Calories', style: const TextStyle(fontSize: 12, color: Colors.orange)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAllergies(List<String> newAllergies) async {
    if (widget.memberData != null) {
      final prefs = await SharedPreferences.getInstance();
      final String? membersJson = prefs.getString('all_members');
      if (membersJson != null) {
        final List<dynamic> members = json.decode(membersJson);
        for (int i = 0; i < members.length; i++) {
          if (members[i]['name'] == widget.memberData!['name']) {
            members[i]['allergies'] = newAllergies;
            break;
          }
        }
        await prefs.setString('all_members', json.encode(members));
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('user_allergies', newAllergies);
    }
  }

  Future<void> _saveFoods(List<String> newFoods) async {
    if (widget.memberData != null) {
      final prefs = await SharedPreferences.getInstance();
      final String? membersJson = prefs.getString('all_members');
      if (membersJson != null) {
        final List<dynamic> members = json.decode(membersJson);
        for (int i = 0; i < members.length; i++) {
          if (members[i]['name'] == widget.memberData!['name']) {
            members[i]['likes'] = newFoods;
            break;
          }
        }
        await prefs.setString('all_members', json.encode(members));
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_foods', newFoods);
    }
  }
}
