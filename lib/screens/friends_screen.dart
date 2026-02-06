import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_member_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<Map<String, dynamic>> friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final String? membersJson = prefs.getString('all_members');
    if (membersJson != null) {
      final List<dynamic> decoded = json.decode(membersJson);
      setState(() {
        // Filter to show only non-Family relation members
        friends = decoded.map((item) {
          final member = Map<String, dynamic>.from(item);
          if (member['allergies'] != null) {
            member['allergies'] = List<String>.from(member['allergies']);
          }
          return member;
        }).where((member) => member['relation'] != 'Family').toList();
      });
    }
  }

  Future<void> _saveFriends() async {
    final prefs = await SharedPreferences.getInstance();
    // Load all members
    final String? allMembersJson = prefs.getString('all_members');
    List<Map<String, dynamic>> allMembers = [];
    if (allMembersJson != null) {
      final List<dynamic> decoded = json.decode(allMembersJson);
      allMembers = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    }
    // Update or add friends
    for (var friend in friends) {
      final index = allMembers.indexWhere((m) => 
        m['name'] == friend['name'] && 
        m['dob'] == friend['dob']);
      if (index != -1) {
        allMembers[index] = friend;
      } else {
        allMembers.add(friend);
      }
    }
    // Save all members
    final String encoded = json.encode(allMembers);
    await prefs.setString('all_members', encoded);
  }

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
                        radius: 30,
                        backgroundColor: Colors.orange.withValues(alpha: 0.2),
                        backgroundImage: friend['imagePath'] != null
                            ? FileImage(File(friend['imagePath']))
                            : null,
                        child: friend['imagePath'] == null
                            ? const Icon(Icons.person, color: Colors.orange)
                            : null,
                      ),
                      title: Text(friend['name']),
                      subtitle: Text(
                        '${friend['relation'] ?? 'Unknown'} • Age: ${friend['age'] ?? 'N/A'}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _showMemberDetails(index),
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

  void _showMemberDetails(int index) async {
    final friend = friends[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(friend['name']),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (friend['imagePath'] != null)
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(File(friend['imagePath'])),
                  ),
                ),
              const SizedBox(height: 15),
              _buildDetailRow('Nickname', friend['nickname'] ?? 'N/A'),
              _buildDetailRow('Date of Birth', friend['dob'] ?? 'N/A'),
              _buildDetailRow('Age', '${friend['age'] ?? 'N/A'} years'),
              _buildDetailRow('Relation', friend['relation'] ?? 'N/A'),
              _buildDetailRow('Favorite Food', friend['foodName'] ?? 'N/A'),
              const SizedBox(height: 10),
              const Text('Allergies:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              if (friend['allergies'] != null && friend['allergies'].isNotEmpty)
                Wrap(
                  spacing: 5,
                  children: (friend['allergies'] as List<String>)
                      .map((allergy) => Chip(
                            label: Text(allergy, style: const TextStyle(fontSize: 12)),
                            backgroundColor: Colors.orange.withValues(alpha: 0.2),
                          ))
                      .toList(),
                )
              else
                const Text('None', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editFriend(index);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDelete(index);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: const Text('Are you sure you want to delete this member?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFriend(index);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editFriend(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemberScreen(
          member: friends[index],
          index: index,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        friends[result['index']] = result['data'];
      });
      await _saveFriends();
      await _loadFriends();
    }
  }

  void _addFriend() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMemberScreen()),
    );
    if (result != null) {
      setState(() {
        friends.add(result['data']);
      });
      await _saveFriends();
      await _loadFriends();
    }
  }

  void _deleteFriend(int index) {
    setState(() {
      friends.removeAt(index);
    });
    _saveFriends();
  }
}