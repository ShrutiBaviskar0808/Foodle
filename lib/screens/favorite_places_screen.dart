import 'package:flutter/material.dart';
import 'dart:io';
import 'add_place_screen.dart';

class FavoritePlacesScreen extends StatefulWidget {
  const FavoritePlacesScreen({super.key});

  @override
  State<FavoritePlacesScreen> createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {
  List<Map<String, dynamic>> places = [
    {'name': 'Costas Inn', 'color': Colors.green, 'cuisine': 'Seafood'},
    {'name': "Angie's", 'color': Colors.blue, 'cuisine': 'American'},
    {'name': "Koco's Pub", 'color': Colors.yellow[700], 'cuisine': 'Bar & Grill'},
    {'name': 'BK Lobster', 'color': Colors.brown, 'cuisine': 'Seafood'},
    {'name': 'Oyster', 'color': Colors.orange, 'cuisine': 'Seafood'},
  ];

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
    }
  }


}