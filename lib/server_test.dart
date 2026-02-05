import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class ServerTestPage extends StatefulWidget {
  const ServerTestPage({super.key});

  @override
  State<ServerTestPage> createState() => _ServerTestPageState();
}

class _ServerTestPageState extends State<ServerTestPage> {
  String _result = 'Press button to test server connection';

  Future<void> _testConnection() async {
    setState(() {
      _result = 'Testing connection...';
    });

    try {
      // Test basic connectivity
      final response = await http.get(
        Uri.parse(AppConfig.testEndpoint),
      ).timeout(AppConfig.requestTimeout);

      setState(() {
        _result = 'Status: ${response.statusCode}\nResponse: ${response.body}';
      });
    } catch (e) {
      setState(() {
        _result = 'Connection failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom app bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Server Test',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _testConnection,
                      child: const Text('Test Server Connection'),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(_result),
                      ),
                    ),
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