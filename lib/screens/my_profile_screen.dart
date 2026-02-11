import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String userName = '';
  String userEmail = '';
  int? userId;
  List<Map<String, dynamic>> favoriteFoods = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userEmail = prefs.getString('user_email') ?? '';
      userId = prefs.getInt('user_id');
    });
    await _loadFavoriteFoods();
  }

  Future<void> _loadFavoriteFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final String? customFoodsJson = prefs.getString('custom_foods');
    if (customFoodsJson != null) {
      final List<dynamic> decoded = json.decode(customFoodsJson);
      setState(() {
        favoriteFoods = decoded.map((f) => Map<String, dynamic>.from(f)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.orange, Colors.orange.withValues(alpha: 0.8)],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text('My Profile', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 40, color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(userName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(userEmail, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15),
                            _buildInfoRow(Icons.person, 'Name', userName),
                            const SizedBox(height: 10),
                            _buildInfoRow(Icons.email, 'Email', userEmail),
                            if (userId != null) const SizedBox(height: 10),
                            if (userId != null) _buildInfoRow(Icons.badge, 'User ID', userId.toString()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('My Favorite Foods', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    favoriteFoods.isEmpty
                        ? const Text('No favorite foods added yet', style: TextStyle(color: Colors.grey))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: favoriteFoods.length,
                            itemBuilder: (context, index) {
                              final food = favoriteFoods[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.orange.withValues(alpha: 0.2),
                                    child: const Icon(Icons.fastfood, color: Colors.orange),
                                  ),
                                  title: Text(food['name'] ?? 'Unknown'),
                                  subtitle: Text(food['restaurant'] ?? ''),
                                  trailing: Text('${food['calories']} cal', style: const TextStyle(color: Colors.orange)),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
