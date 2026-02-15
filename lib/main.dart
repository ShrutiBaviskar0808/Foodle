import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

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
  int _selectedIndex = 1;

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
        ],
      ),
    );
  }
}
