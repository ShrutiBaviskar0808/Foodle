import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import '../config.dart';

class AddMemberScreen extends StatefulWidget {
  final Map<String, dynamic>? member;
  final int? index;

  const AddMemberScreen({super.key, this.member, this.index});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _dobController = TextEditingController();
  final _customAllergyController = TextEditingController();
  
  String? _imagePath;
  String? _selectedRelation;
  int? _age;
  List<String> _selectedAllergies = [];
  
  final List<String> _relations = ['Family', 'Friends', 'Colleagues', 'Others'];
  final List<String> _commonAllergies = [
    'Peanuts',
    'Tree Nuts',
    'Milk',
    'Eggs',
    'Wheat',
    'Soy',
    'Fish',
    'Shellfish',
    'Sesame',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      _nameController.text = widget.member!['display_name'] ?? '';
      _nicknameController.text = widget.member!['nickname'] ?? '';
      _dobController.text = widget.member!['dob'] ?? '';
      _imagePath = widget.member!['image_path'];
      _selectedRelation = widget.member!['relation'];
      _age = widget.member!['age'];
      _selectedAllergies = List<String>.from(widget.member!['allergies'] ?? []);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _calculateAge(String dob) {
    if (dob.isEmpty) return;
    try {
      final parts = dob.split('/');
      if (parts.length == 3) {
        final birthDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
        final today = DateTime.now();
        int age = today.year - birthDate.year;
        if (today.month < birthDate.month ||
            (today.month == birthDate.month && today.day < birthDate.day)) {
          age--;
        }
        setState(() {
          _age = age;
        });
      }
    } catch (e) {
      debugPrint('Error calculating age: $e');
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      _dobController.text = formattedDate;
      _calculateAge(formattedDate);
    }
  }

  void _showAddCustomAllergyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Allergy'),
        content: TextField(
          controller: _customAllergyController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Enter allergy name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_customAllergyController.text.isNotEmpty) {
                setState(() {
                  _selectedAllergies.add(_customAllergyController.text);
                  _customAllergyController.clear();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveMember() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      
      if (userId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }
      
      try {
        // If editing existing member
        if (widget.member != null && widget.member!['id'] != null) {
          final response = await http.post(
            Uri.parse(AppConfig.updateMemberEndpoint),
            headers: AppConfig.jsonHeaders,
            body: json.encode({
              'member_id': widget.member!['id'],
              'display_name': _nameController.text,
              'relation': _selectedRelation,
              'image_path': _imagePath,
            }),
          ).timeout(AppConfig.requestTimeout);
          
          if (response.statusCode != 200) {
            throw Exception('Server error: ${response.statusCode}');
          }
          
          final result = json.decode(response.body);
          
          if (!mounted) return;
          
          if (result['success']) {
            Navigator.pop(context, {'success': true});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['message'] ?? 'Failed to update')),
            );
          }
        } else {
          // Adding new member
          final response = await http.post(
            Uri.parse(AppConfig.addMemberEndpoint),
            headers: AppConfig.jsonHeaders,
            body: json.encode({
              'owner_user_id': userId,
              'display_name': _nameController.text,
              'relation': _selectedRelation,
              'image_path': _imagePath,
            }),
          ).timeout(AppConfig.requestTimeout);
          
          if (response.statusCode != 200) {
            throw Exception('Server error: ${response.statusCode}');
          }
          
          final result = json.decode(response.body);
          
          if (!mounted) return;
          
          if (result['success']) {
            Navigator.pop(context, {'success': true});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['message'] ?? 'Failed to save')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.member == null ? 'Add Member' : 'Edit Member'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(padding),
            children: [
            Center(
              child: GestureDetector(
                onTap: _showImageSourceDialog,
                child: CircleAvatar(
                  radius: size.width * 0.15,
                  backgroundColor: Colors.orange.withValues(alpha: 0.2),
                  backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                  child: _imagePath == null
                      ? Icon(Icons.add_a_photo, size: size.width * 0.1, color: Colors.orange)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _nicknameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nickname',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'Date of Birth *',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ),
              readOnly: true,
              onTap: _selectDate,
              validator: (value) => value?.isEmpty ?? true ? 'Date of birth is required' : null,
            ),
            if (_age != null) ...[
              const SizedBox(height: 10),
              Text('Age: $_age years', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              initialValue: _selectedRelation,
              decoration: const InputDecoration(
                labelText: 'Relation *',
                border: OutlineInputBorder(),
              ),
              items: _relations.map((relation) {
                return DropdownMenuItem(value: relation, child: Text(relation));
              }).toList(),
              onChanged: (value) => setState(() => _selectedRelation = value),
              validator: (value) => value == null ? 'Please select a relation' : null,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Allergies', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                TextButton.icon(
                  onPressed: _showAddCustomAllergyDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Custom'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._commonAllergies.map((allergy) {
                  final isSelected = _selectedAllergies.contains(allergy);
                  return FilterChip(
                    label: Text(allergy),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedAllergies.add(allergy);
                        } else {
                          _selectedAllergies.remove(allergy);
                        }
                      });
                    },
                    selectedColor: Colors.orange.withValues(alpha: 0.3),
                  );
                }),
                ..._selectedAllergies
                    .where((allergy) => !_commonAllergies.contains(allergy))
                    .map((allergy) {
                  return Chip(
                    label: Text(allergy),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _selectedAllergies.remove(allergy);
                      });
                    },
                    backgroundColor: Colors.orange.withValues(alpha: 0.3),
                  );
                }),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saveMember,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _dobController.dispose();
    _customAllergyController.dispose();
    super.dispose();
  }
}
