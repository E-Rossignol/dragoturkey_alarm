import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton
  NotificationService._internal() {
    initializeTimeZones();
  }

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //INITIALIZE
  Future<void> initNotification() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initSettingsAndroid =
    AndroidInitializationSettings('@mipmap/dofalarm_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );
    await notificationsPlugin.initialize(initSettings);
    _isInitialized = false;
  }

  //NOTIFICATION DETAILS
  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'timer_channel',
        'Timer Notifications',
        channelDescription: 'Channel for timer notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    );
  }

  //SHOW NOTIFICATION
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (_isInitialized) {
      await notificationsPlugin.show(id, title, body, _notificationDetails());
    }
    else {
      debugPrint(
          'NotificationService not initialized. Call initNotification() first.');
    }
  }

  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required Duration delay,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = now.add(delay);
    //schedule the notification
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}