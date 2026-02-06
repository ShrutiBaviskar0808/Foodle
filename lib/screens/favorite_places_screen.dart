import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
    final String? placesJson = prefs.getString('favorite_places');
    if (placesJson != null) {
      final List<dynamic> decoded = json.decode(placesJson);
      setState(() {
        places = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    }
  }

  Future<void> _savePlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(places);
    await prefs.setString('favorite_places', encoded);
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
                        backgroundImage: place['imagePath'] != null
                            ? FileImage(File(place['imagePath']))
                            : null,
                        child: place['imagePath'] == null
                            ? const Icon(Icons.restaurant, color: Colors.orange)
                            : null,
                      ),
                      title: Text(place['storeName'] ?? place['name'] ?? 'Unknown'),
                      subtitle: Text(place['foodItem'] ?? place['cuisine'] ?? ''),
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
      if (result['delete'] == true) {
        setState(() {
          places.removeAt(result['index']);
        });
      } else {
        setState(() {
          places[result['index']] = result['data'];
        });
      }
      await _savePlaces();
    }
  }



  void _addPlace() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPlaceScreen()),
    );
    if (result != null && result['data'] != null) {
      setState(() {
        places.add(result['data']);
      });
      await _savePlaces();
    }
  }


}