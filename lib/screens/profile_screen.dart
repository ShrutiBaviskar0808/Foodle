import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profile_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userEmail = prefs.getString('user_email') ?? 'user@example.com';
      userPhone = prefs.getString('user_phone') ?? 'Not set';
      userDob = prefs.getString('user_dob') ?? 'Not set';
      final savedGender = prefs.getString('user_gender');
      userGender = (savedGender == null || savedGender.isEmpty) ? null : savedGender;
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
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                userName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                userEmail,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              _buildInfoCard('Phone', userPhone, Icons.phone),
              _buildInfoCard('Date of Birth', userDob, Icons.cake),
              _buildInfoCard('Gender', userGender ?? 'Not set', Icons.person),
              const SizedBox(height: 20),
              _buildMenuItem(
                context,
                'Edit Profile',
                Icons.edit,
                () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfileScreen()));
                  _loadUserData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: Colors.grey[50],
      ),
    );
  }
}