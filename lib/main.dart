import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'camera_screens.dart';
import 'geology_database_screen.dart';
import 'learn_guides_screen.dart';
import 'settings_about_screen.dart';

void main() {
  runApp(const RockStoneIdentifierApp());
}

class RockStoneIdentifierApp extends StatelessWidget {
  const RockStoneIdentifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock / Stone Identifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.brown.shade100,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.landscape,
                  size: 50,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Rock Stone Identifier',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                color: Colors.brown,
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const WelcomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.landscape), label: 'Welcome'),
        ],
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full Screen Background Image
          Positioned.fill(
            child: Image.asset('assets/images/home1.jpg', fit: BoxFit.cover),
          ),
          // Gradient Overlay for better text visibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),
          // 3D Title with Shadow Effects
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Main Title with 3D Effect
                Stack(
                  children: [
                    // Shadow layers for 3D depth
                    Transform.translate(
                      offset: const Offset(4, 4),
                      child: Text(
                        'ROCK STONE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 8
                            ..color = Colors.black.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(2, 2),
                      child: Text(
                        'ROCK STONE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.brown.shade800,
                        ),
                      ),
                    ),
                    // Main text
                    Text(
                      'ROCK STONE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [
                              Colors.amber.shade200,
                              Colors.orange.shade400,
                              Colors.brown.shade300,
                            ],
                          ).createShader(const Rect.fromLTWH(0, 0, 400, 70)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Subtitle with glow effect
                Stack(
                  children: [
                    Text(
                      'IDENTIFIER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 8,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      'IDENTIFIER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 8,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.amber.shade400, blurRadius: 20),
                          Shadow(color: Colors.orange.shade600, blurRadius: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 3D Action Buttons
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _build3DButton(context, 'Identify', Icons.camera_alt, Colors.brown, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraScreen())))),
                    const SizedBox(width: 12),
                    Expanded(child: _build3DButton(context, 'Collection', Icons.collections, Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GeologyDatabaseScreen())))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _build3DButton(context, 'Learn', Icons.school, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LearnGuidesScreen())))),
                    const SizedBox(width: 12),
                    Expanded(child: _build3DButton(context, 'Settings', Icons.settings, Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsAboutScreen())))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3DButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withValues(alpha: 0.9), color.withValues(alpha: 0.7)],
          ),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.6), offset: const Offset(0, 8), blurRadius: 15),
            BoxShadow(color: Colors.black.withValues(alpha: 0.3), offset: const Offset(0, 4), blurRadius: 10),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Icon(icon, size: 100, color: Colors.white.withValues(alpha: 0.1)),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8)],
                    ),
                    child: Icon(icon, size: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 4)]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
