import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  String _testResults = '';
  bool _isLoading = false;

  Future<void> _runAllTests() async {
    setState(() {
      _isLoading = true;
      _testResults = 'Running tests...\n\n';
    });

    // Test different IP addresses
    await _testMultipleIPs();
    
    // Test current config
    await _testConnectivity();
    await _testLoginEndpoint();
    await _testSignupEndpoint();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testMultipleIPs() async {
    List<String> testIPs = [
      '192.168.1.100',
      '192.168.1.101',
      '192.168.0.100',
      '10.0.2.2', // Emulator
    ];

    setState(() {
      _testResults += '🔍 Testing Multiple IP Addresses:\n';
    });

    for (String ip in testIPs) {
      try {
        final response = await http.get(
          Uri.parse('http://$ip/test.php'),
        ).timeout(const Duration(seconds: 5));

        setState(() {
          _testResults += '✅ $ip - Status: ${response.statusCode}\n';
        });
      } catch (e) {
        setState(() {
          _testResults += '❌ $ip - Failed: Connection error\n';
        });
      }
    }
    setState(() {
      _testResults += '\n';
    });
  }

  Future<void> _testConnectivity() async {
    try {
      final response = await http.get(
        Uri.parse(AppConfig.testEndpoint),
      ).timeout(AppConfig.requestTimeout);

      setState(() {
        _testResults += '✅ Basic Connectivity Test:\n';
        _testResults += 'Status: ${response.statusCode}\n';
        _testResults += 'Response: ${response.body}\n\n';
      });
    } catch (e) {
      setState(() {
        _testResults += '❌ Basic Connectivity Test:\n';
        _testResults += 'Error: $e\n\n';
      });
    }
  }

  Future<void> _testLoginEndpoint() async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.loginEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({
          'email': 'test@example.com',
          'password': 'testpass',
        }),
      ).timeout(AppConfig.requestTimeout);

      setState(() {
        _testResults += '✅ Login Endpoint Test:\n';
        _testResults += 'Status: ${response.statusCode}\n';
        _testResults += 'Response: ${response.body}\n\n';
      });
    } catch (e) {
      setState(() {
        _testResults += '❌ Login Endpoint Test:\n';
        _testResults += 'Error: $e\n\n';
      });
    }
  }

  Future<void> _testSignupEndpoint() async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.signupEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({
          'name': 'Test User',
          'email': 'test@example.com',
          'password': 'testpass',
        }),
      ).timeout(AppConfig.requestTimeout);

      setState(() {
        _testResults += '✅ Signup Endpoint Test:\n';
        _testResults += 'Status: ${response.statusCode}\n';
        _testResults += 'Response: ${response.body}\n\n';
      });
    } catch (e) {
      setState(() {
        _testResults += '❌ Signup Endpoint Test:\n';
        _testResults += 'Error: $e\n\n';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug & Troubleshoot'),
        backgroundColor: const Color(0xFFFF8C00),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Server Configuration:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Base URL: ${AppConfig.baseUrl}'),
                    Text('Login: ${AppConfig.loginEndpoint}'),
                    Text('Signup: ${AppConfig.signupEndpoint}'),
                    Text('Verify OTP: ${AppConfig.verifyOtpEndpoint}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _runAllTests,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C00),
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Run All Tests'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Test Results:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _testResults.isEmpty ? 'No tests run yet.' : _testResults,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Troubleshooting Tips:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('FOR PHYSICAL DEVICE:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('1. Find your computer\'s IP address:'),
                    Text('   Windows: cmd > ipconfig'),
                    Text('   Mac: terminal > ifconfig'),
                    Text('2. Update IP in config.dart'),
                    Text('3. Phone and PC must be on same WiFi'),
                    Text('4. Check Windows Firewall'),
                    SizedBox(height: 8),
                    Text('FOR EMULATOR:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('• Use 10.0.2.2 as IP address'),
                    Text('• Make sure XAMPP is running'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}