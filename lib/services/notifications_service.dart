import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskremind_pro/domain/models/task.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  NotificationsService._();

  static final NotificationsService instance = NotificationsService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'reminder_channel',
    'Reminder Channel',
    importance: Importance.max,
    description: 'Task reminders',
    vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
  );

  Future<void> initialize() async {
    tz.initializeTimeZones();

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  Future<void> scheduleTask(Task task) async {
    final details = const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Reminder Channel',
        priority: Priority.max,
        importance: Importance.max,
        fullScreenIntent: true,
      ),
    );

    if (task.repeatType == RepeatType.daily) {
      await _plugin.zonedSchedule(
        task.id,
        task.title,
        task.description,
        tz.TZDateTime.from(task.remindAt, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return;
    }

    await _plugin.zonedSchedule(
      task.id,
      task.title,
      task.description,
      tz.TZDateTime.from(task.remindAt, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelTask(int id) => _plugin.cancel(id);
}
