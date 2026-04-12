import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});
  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();


  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async{
    // initialisation de la timezone pour les notifications
    initializeTimeZones();
    setLocalLocation(getLocation('Europe/Paris'));
    const androidSettings = AndroidInitializationSettings('@mipmap/dofalarm_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);
    await notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showInstantNotification({required int id, required String title, required String body}) async {
  await notificationsPlugin.show(
    id,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails('instant_notification_channel_id', 'Instant Notifications',
      channelDescription: 'Instant notification channel',
      importance: Importance.max,
      priority: Priority.high)
    )
  );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    String? body,
    required Duration delay,
}) async {
    TZDateTime now = TZDateTime.now(local);
    TZDateTime scheduledDate = now.add(delay);

    await notificationsPlugin.zonedSchedule(id, title, body, scheduledDate, const NotificationDetails(
      android: AndroidNotificationDetails('daily_reminder_channel_id', 'Daily Reminders', channelDescription: 'Reminder to complete daily habits', importance: Importance.max, priority: Priority.high)
    ),androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () async {
                  await showInstantNotification(
                    id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // id unique basé sur le timestamp actuel
                    title: 'Notification instantanée',
                    body: 'Ceci est une notification qui apparaît immédiatement.'
                  );
                },
                icon: const Icon(Icons.notifications_active, color: Colors.green, size: 50)),
            SizedBox(height: 20),
            IconButton(
                onPressed: () async {
                  await scheduleNotification(
                    id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // id unique basé sur le timestamp actuel
                    title: 'Notification programmée',
                    body: 'Ceci est une notification qui apparaîtra dans 15 secondes.',
                    delay: const Duration(seconds: 15)
                  );
                },
                icon: const Icon(Icons.notifications_active, color: Colors.red, size: 50)),

          ],
    ),
      ),
    );
  }
}
