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
  final _favoriteFoodsController = TextEditingController();
  
  String? _imagePath;
  String? _selectedRelation;
  int? _age;
  final List<String> _selectedAllergies = [];
  final List<String> _favoriteFoods = [];
  
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
      if (widget.member!['age'] != null) {
        _age = int.tryParse(widget.member!['age'].toString());
      }
      if (widget.member!['allergies'] != null) {
        _selectedAllergies.addAll(List<String>.from(widget.member!['allergies']));
      }
      if (_dobController.text.isNotEmpty) {
        _calculateAge(_dobController.text);
      }
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

  Future<String?> _uploadPhoto(String imagePath, int memberId) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.baseUrl}/upload_photo.php'),
      );
      request.fields['member_id'] = memberId.toString();
      request.files.add(await http.MultipartFile.fromPath('photo', imagePath));
      
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var result = json.decode(responseData);
      
      if (result['success'] == true) {
        return result['photo_url'];
      }
    } catch (e) {
      debugPrint('Error uploading photo: $e');
    }
    return null;
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
        // Convert empty strings to null
        final Map<String, dynamic> data = {
          'owner_user_id': userId,
          'display_name': _nameController.text.trim(),
          'nickname': _nicknameController.text.trim().isEmpty ? null : _nicknameController.text.trim(),
          'photo_path': _imagePath,
          'dob': _dobController.text.trim().isEmpty ? null : _dobController.text.trim(),
          'age': _age,
          'relation': _selectedRelation,
        };
        
        debugPrint('Data being sent: $data');
        
        if (widget.member != null && widget.member!['id'] != null) {
          data['member_id'] = widget.member!['id'];
        }
        
        final endpoint = widget.member != null && widget.member!['id'] != null
            ? AppConfig.updateMemberEndpoint
            : AppConfig.addMemberEndpoint;
        
        debugPrint('Saving member: $data to $endpoint');
        
        final response = await http.post(
          Uri.parse(endpoint),
          headers: AppConfig.jsonHeaders,
          body: json.encode(data),
        ).timeout(AppConfig.requestTimeout);
        
        debugPrint('Response: ${response.body}');
        
        if (!mounted) return;
        
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['success'] == true) {
            final memberId = int.tryParse(result['member_id'].toString());
            
            // Upload photo if exists
            String? photoUrl;
            if (_imagePath != null && memberId != null) {
              photoUrl = await _uploadPhoto(_imagePath!, memberId);
              if (photoUrl != null) {
                await http.post(
                  Uri.parse(AppConfig.updateMemberEndpoint),
                  headers: AppConfig.jsonHeaders,
                  body: json.encode({
                    'member_id': memberId,
                    'photo_path': photoUrl,
                  }),
                ).timeout(AppConfig.requestTimeout);
              }
            }
            
            if (_selectedAllergies.isNotEmpty && memberId != null) {
              await _saveAllergies(memberId);
            } else if (_favoriteFoods.isNotEmpty && memberId != null) {
              // Save favorite foods even if no allergies selected
              await _saveAllergies(memberId);
            }
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Member saved successfully')),
            );
            Navigator.pop(context, {'success': true});
            return;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['message'] ?? 'Failed to save')),
            );
          }
        }
      } catch (e) {
        debugPrint('Error saving member: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _saveAllergies(int memberId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      
      debugPrint('Saving ${_selectedAllergies.length} allergies for member $memberId');
      debugPrint('Favorite foods: ${_favoriteFoods.join(", ")}');
      
      if (_selectedAllergies.isEmpty && _favoriteFoods.isNotEmpty) {
        // Save only favorite foods with a placeholder allergy
        final response = await http.post(
          Uri.parse(AppConfig.addAllergyEndpoint),
          headers: AppConfig.jsonHeaders,
          body: json.encode({
            'member_id': memberId,
            'allergy_name': 'None',
            'favorite_foods': _favoriteFoods.join(', '),
            'created_by_user_id': userId,
          }),
        ).timeout(AppConfig.requestTimeout);
        debugPrint('Favorite foods save response: ${response.body}');
      } else {
        for (final allergy in _selectedAllergies) {
          final response = await http.post(
            Uri.parse(AppConfig.addAllergyEndpoint),
            headers: AppConfig.jsonHeaders,
            body: json.encode({
              'member_id': memberId,
              'allergy_name': allergy,
              'favorite_foods': _favoriteFoods.isNotEmpty ? _favoriteFoods.join(', ') : null,
              'created_by_user_id': userId,
            }),
          ).timeout(AppConfig.requestTimeout);
          debugPrint('Allergy save response: ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Error saving allergies: $e');
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Favorite Foods', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Add Favorite Food'),
                        content: TextField(
                          controller: _favoriteFoodsController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            hintText: 'Enter food name',
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
                              if (_favoriteFoodsController.text.isNotEmpty) {
                                setState(() {
                                  _favoriteFoods.add(_favoriteFoodsController.text);
                                  _favoriteFoodsController.clear();
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _favoriteFoods.map((food) {
                return Chip(
                  label: Text(food),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() {
                      _favoriteFoods.remove(food);
                    });
                  },
                  backgroundColor: Colors.green.withValues(alpha: 0.3),
                );
              }).toList(),
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
    _favoriteFoodsController.dispose();
    super.dispose();
  }
}
