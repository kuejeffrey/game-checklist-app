import 'package:device_timezone/device_timezone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AffirmationNotificationService {
  AffirmationNotificationService();

  static const int _notificationId = 4101;
  static const String _channelId = 'daily_affirmations';
  static const String _channelName = 'Daily affirmations';
  static const String _channelDescription =
      'Gentle daily reminders from Level Up';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const List<String> _affirmations = [
    'You are cared for.',
    'One step at a time.',
    'You matter.',
    'You are doing enough.',
    'Progress, not perfection.',
  ];

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    // We initialize the plugin once and set the local timezone so scheduled
    // notifications fire at the user-selected wall clock time.
    tz.initializeTimeZones();
    try {
      final timezoneName = await DeviceTimezone.getLocalTimezone();
      if (timezoneName != null && timezoneName.isNotEmpty) {
        tz.setLocalLocation(tz.getLocation(timezoneName));
      }
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    await initialize();

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final iosPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    final androidGranted =
        await androidPlugin?.requestNotificationsPermission() ?? true;
    final iosGranted =
        await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        true;

    return androidGranted && iosGranted;
  }

  Future<void> scheduleDailyAffirmation(TimeOfDay time) async {
    await initialize();
    await cancelDailyAffirmation();

    final scheduledDate = _nextInstanceOfTime(time);
    final affirmation = _affirmationForDate(scheduledDate);

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // matchDateTimeComponents.time makes this repeat every day at the chosen time.
    await _plugin.zonedSchedule(
      _notificationId,
      'Level Up',
      affirmation,
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyAffirmation() async {
    await initialize();
    await _plugin.cancel(_notificationId);
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (!scheduledDate.isAfter(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  String _affirmationForDate(DateTime date) {
    return _affirmations[date.day % _affirmations.length];
  }
}
