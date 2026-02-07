import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'all_allergies_screen.dart';
import 'all_favorite_foods_screen.dart';

class UserProfileDashboard extends StatefulWidget {
  const UserProfileDashboard({super.key});

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
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      allergies = prefs.getStringList('user_allergies') ?? [];
      favoriteFoods = prefs.getStringList('favorite_foods') ?? [];
    });
  }

  List<Map<String, String>> _getSelectedFoodsData() {
    return allFoodsData.where((food) => favoriteFoods.contains(food['name'])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
        children: [
          // Header with profile image
          Container(
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withValues(alpha: 0.3), Colors.transparent],
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
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                        ),
                        const Text('Foodle', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    'Dale Hicks',
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
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
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => const AllAllergiesScreen()));
                          _loadData();
                        },
                        child: const Text('View All', style: TextStyle(color: Colors.orange)),
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
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => const AllFavoriteFoodsScreen()));
                          _loadData();
                        },
                        child: const Text('View All', style: TextStyle(color: Colors.orange)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...(_getSelectedFoodsData().isEmpty
                      ? [const Text('No favorite foods added', style: TextStyle(color: Colors.grey))]
                      : _getSelectedFoodsData().map((food) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildFoodItem(food['name']!, food['restaurant']!, food['calories']!, food['image']!),
                          )).toList()),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
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
}
