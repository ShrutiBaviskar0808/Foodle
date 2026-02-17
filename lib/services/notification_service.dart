import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notifications.initialize(settings);
    _initialized = true;
    debugPrint('✅ Notification service initialized with Indian timezone');
  }

  Future<void> scheduleMealReminder({
    required int id,
    required String mealName,
    required DateTime mealDateTime,
  }) async {
    await initialize();

    final indiaTime = tz.TZDateTime.from(mealDateTime, tz.getLocation('Asia/Kolkata'));
    final reminderTime = indiaTime.subtract(const Duration(hours: 2));

    if (reminderTime.isBefore(tz.TZDateTime.now(tz.getLocation('Asia/Kolkata')))) {
      debugPrint('⚠️ Reminder time is in the past, skipping notification');
      return;
    }

    await _notifications.zonedSchedule(
      id,
      '🍽️ Meal Reminder',
      'Your meal "$mealName" is planned in 2 hours!',
      reminderTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meal_reminders',
          'Meal Reminders',
          channelDescription: 'Notifications for planned meals',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint('✅ Notification scheduled for $mealName at ${reminderTime.toString()}');
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    debugPrint('🗑️ Cancelled notification $id');
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
