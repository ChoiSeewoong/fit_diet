import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 초기화
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    //await _notificationsPlugin.initialize(settings);
  }

  // 알림 예약
  static Future<void> showScheduledNotification(TimeOfDay time) async {
    final now = tz.TZDateTime.now(tz.local);

    // 만약 현재 시각보다 이전 시간이라면 다음 날로 설정
    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      0,
      '🥗 식단 알림',
      '지금 식사할 시간이에요!',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'diet_channel', // 채널 ID
          'Diet Notifications', // 채널 이름
          channelDescription: '식단 알림을 위한 알림 채널',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // ✅ 최신 방식
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 반복
    );
  }
}
