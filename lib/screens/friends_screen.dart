import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'add_member_screen.dart';
import '../config.dart';

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
    final userId = prefs.getInt('user_id');
    if (userId == null) return;
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.getMembersEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'owner_user_id': userId}),
      ).timeout(AppConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            friends = (data['members'] as List? ?? [])
                .map((item) => Map<String, dynamic>.from(item))
                .where((member) => (member['relation'] ?? 'Family') != 'Family')
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Loading friends locally');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Circle'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(padding),
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.orange.withValues(alpha: 0.2),
                        backgroundImage: friend['image_path'] != null
                            ? FileImage(File(friend['image_path']))
                            : null,
                        child: friend['image_path'] == null
                            ? const Icon(Icons.person, color: Colors.orange)
                            : null,
                      ),
                      title: Text(friend['display_name'] ?? ''),
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
        title: Text(friend['display_name'] ?? ''),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (friend['image_path'] != null)
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(File(friend['image_path'])),
                  ),
                ),
              const SizedBox(height: 15),
              _buildDetailRow('Relation', friend['relation'] ?? 'N/A'),
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
      await _loadFriends();
    }
  }

  void _addFriend() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMemberScreen()),
    );
    if (result != null) {
      await _loadFriends();
    }
  }

  void _deleteFriend(int index) async {
    final friend = friends[index];
    final memberId = friend['id'];
    
    if (memberId == null) return;
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.deleteMemberEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'member_id': memberId}),
      ).timeout(AppConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          await _loadFriends();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Member deleted successfully')),
            );
          }
          return;
        }
      }
      await _loadFriends();
    } catch (e) {
      await _loadFriends();
    }
  }
}