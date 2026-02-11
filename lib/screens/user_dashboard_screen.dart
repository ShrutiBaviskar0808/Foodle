import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'family_screen.dart';
import 'friends_screen.dart';
import 'favorite_places_screen.dart';
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
  int? userId;
  List<Map<String, dynamic>> familyMembers = [];
  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> places = [];

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
    await Future.wait([
      _loadFamilyMembers(),
      _loadFriends(),
      _loadPlaces(),
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(padding),
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
                      const Text('User Details', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
                        onSelected: (value) {
                          if (value == 'family') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FamilyScreen()));
                          } else if (value == 'friends') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendsScreen()));
                          } else if (value == 'places') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePlacesScreen()));
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'family',
                            child: Row(
                              children: [
                                Icon(Icons.family_restroom, color: Colors.orange),
                                SizedBox(width: 12),
                                Text('Family Members'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'friends',
                            child: Row(
                              children: [
                                Icon(Icons.people, color: Colors.orange),
                                SizedBox(width: 12),
                                Text('Friends'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'places',
                            child: Row(
                              children: [
                                Icon(Icons.restaurant, color: Colors.orange),
                                SizedBox(width: 12),
                                Text('Favorite Places'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: size.width * 0.12,
                    backgroundColor: Colors.white,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 40, color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(userName, style: TextStyle(color: Colors.white, fontSize: size.width * 0.06, fontWeight: FontWeight.bold)),
                  SizedBox(height: size.height * 0.006),
                  Text(userEmail, style: TextStyle(color: Colors.white70, fontSize: size.width * 0.035)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
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
