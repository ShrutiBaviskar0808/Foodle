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
    await Future.wait([_loadFamilyMembers(), _loadFriends(), _loadPlaces()]);
  }

  Future<void> _loadFamilyMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return;

    try {
      final response = await http.post(
        Uri.parse(AppConfig.getMembersEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'owner_user_id': userId}),
      ).timeout(AppConfig.requestTimeout);

      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          familyMembers = (data['members'] as List)
              .map((item) => Map<String, dynamic>.from(item))
              .where((member) => member['relation'] == 'Family')
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading family members: $e');
    }
  }

  Future<void> _loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return;

    try {
      final response = await http.post(
        Uri.parse(AppConfig.getMembersEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'owner_user_id': userId}),
      ).timeout(AppConfig.requestTimeout);

      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          friends = (data['members'] as List)
              .map((item) => Map<String, dynamic>.from(item))
              .where((member) => member['relation'] != 'Family')
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading friends: $e');
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
        body: json.encode({'member_id': userId}),
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
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFFE8D00),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 280,
                decoration: const BoxDecoration(
                  color: Color(0xFFFE8D00),
                ),
              ),
              Container(
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFFE8D00),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          Text(
                            'Foodle',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.08,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Text(
                              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                color: Color(0xFFFE8D00),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                    CircleAvatar(
                      radius: size.width * 0.13,
                      backgroundColor: Colors.white,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: TextStyle(
                          fontSize: size.width * 0.12,
                          color: const Color(0xFFFE8D00),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    Text(
                      userEmail,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: size.width * 0.035,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
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
                                    backgroundImage: member['image_path'] != null ? FileImage(File(member['image_path'])) : null,
                                    child: member['image_path'] == null ? const Icon(Icons.person, color: Colors.orange) : null,
                                  ),
                                  title: Text(member['display_name'] ?? ''),
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
                                    backgroundImage: friend['image_path'] != null ? FileImage(File(friend['image_path'])) : null,
                                    child: friend['image_path'] == null ? const Icon(Icons.person, color: Colors.blue) : null,
                                  ),
                                  title: Text(friend['display_name'] ?? ''),
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
                                  title: Text(place['food_name'] ?? 'Unknown'),
                                  subtitle: Text(place['food_item'] ?? ''),
                                ),
                              );
                            },
                          ),
                  ],
                ),
                ),
              ),
            ),
          ),
        ],
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
