import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<Map<String, dynamic>> friends = [
    {'name': 'Sunil', 'preferences': 'Spicy food lover'},
    {'name': 'Brett C', 'preferences': 'Vegan diet'},
    {'name': 'Joe D', 'preferences': 'No nuts allergy'},
    {'name': 'Austin', 'preferences': 'Loves BBQ'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Friends'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Text(
                          friend['name'][0].toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(friend['name']),
                      subtitle: Text(friend['preferences']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteFriend(index),
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
        onPressed: _addFriend,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addFriend() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String preferences = '';
        return AlertDialog(
          title: const Text('Add Friend'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Friend Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Food Preferences'),
                onChanged: (value) => preferences = value,
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
                    friends.add({
                      'name': name,
                      'preferences': preferences.isEmpty ? 'No preferences set' : preferences,
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

  void _deleteFriend(int index) {
    setState(() {
      friends.removeAt(index);
    });
  }
}