import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  bool _showOtpField = false;
  int? _userId;

  Future<void> _signup() async {
    final response = await http.post(
      Uri.parse('http://localhost/backend/signup.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    final data = json.decode(response.body);
    if (!mounted) return;
    
    if (data['success']) {
      setState(() {
        _showOtpField = true;
        _userId = data['user_id'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  Future<void> _verifyOtp() async {
    final response = await http.post(
      Uri.parse('http://localhost/backend/verify_otp.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': _userId,
        'otp': _otpController.text,
      }),
    );

    final data = json.decode(response.body);
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data['message'])),
    );
    
    if (data['success']) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color(0xFFFF8C00),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_showOtpField)
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: 'Enter OTP'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showOtpField ? _verifyOtp : _signup,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C00),
                foregroundColor: Colors.white,
              ),
              child: Text(_showOtpField ? 'Verify OTP' : 'Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}