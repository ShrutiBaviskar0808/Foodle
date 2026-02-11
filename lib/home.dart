import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'screens/family_screen.dart';
import 'screens/favorite_places_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/user_dashboard_screen.dart';
import 'screens/user_profile_dashboard.dart';
import 'screens/add_member_screen.dart';
import 'screens/add_place_screen.dart';
import 'config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<Map<String, dynamic>> familyMembers = [];
  List<Map<String, dynamic>> places = [];
  List<Map<String, dynamic>> friends = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
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
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;
    
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.orange.withValues(alpha: 0.8)],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Foodle', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Every Plate, Perfectly Planned', style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.orange),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserDashboardScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.family_restroom, color: Colors.orange),
              title: const Text('Family'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FamilyScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.place, color: Colors.orange),
              title: const Text('Favorite Places'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePlacesScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.orange),
              title: const Text('Friends'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendsScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () async {
                if (!mounted) return;
                final navigator = Navigator.of(context);
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                navigator.pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
        Container(
          height: size.height * 0.25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.orange, Colors.orange.withValues(alpha: 0.8)],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800'),
                      fit: BoxFit.cover,
                      opacity: 0.3,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const Text('Foodle', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserDashboardScreen()));
                          },
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: FutureBuilder<String>(
                              future: SharedPreferences.getInstance().then((prefs) => prefs.getString('user_name') ?? 'U'),
                              builder: (context, snapshot) {
                                final initial = snapshot.data?.isNotEmpty == true ? snapshot.data![0].toUpperCase() : 'U';
                                return Text(
                                  initial,
                                  style: const TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text('Every Plate,', style: TextStyle(color: Colors.white, fontSize: size.width * 0.09, fontWeight: FontWeight.bold)),
                        Text('Perfectly Planned', style: TextStyle(color: Colors.white, fontSize: size.width * 0.09, fontWeight: FontWeight.bold)),
                        SizedBox(height: size.height * 0.025),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Family', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMemberScreen()));
                        if (result != null) {
                          final prefs = await SharedPreferences.getInstance();
                          final String? membersJson = prefs.getString('all_members');
                          List<Map<String, dynamic>> allMembers = [];
                          if (membersJson != null) {
                            allMembers = (json.decode(membersJson) as List).map((e) => Map<String, dynamic>.from(e)).toList();
                          }
                          allMembers.add(result['data']);
                          await prefs.setString('all_members', json.encode(allMembers));
                          _loadData();
                        }
                      },
                      icon: const Icon(Icons.add, color: Colors.orange, size: 20),
                      label: const Text('Add', style: TextStyle(color: Colors.orange)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                familyMembers.isEmpty
                    ? const Center(child: Text('No family members added yet', style: TextStyle(color: Colors.grey)))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: familyMembers.map((member) => Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileDashboard(memberData: member))),
                              child: _buildFamilyMember(member['name'], member['imagePath']),
                            ),
                          )).toList(),
                        ),
                      ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Favorite Places', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPlaceScreen()));
                        _loadData();
                      },
                      icon: const Icon(Icons.add, color: Colors.orange, size: 20),
                      label: const Text('Add', style: TextStyle(color: Colors.orange)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 120,
                  child: places.isEmpty
                      ? const Center(child: Text('No favorite places added yet', style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            final colors = [Colors.green, Colors.blue, Colors.orange, Colors.brown, Colors.purple];
                            return _buildRestaurant(places[index]['store_name'], colors[index % colors.length]);
                          },
                        ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Friends', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMemberScreen()));
                        if (result != null) {
                          final prefs = await SharedPreferences.getInstance();
                          final String? membersJson = prefs.getString('all_members');
                          List<Map<String, dynamic>> allMembers = [];
                          if (membersJson != null) {
                            allMembers = (json.decode(membersJson) as List).map((e) => Map<String, dynamic>.from(e)).toList();
                          }
                          allMembers.add(result['data']);
                          await prefs.setString('all_members', json.encode(allMembers));
                          _loadData();
                        }
                      },
                      icon: const Icon(Icons.add, color: Colors.orange, size: 20),
                      label: const Text('Add', style: TextStyle(color: Colors.orange)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                friends.isEmpty
                    ? const Center(child: Text('No friends added yet', style: TextStyle(color: Colors.grey)))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: friends.map((friend) => Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileDashboard(memberData: friend))),
                              child: _buildFriend(friend['name'], friend['imagePath']),
                            ),
                          )).toList(),
                        ),
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

  Widget _buildFamilyMember(String name, String? imagePath) {
    final imageExists = imagePath != null && File(imagePath).existsSync();
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.orange.withValues(alpha: 0.2),
          backgroundImage: imageExists ? FileImage(File(imagePath)) : null,
          child: !imageExists ? Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 24, color: Colors.orange, fontWeight: FontWeight.bold),
          ) : null,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          child: Text(
            name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurant(String name, Color color) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, color: color, size: 20),
          const SizedBox(height: 8),
          Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildFriend(String name, String? imagePath) {
    final imageExists = imagePath != null && File(imagePath).existsSync();
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[200],
          backgroundImage: imageExists ? FileImage(File(imagePath)) : null,
          child: !imageExists ? Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold),
          ) : null,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          child: Text(
            name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}