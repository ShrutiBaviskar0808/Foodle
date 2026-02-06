import 'package:flutter/material.dart';

class InfoDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const InfoDetailScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(title),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          content,
          style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
        ),
      ),
      ),
    );
  }
}
