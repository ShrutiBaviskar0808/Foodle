import 'package:flutter/material.dart';
import 'screens/family_screen.dart';
import 'screens/favorite_places_screen.dart';
import 'screens/friends_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.orange, Colors.orange.withValues(alpha: 0.8)],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800'),
                      fit: BoxFit.cover,
                      opacity: 0.3,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.menu, color: Colors.white, size: 24),
                          const Text('Foodle', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300)),
                          CircleAvatar(radius: 22, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100')),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text('Every Plate,', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                          Text('Perfectly Planned', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Family', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FamilyScreen())), child: const Text('View All >', style: TextStyle(color: Colors.orange))),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFamilyMember('The Boss', Icons.person),
                    _buildFamilyMember('My Love', Icons.person),
                    _buildFamilyMember('Kimberly', Icons.person),
                    _buildFamilyMember('Zoey', Icons.child_care),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Favorite Places', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePlacesScreen())), child: const Text('View All >', style: TextStyle(color: Colors.orange))),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildRestaurant('Costas Inn', Colors.green, image: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=200'),
                      _buildRestaurant("Angie's", Colors.blue, image: 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=200'),
                      _buildRestaurant("Koco's Pub", Colors.yellow[700]!, image: 'https://images.unsplash.com/photo-1572116469696-31de0f17cc34?w=200'),
                      _buildRestaurant('BK Lobster', Colors.brown),
                      _buildRestaurant('Oyster', Colors.orange),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Friends', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendsScreen())), child: const Text('View All >', style: TextStyle(color: Colors.orange))),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFriend('Sunil'),
                    _buildFriend('Brett C'),
                    _buildFriend('Joe D'),
                    _buildFriend('Austin'),
                  ],
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMember(String name, IconData icon) {
    return Column(
      children: [
        CircleAvatar(radius: 30, backgroundColor: Colors.orange.withValues(alpha: 0.2), child: Icon(icon, color: Colors.orange, size: 20)),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildRestaurant(String name, Color color, {String? image}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: image != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.restaurant, color: color, size: 30),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator(strokeWidth: 2, color: color));
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                    child: Center(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant, color: color, size: 20),
                  const SizedBox(height: 8),
                  Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color), textAlign: TextAlign.center),
                ],
              ),
      ),
    );
  }

  Widget _buildFriend(String name) {
    return Column(
      children: [
        CircleAvatar(radius: 30, backgroundColor: Colors.grey[200], child: const Icon(Icons.person, color: Colors.grey, size: 20)),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}