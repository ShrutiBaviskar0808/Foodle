import 'package:flutter/material.dart';

class GuideDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const GuideDetailScreen({super.key, required this.title, required this.content});

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
          style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
        ),
      ),
      ),
    );
  }
}
