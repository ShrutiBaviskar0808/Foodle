import 'package:flutter/material.dart';

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
                        backgroundColor: place['color'].withValues(alpha: 0.2),
                        child: Icon(Icons.restaurant, color: place['color']),
                      ),
                      title: Text(place['name']),
                      subtitle: Text(place['cuisine']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletePlace(index),
                      ),
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

  void _addPlace() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String cuisine = '';
        return AlertDialog(
          title: const Text('Add Favorite Place'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Restaurant Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Cuisine Type'),
                onChanged: (value) => cuisine = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  setState(() {
                    places.add({
                      'name': name,
                      'color': Colors.orange,
                      'cuisine': cuisine.isEmpty ? 'Restaurant' : cuisine,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deletePlace(int index) {
    setState(() {
      places.removeAt(index);
    });
  }
}