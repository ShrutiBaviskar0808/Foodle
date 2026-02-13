import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'add_member_screen.dart';
import '../config.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  List<Map<String, dynamic>> familyMembers = [];

  @override
  void initState() {
    super.initState();
    _loadFamilyMembers();
  }

  Future<void> _loadFamilyMembers() async {
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
            familyMembers = (data['members'] as List? ?? [])
                .map((item) => Map<String, dynamic>.from(item))
                .where((member) => (member['relation'] ?? 'Family') == 'Family')
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Loading family members locally');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Foodles'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(padding),
                itemCount: familyMembers.length,
                itemBuilder: (context, index) {
                  final member = familyMembers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.orange.withValues(alpha: 0.2),
                        backgroundImage: member['image_path'] != null
                            ? FileImage(File(member['image_path']))
                            : null,
                        child: member['image_path'] == null
                            ? const Icon(Icons.person, color: Colors.orange)
                            : null,
                      ),
                      title: Text(member['display_name'] ?? ''),
                      subtitle: Text(
                        '${member['relation'] ?? 'Unknown'} • Age: ${member['age'] ?? 'N/A'}',
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
        onPressed: _addMember,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showMemberDetails(int index) async {
    final member = familyMembers[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member['display_name'] ?? ''),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (member['image_path'] != null)
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(File(member['image_path'])),
                  ),
                ),
              const SizedBox(height: 15),
              _buildDetailRow('Relation', member['relation'] ?? 'N/A'),
              const SizedBox(height: 10),
              const Text('Allergies:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text('Loading...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editMember(index);
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
              _deleteMember(index);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editMember(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemberScreen(
          member: familyMembers[index],
          index: index,
        ),
      ),
    );
    if (result != null) {
      await _loadFamilyMembers();
    }
  }

  void _addMember() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMemberScreen()),
    );
    if (result != null) {
      await _loadFamilyMembers();
    }
  }

  void _deleteMember(int index) async {
    final member = familyMembers[index];
    final memberId = member['id'];
    
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
          await _loadFamilyMembers();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Member deleted successfully')),
            );
          }
          return;
        }
      }
      await _loadFamilyMembers();
    } catch (e) {
      await _loadFamilyMembers();
    }
  }
}