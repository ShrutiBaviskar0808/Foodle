import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'add_place_screen.dart';

class FavoritePlacesScreen extends StatefulWidget {
  const FavoritePlacesScreen({super.key});

  @override
  State<FavoritePlacesScreen> createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {
  List<Map<String, dynamic>> places = [];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    
    if (userId == null) {
      return;
    }
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.getFoodsEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'user_id': userId}),
      ).timeout(AppConfig.requestTimeout);
      
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          places = (data['foods'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading places: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Places'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.orange.withValues(alpha: 0.2),
                        backgroundImage: (place['image_path'] != null && place['image_path'].toString().isNotEmpty)
                            ? FileImage(File(place['image_path']))
                            : null,
                        child: (place['image_path'] == null || place['image_path'].toString().isEmpty)
                            ? const Icon(Icons.restaurant, color: Colors.orange)
                            : null,
                      ),
                      title: Text(place['store_name'] ?? 'Unknown'),
                      subtitle: Text(place['food_item'] ?? ''),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showEditDeleteDialog(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlace,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showEditDeleteDialog(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPlaceScreen(
          place: places[index],
          index: index,
        ),
      ),
    );
    if (result != null) {
      await _loadPlaces();
    }
  }



  void _addPlace() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPlaceScreen()),
    );
    if (result != null) {
      await _loadPlaces();
    }
  }


}