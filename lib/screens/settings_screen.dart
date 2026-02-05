import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool notifications = true;
  bool dietaryReminders = true;
  String preferredCuisine = 'Italian';
  double spiceLevel = 3.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('dark_mode') ?? false;
      notifications = prefs.getBool('notifications') ?? true;
      dietaryReminders = prefs.getBool('dietary_reminders') ?? true;
      preferredCuisine = prefs.getString('preferred_cuisine') ?? 'Italian';
      spiceLevel = prefs.getDouble('spice_level') ?? 3.0;
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', darkMode);
    await prefs.setBool('notifications', notifications);
    await prefs.setBool('dietary_reminders', dietaryReminders);
    await prefs.setString('preferred_cuisine', preferredCuisine);
    await prefs.setDouble('spice_level', spiceLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Preferences'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionHeader('🍽️ Dining Preferences'),
            _buildCuisineSelector(),
            _buildSpiceLevelSlider(),
            const SizedBox(height: 30),
            
            _buildSectionHeader('🔔 Notifications'),
            _buildSwitchTile('Meal Reminders', notifications, (value) {
              setState(() => notifications = value);
              _saveSettings();
            }),
            _buildSwitchTile('Dietary Alerts', dietaryReminders, (value) {
              setState(() => dietaryReminders = value);
              _saveSettings();
            }),
            const SizedBox(height: 30),
            
            _buildSectionHeader('🎨 Appearance'),
            _buildSwitchTile('Dark Mode', darkMode, (value) {
              setState(() => darkMode = value);
              _saveSettings();
            }),
            const SizedBox(height: 30),
            
            _buildSectionHeader('📊 Food Stats'),
            _buildStatCard('Meals Planned', '47'),
            _buildStatCard('Allergies Tracked', '6'),
            _buildStatCard('Favorite Places', '12'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
    );
  }

  Widget _buildCuisineSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Preferred Cuisine', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: preferredCuisine,
              isExpanded: true,
              items: ['Italian', 'Chinese', 'Mexican', 'Indian', 'Japanese', 'American']
                  .map((cuisine) => DropdownMenuItem(value: cuisine, child: Text('🍴 $cuisine')))
                  .toList(),
              onChanged: (value) {
                setState(() => preferredCuisine = value!);
                _saveSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiceLevelSlider() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Spice Tolerance: ${_getSpiceEmoji(spiceLevel)}', 
                 style: const TextStyle(fontWeight: FontWeight.w500)),
            Slider(
              value: spiceLevel,
              min: 1,
              max: 5,
              divisions: 4,
              thumbColor: Colors.orange,
              activeColor: Colors.orange,
              onChanged: (value) {
                setState(() => spiceLevel = value);
                _saveSettings();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('😌 Mild', style: TextStyle(fontSize: 12)),
                Text('🔥 Extreme', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Card(
      child: SwitchListTile(
        title: Text(title),
        value: value,
        thumbColor: WidgetStateProperty.all(Colors.orange),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
          ],
        ),
      ),
    );
  }

  String _getSpiceEmoji(double level) {
    if (level <= 1.5) return '😌 Mild';
    if (level <= 2.5) return '🌶️ Medium';
    if (level <= 3.5) return '🔥 Hot';
    if (level <= 4.5) return '🌋 Very Hot';
    return '💀 Extreme';
  }
}