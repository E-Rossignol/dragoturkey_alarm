import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

/// Singleton service for scheduling and displaying local notifications.
///
/// This class manages the initialization and lifecycle of the notifications plugin,
/// providing methods to show immediate and scheduled notifications.
class NotificationService {
  NotificationService._internal() {
    initializeTimeZones();
  }

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Check if the notification service is initialized.
  ///
  /// Returns: bool - true if initialized, false otherwise.
  bool get isInitialized => _isInitialized;

  /// Initialize the local notifications plugin with Android settings.
  ///
  /// Returns: Future<void>
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

  /// Build Android notification details for displaying notifications.
  ///
  /// Returns: NotificationDetails - Configured with Android-specific settings.
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

  /// Show an immediate notification.
  ///
  /// Parameters:
  /// - id: Unique identifier for the notification.
  /// - title: Notification title.
  /// - body: Notification body text.
  ///
  /// Returns: Future<void>
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (_isInitialized) {
      // Display notification immediately
      await notificationsPlugin.show(id, title, body, _notificationDetails());
    } else {
      debugPrint(
        'NotificationService not initialized. Call initNotification() first.',
      );
    }
  }

  /// Schedule a notification to be shown after a specified delay.
  ///
  /// Parameters:
  /// - id: Unique identifier for the notification (default 1).
  /// - title: Notification title.
  /// - body: Notification body text.
  /// - delay: Duration to wait before showing the notification.
  ///
  /// Returns: Future<void>
  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required Duration delay,
  }) async {
    // Calculate scheduled time as current time plus delay
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = now.add(delay);
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
