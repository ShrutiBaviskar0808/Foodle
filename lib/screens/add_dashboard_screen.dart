import 'package:flutter/material.dart';

class AddDashboardScreen extends StatelessWidget {
  const AddDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add New'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'What would you like to add?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildOptionCard(
              context,
              icon: Icons.family_restroom,
              title: 'Add Family Member',
              description: 'Add a new family member and their preferences',
              color: Colors.blue,
              onTap: () => Navigator.pushNamed(context, '/family'),
            ),
            const SizedBox(height: 15),
            _buildOptionCard(
              context,
              icon: Icons.restaurant,
              title: 'Add Favorite Place',
              description: 'Add a restaurant or dining location',
              color: Colors.green,
              onTap: () => Navigator.pushNamed(context, '/places'),
            ),
            const SizedBox(height: 15),
            _buildOptionCard(
              context,
              icon: Icons.person_add,
              title: 'Add Friend',
              description: 'Add a friend and their food preferences',
              color: Colors.orange,
              onTap: () => Navigator.pushNamed(context, '/friends'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
