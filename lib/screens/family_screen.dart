import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_member_screen.dart';

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
    final String? membersJson = prefs.getString('family_members');
    if (membersJson != null) {
      final List<dynamic> decoded = json.decode(membersJson);
      setState(() {
        // Filter to show only Family relation members
        familyMembers = decoded.map((item) {
          final member = Map<String, dynamic>.from(item);
          // Convert allergies list to List<String>
          if (member['allergies'] != null) {
            member['allergies'] = List<String>.from(member['allergies']);
          }
          return member;
        }).where((member) => member['relation'] == 'Family').toList();
      });
    }
  }

  Future<void> _saveFamilyMembers() async {
    final prefs = await SharedPreferences.getInstance();
    // Load all members first
    final String? allMembersJson = prefs.getString('all_members');
    List<Map<String, dynamic>> allMembers = [];
    if (allMembersJson != null) {
      final List<dynamic> decoded = json.decode(allMembersJson);
      allMembers = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    }
    // Update or add family members
    for (var familyMember in familyMembers) {
      final index = allMembers.indexWhere((m) => 
        m['name'] == familyMember['name'] && 
        m['email'] == familyMember['email']);
      if (index != -1) {
        allMembers[index] = familyMember;
      } else {
        allMembers.add(familyMember);
      }
    }
    // Save all members
    final String encoded = json.encode(allMembers);
    await prefs.setString('all_members', encoded);
    // Also save family members separately for quick access
    final String familyEncoded = json.encode(familyMembers);
    await prefs.setString('family_members', familyEncoded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: const EdgeInsets.all(20),
                itemCount: familyMembers.length,
                itemBuilder: (context, index) {
                  final member = familyMembers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.orange.withValues(alpha: 0.2),
                        backgroundImage: member['imagePath'] != null
                            ? FileImage(File(member['imagePath']))
                            : null,
                        child: member['imagePath'] == null
                            ? const Icon(Icons.person, color: Colors.orange)
                            : null,
                      ),
                      title: Text(member['name']),
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
        title: Text(member['name']),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (member['imagePath'] != null)
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(File(member['imagePath'])),
                  ),
                ),
              const SizedBox(height: 15),
              _buildDetailRow('Nickname', member['nickname'] ?? 'N/A'),
              _buildDetailRow('Date of Birth', member['dob'] ?? 'N/A'),
              _buildDetailRow('Age', '${member['age'] ?? 'N/A'} years'),
              _buildDetailRow('Relation', member['relation'] ?? 'N/A'),
              _buildDetailRow('Favorite Food', member['foodName'] ?? 'N/A'),
              const SizedBox(height: 10),
              const Text('Allergies:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              if (member['allergies'] != null && member['allergies'].isNotEmpty)
                Wrap(
                  spacing: 5,
                  children: (member['allergies'] as List<String>)
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
      setState(() {
        familyMembers[result['index']] = result['data'];
      });
      await _saveFamilyMembers();
    }
  }

  void _addMember() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMemberScreen()),
    );
    if (result != null) {
      setState(() {
        familyMembers.add(result['data']);
      });
      await _saveFamilyMembers();
    }
  }

  void _deleteMember(int index) {
    setState(() {
      familyMembers.removeAt(index);
    });
    _saveFamilyMembers();
  }
}