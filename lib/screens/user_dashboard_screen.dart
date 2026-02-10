import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'add_member_screen.dart';
import 'add_place_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  String userName = '';
  String userEmail = '';
  List<Map<String, dynamic>> familyMembers = [];
  List<Map<String, dynamic>> places = [];
  List<Map<String, dynamic>> friends = [];

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
    });
    
    await Future.wait([
      _loadFamilyMembers(),
      _loadPlaces(),
      _loadFriends(),
    ]);
  }

  Future<void> _loadFamilyMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? membersJson = prefs.getString('all_members');
    if (membersJson != null) {
      final List<dynamic> decoded = json.decode(membersJson);
      setState(() {
        familyMembers = decoded
            .map((item) => Map<String, dynamic>.from(item))
            .where((member) => member['relation'] == 'Family')
            .toList();
      });
    }
  }

  Future<void> _loadPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return;
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.getFoodsEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'user_id': userId}),
      ).timeout(AppConfig.requestTimeout);
      
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          places = (data['foods'] as List)
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading places: $e');
    }
  }

  Future<void> _loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final String? membersJson = prefs.getString('all_members');
    if (membersJson != null) {
      final List<dynamic> decoded = json.decode(membersJson);
      setState(() {
        friends = decoded
            .map((item) => Map<String, dynamic>.from(item))
            .where((member) => member['relation'] != 'Family')
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    _buildStatCard('Family Members', familyMembers.length, Icons.family_restroom, Colors.orange),
                    const SizedBox(height: 15),
                    _buildStatCard('Favorite Places', places.length, Icons.restaurant, Colors.green),
                    const SizedBox(height: 15),
                    _buildStatCard('Friends', friends.length, Icons.people, Colors.blue),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Family Members', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        TextButton.icon(
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMemberScreen()));
                            _loadUserData();
                          },
                          icon: const Icon(Icons.add, color: Colors.orange),
                          label: const Text('Add', style: TextStyle(color: Colors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    familyMembers.isEmpty
                        ? const Text('No family members added yet', style: TextStyle(color: Colors.grey))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: familyMembers.length,
                            itemBuilder: (context, index) {
                              final member = familyMembers[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.orange.withValues(alpha: 0.2),
                                    backgroundImage: member['imagePath'] != null ? FileImage(File(member['imagePath'])) : null,
                                    child: member['imagePath'] == null ? const Icon(Icons.person, color: Colors.orange) : null,
                                  ),
                                  title: Text(member['name']),
                                  subtitle: Text(member['relation'] ?? 'Family'),
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Favorite Places', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        TextButton.icon(
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPlaceScreen()));
                            _loadUserData();
                          },
                          icon: const Icon(Icons.add, color: Colors.orange),
                          label: const Text('Add', style: TextStyle(color: Colors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    places.isEmpty
                        ? const Text('No favorite places added yet', style: TextStyle(color: Colors.grey))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: places.length,
                            itemBuilder: (context, index) {
                              final place = places[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(Icons.restaurant, color: Colors.white),
                                  ),
                                  title: Text(place['store_name'] ?? 'Unknown'),
                                  subtitle: Text(place['food_item'] ?? ''),
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Friends', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        TextButton.icon(
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMemberScreen()));
                            _loadUserData();
                          },
                          icon: const Icon(Icons.add, color: Colors.orange),
                          label: const Text('Add', style: TextStyle(color: Colors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    friends.isEmpty
                        ? const Text('No friends added yet', style: TextStyle(color: Colors.grey))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: friends.length,
                            itemBuilder: (context, index) {
                              final friend = friends[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.withValues(alpha: 0.2),
                                    backgroundImage: friend['imagePath'] != null ? FileImage(File(friend['imagePath'])) : null,
                                    child: friend['imagePath'] == null ? const Icon(Icons.person, color: Colors.blue) : null,
                                  ),
                                  title: Text(friend['name']),
                                  subtitle: Text(friend['relation'] ?? 'Friend'),
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

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 5),
              Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ],
      ),
    );
  }
}
