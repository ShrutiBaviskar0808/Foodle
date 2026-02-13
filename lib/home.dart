import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
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
    final userId = prefs.getInt('user_id');
    debugPrint('Loading family members for user_id: $userId');
    if (userId == null) return;
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.getMembersEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'owner_user_id': userId}),
      ).timeout(AppConfig.requestTimeout);
      
      debugPrint('Family response: ${response.body}');
      final data = json.decode(response.body);
      if (data['success']) {
        final allMembers = (data['members'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
        debugPrint('All members: $allMembers');
        setState(() {
          familyMembers = allMembers.where((member) => member['relation'] == 'Family').toList();
        });
        debugPrint('Family members filtered: $familyMembers');
      }
    } catch (e) {
      debugPrint('Error loading family members: $e');
    }
  }

  Future<void> _loadPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    debugPrint('Loading places for user_id: $userId');
    if (userId == null) return;
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.getFoodsEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'member_id': userId}),
      ).timeout(AppConfig.requestTimeout);
      
      debugPrint('Places response: ${response.body}');
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          places = (data['foods'] as List)
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        });
        debugPrint('Places loaded: $places');
      } else {
        debugPrint('Places load failed: ${data['message']}');
      }
    } catch (e) {
      debugPrint('Error loading places: $e');
    }
  }

  Future<void> _loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    debugPrint('Loading friends for user_id: $userId');
    if (userId == null) return;
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.getMembersEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'owner_user_id': userId}),
      ).timeout(AppConfig.requestTimeout);
      
      debugPrint('Friends response: ${response.body}');
      final data = json.decode(response.body);
      if (data['success']) {
        final allMembers = (data['members'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
        setState(() {
          friends = allMembers.where((member) => member['relation'] != 'Family').toList();
        });
        debugPrint('Friends filtered: $friends');
      }
    } catch (e) {
      debugPrint('Error loading friends: $e');
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
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 280,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF2C2C2C),
                      Color(0xFF1A1A1A),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Stack(
                    children: [
                      Positioned(top: 100, left: 20, child: Icon(Icons.restaurant_menu, size: 40, color: Colors.black.withValues(alpha: 0.1))),
                      Positioned(top: 120, right: 30, child: Icon(Icons.local_pizza, size: 50, color: Colors.black.withValues(alpha: 0.08))),
                      Positioned(top: 150, left: 100, child: Icon(Icons.fastfood, size: 35, color: Colors.black.withValues(alpha: 0.1))),
                      Positioned(top: 180, right: 80, child: Icon(Icons.cake, size: 45, color: Colors.black.withValues(alpha: 0.08))),
                      Positioned(top: 140, left: 200, child: Icon(Icons.lunch_dining, size: 38, color: Colors.black.withValues(alpha: 0.1))),
                      Positioned(top: 200, left: 50, child: Icon(Icons.icecream, size: 42, color: Colors.black.withValues(alpha: 0.08))),
                    ],
                  ),
                ),
              ),
              Container(
                height: 280,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFFE8D00),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                          Text(
                            'Foodle',
                            style: GoogleFonts.pacifico(
                              color: Colors.white,
                              fontSize: 32,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserDashboardScreen(),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: FutureBuilder<String>(
                                  future: SharedPreferences.getInstance().then((prefs) => prefs.getString('user_name') ?? 'U'),
                                  builder: (context, snapshot) {
                                    final initial = snapshot.data?.isNotEmpty == true ? snapshot.data![0].toUpperCase() : 'U';
                                    return Text(
                                      initial,
                                      style: const TextStyle(
                                        color: Color(0xFFFE8D00),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Every Plate,',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            'Perfectly Planned',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Family', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
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
                              child: _buildFamilyMember(member['display_name'] ?? '', member['image_path']),
                            ),
                          )).toList(),
                        ),
                      ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Favorite Places', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
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
                            return _buildRestaurant(places[index]['food_name'] ?? '', colors[index % colors.length]);
                          },
                        ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Friends', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
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
                              child: _buildFriend(friend['display_name'] ?? '', friend['image_path']),
                            ),
                          )).toList(),
                        ),
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