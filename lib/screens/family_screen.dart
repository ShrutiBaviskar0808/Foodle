import 'package:flutter/material.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  List<Map<String, dynamic>> familyMembers = [
    {'name': 'The Boss', 'icon': Icons.person, 'preferences': 'Loves Italian food'},
    {'name': 'My Love', 'icon': Icons.person, 'preferences': 'Vegetarian'},
    {'name': 'Kimberly', 'icon': Icons.person, 'preferences': 'No seafood'},
    {'name': 'Zoey', 'icon': Icons.child_care, 'preferences': 'Loves pizza'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Family'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: familyMembers.length,
                itemBuilder: (context, index) {
                  final member = familyMembers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.withValues(alpha: 0.2),
                        child: Icon(member['icon'], color: Colors.orange),
                      ),
                      title: Text(member['name']),
                      subtitle: Text(member['preferences']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMember(index),
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
        onPressed: _addMember,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addMember() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String preferences = '';
        return AlertDialog(
          title: const Text('Add Family Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
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
                    familyMembers.add({
                      'name': name,
                      'icon': Icons.person,
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

  void _deleteMember(int index) {
    setState(() {
      familyMembers.removeAt(index);
    });
  }
}