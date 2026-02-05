import 'package:flutter/material.dart';

class IdentifyScreen extends StatelessWidget {
  const IdentifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Identify Rock'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt,
              size: 100,
              color: Colors.brown,
            ),
            const SizedBox(height: 30),
            const Text(
              'Choose Identification Method',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
            _buildIdentifyButton(
              context,
              'Take Photo',
              Icons.camera_alt,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraScreen())),
            ),
            const SizedBox(height: 16),
            _buildIdentifyButton(
              context,
              'Choose from Gallery',
              Icons.photo_library,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GalleryScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentifyButton(BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('My Collection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCollectionItem('Granite', 'Igneous Rock', '15 samples'),
          _buildCollectionItem('Quartz', 'Mineral', '8 samples'),
          _buildCollectionItem('Limestone', 'Sedimentary Rock', '12 samples'),
          _buildCollectionItem('Basalt', 'Igneous Rock', '6 samples'),
        ],
      ),
    );
  }

  Widget _buildCollectionItem(String name, String type, String count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.brown.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.landscape, color: Colors.brown, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  type,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: TextStyle(fontSize: 12, color: Colors.brown.shade300),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Learn'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategoryCard(
            context,
            'Rock Types',
            'Learn about different rock classifications',
            Icons.category,
            Colors.blue,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RockTypesScreen())),
          ),
          _buildCategoryCard(
            context,
            'Minerals Guide',
            'Explore various minerals and their properties',
            Icons.diamond,
            Colors.purple,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MineralsGuideScreen())),
          ),
          _buildCategoryCard(
            context,
            'Geology Basics',
            'Understand fundamental geology concepts',
            Icons.public,
            Colors.green,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GeologyBasicsScreen())),
          ),
          _buildCategoryCard(
            context,
            'Field Guide',
            'Tips for rock hunting and identification',
            Icons.explore,
            Colors.orange,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FieldGuideScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.brown.shade100,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(Icons.person, size: 50, color: Colors.brown),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Rock Explorer',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'rockexplorer@email.com',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildProfileOption(context, 'Edit Profile', Icons.edit, () {}),
          _buildProfileOption(context, 'Statistics', Icons.bar_chart, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StatisticsScreen()))),
          _buildProfileOption(context, 'Achievements', Icons.emoji_events, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AchievementsScreen()))),
          _buildProfileOption(context, 'Settings', Icons.settings, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()))),
          _buildProfileOption(context, 'Help & Support', Icons.help, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()))),
          _buildProfileOption(context, 'About', Icons.info, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()))),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.brown),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
