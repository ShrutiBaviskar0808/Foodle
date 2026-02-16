import 'package:flutter/material.dart';
import 'camera_screens.dart';
import 'geology_database_screen.dart';
import 'learn_guides_screen.dart';
import 'settings_about_screen.dart';
import 'mohs_hardness_scale_screen.dart';
import 'rock_formation_timeline_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.brown.shade50, Colors.orange.shade50, Colors.amber.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Rock Stone',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.brown),
                ),
                Text(
                  'Identifier',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.brown.shade700),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _build3DButton(
                        context,
                        'Identify\nRock',
                        Icons.camera_alt,
                        Colors.brown,
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraScreen())),
                      ),
                      _build3DButton(
                        context,
                        'Geology\nDatabase',
                        Icons.collections,
                        Colors.purple,
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GeologyDatabaseScreen())),
                      ),
                      _build3DButton(
                        context,
                        'Learn\nGuides',
                        Icons.school,
                        Colors.blue,
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LearnGuidesScreen())),
                      ),
                      _build3DButton(
                        context,
                        'Settings\n& More',
                        Icons.settings,
                        Colors.orange,
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsAboutScreen())),
                      ),
                      _build3DButton(
                        context,
                        'Mohs\nScale',
                        Icons.speed,
                        Colors.teal,
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MohsHardnessScaleScreen())),
                      ),
                      _build3DButton(
                        context,
                        'Formation\nTimeline',
                        Icons.timeline,
                        Colors.indigo,
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RockFormationTimelineScreen())),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _build3DButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.4), offset: const Offset(0, 8), blurRadius: 12),
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), offset: const Offset(0, 4), blurRadius: 8),
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withValues(alpha: 0.8), color],
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.center,
                    colors: [Colors.white.withValues(alpha: 0.3), Colors.transparent],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Icon(icon, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
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
