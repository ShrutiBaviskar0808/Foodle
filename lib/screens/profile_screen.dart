import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  
  const ProfileScreen({super.key, this.onBackPressed});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userDob = '';
  String? userGender;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    
    if (userId != null) {
      try {
        final response = await http.post(
          Uri.parse(AppConfig.getUserProfileEndpoint),
          headers: AppConfig.jsonHeaders,
          body: json.encode({'user_id': userId}),
        ).timeout(AppConfig.requestTimeout);
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success'] == true) {
            final user = data['user'];
            
            // Convert DOB from YYYY-MM-DD to DD/MM/YYYY
            String dobDisplay = '';
            if (user['dob'] != null && user['dob'].toString().isNotEmpty && user['dob'] != '0000-00-00') {
              try {
                final parts = user['dob'].toString().split('-');
                if (parts.length == 3 && parts[0] != '0000') {
                  dobDisplay = '${parts[2]}/${parts[1]}/${parts[0]}';
                }
              } catch (e) {
                dobDisplay = '';
              }
            }
            
            setState(() {
              userName = user['name'] ?? 'User';
              userEmail = user['email'] ?? '';
              userPhone = user['phone'] ?? '';
              userDob = dobDisplay;
              userGender = user['gender'];
              _nameController.text = userName;
              _emailController.text = userEmail;
              _phoneController.text = userPhone;
              _dobController.text = userDob;
            });
            return;
          }
        }
      } catch (e) {
        debugPrint('Error loading profile: $e');
      }
    }
    
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userEmail = prefs.getString('user_email') ?? '';
      _nameController.text = userName;
      _emailController.text = userEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.orange.withValues(alpha: 0.2),
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 12),
              const Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 12),
              const Text('Phone Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 12),
              const Text('Date of Birth', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  hintText: 'Select your date of birth',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  suffixIcon: const Icon(Icons.calendar_today, color: Colors.orange),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: userGender,
                    hint: const Text('Select your gender'),
                    isExpanded: true,
                    items: ['Male', 'Female', 'Other'].map((gender) {
                      return DropdownMenuItem(value: gender, child: Text(gender));
                    }).toList(),
                    onChanged: (value) => setState(() => userGender = value),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
      }
      return;
    }
    
    // Convert DOB from DD/MM/YYYY to YYYY-MM-DD
    String? dobFormatted;
    if (_dobController.text.trim().isNotEmpty) {
      try {
        final parts = _dobController.text.trim().split('/');
        if (parts.length == 3) {
          dobFormatted = '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
        }
      } catch (e) {
        dobFormatted = null;
      }
    }
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.updateUserProfileEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({
          'user_id': userId,
          'phone': _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          'dob': dobFormatted,
          'gender': userGender,
        }),
      ).timeout(AppConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          }
          return;
        }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
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