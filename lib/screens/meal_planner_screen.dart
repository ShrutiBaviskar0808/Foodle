import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../services/notification_service.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  List<Map<String, String>> mealPlans = [];

  @override
  void initState() {
    super.initState();
    NotificationService().initialize();
    _loadMealPlans();
  }

  Future<void> _loadMealPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    
    if (userId == null) return;
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.getMealsEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'user_id': userId}),
      ).timeout(AppConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            mealPlans = (data['meals'] as List).map((meal) {
              // Convert date from YYYY-MM-DD to DD/MM/YYYY
              String displayDate = meal['meal_date'].toString();
              try {
                final parts = displayDate.split('-');
                if (parts.length == 3) {
                  displayDate = '${parts[2]}/${parts[1]}/${parts[0]}';
                }
              } catch (e) {
                displayDate = meal['meal_date'].toString();
              }
              
              // Format time from HH:MM:SS to HH:MM
              String displayTime = meal['meal_time'].toString();
              try {
                final parts = displayTime.split(':');
                if (parts.length >= 2) {
                  displayTime = '${parts[0]}:${parts[1]}';
                }
              } catch (e) {
                displayTime = meal['meal_time'].toString();
              }
              
              return {
                'id': meal['id'].toString(),
                'meal': meal['meal_name'].toString(),
                'date': displayDate,
                'time': displayTime,
              };
            }).toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading meals: $e');
    }
  }

  Future<void> _saveMealPlan(String mealName, String date, String time) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    
    if (userId == null) return;
    
    try {
      final response = await http.post(
        Uri.parse(AppConfig.addMealEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({
          'user_id': userId,
          'meal_name': mealName,
          'meal_date': date,
          'meal_time': time,
        }),
      ).timeout(AppConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final mealId = data['meal_id'] ?? DateTime.now().millisecondsSinceEpoch;
          
          // Schedule notification
          try {
            final dateParts = date.split('-');
            final timeParts = time.split(':');
            final mealDateTime = DateTime(
              int.parse(dateParts[0]),
              int.parse(dateParts[1]),
              int.parse(dateParts[2]),
              int.parse(timeParts[0]),
              int.parse(timeParts[1]),
            );
            
            await NotificationService().scheduleMealReminder(
              id: mealId is int ? mealId : int.parse(mealId.toString()),
              mealName: mealName,
              mealDateTime: mealDateTime,
            );
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Meal planned! You\'ll get a reminder 2 hours before.'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            debugPrint('Error scheduling notification: $e');
          }
          
          await _loadMealPlans();
        }
      }
    } catch (e) {
      debugPrint('Error saving meal: $e');
    }
  }

  void _addMealPlan() {
    final mealController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Plan a Meal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: mealController,
                decoration: const InputDecoration(labelText: 'Meal Name'),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(selectedDate == null ? 'Select Date' : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setDialogState(() => selectedDate = date);
                },
              ),
              ListTile(
                title: Text(selectedTime == null ? 'Select Time' : '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (time != null) setDialogState(() => selectedTime = time);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (mealController.text.isNotEmpty && selectedDate != null && selectedTime != null) {
                  final dateStr = '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
                  final timeStr = '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00';
                  _saveMealPlan(mealController.text, dateStr, timeStr);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMealPlan(int index) async {
    final mealId = mealPlans[index]['id'];
    if (mealId == null) return;
    
    try {
      // Cancel notification
      await NotificationService().cancelNotification(int.parse(mealId));
      
      final response = await http.post(
        Uri.parse(AppConfig.deleteMealEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'meal_id': int.parse(mealId)}),
      ).timeout(AppConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        await _loadMealPlans();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meal deleted'), backgroundColor: Colors.orange),
          );
        }
      }
    } catch (e) {
      debugPrint('Error deleting meal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Meal Planner'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade400, Colors.deepOrange.shade300],
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.restaurant_menu, color: Colors.white, size: 32),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Plan meals that everyone will love',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: mealPlans.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          const Text(
                            'No meals planned yet',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: mealPlans.length,
                      itemBuilder: (context, index) {
                        final plan = mealPlans[index];
                        return Dismissible(
                          key: Key(plan['meal']! + index.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => _deleteMealPlan(index),
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.restaurant,
                                    color: Colors.orange.shade700,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plan['meal']!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${plan['date']!} at ${plan['time'] ?? 'Not set'}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMealPlan,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
