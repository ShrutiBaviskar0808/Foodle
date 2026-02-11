import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'signup.dart';
import 'main_navigation.dart';
import 'forgot_password.dart';
import 'reset_password.dart';
import 'server_test.dart';
import 'debug_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8C00)),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const MainNavigation(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/test': (context) => const ServerTestPage(),
        '/debug': (context) => const DebugPage(),
      },
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Foodle',
      'heading': 'Make Every Meal\nPersonal',
      'description':
          'Foodle helps you remember everyone\'s favorite foods, dislikes, and special cravings — so you always get it right.',
      'image': 'assets/main bg.jpg.jpg',
    },
    {
      'title': 'Preferences',
      'heading': 'Know What They\nLove',
      'description': 'From birthdays to late-night cravings, Foodle helps you choose food that truly makes them smile.',
      'image': 'assets/main bg.jpg.jpg',
    },
    {
      'title': 'Plan Better',
      'heading': 'Avoid What They\nCan\'t Have',
      'description': 'Track allergies and dietary needs to plan meals, parties, and surprises safely and thoughtfully.',
      'image': 'assets/main bg.jpg.jpg',
    },
  ];

  void _nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _skipPage() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final data = onboardingData[_currentIndex];
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              data['image']!,
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
              // Top title
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  data['title']!,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const Spacer(),
              // Bottom card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                    color: const Color(0xFFFF8C00),
                    borderRadius: BorderRadius.circular(28),
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading
                    Text(
                      data['heading']!,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Description
                    Text(
                      data['description']!,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Dots indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == _currentIndex ? 8 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentIndex
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _skipPage,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _nextPage,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
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
          ),
        ],
      ),
    );
  }
}
