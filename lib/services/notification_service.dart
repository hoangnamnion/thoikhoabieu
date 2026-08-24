import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/schedule_item.dart';
import '../utils/schedule_helper.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    // Đặt timezone mặc định Việt Nam / Asia/Ho_Chi_Minh
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    } catch (_) {
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));
      } catch (_) {}
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  /// Yêu cầu quyền gửi thông báo trên iOS
  Future<bool> requestPermissions() async {
    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return true;
  }

  /// Lên lịch thông báo hàng tuần cho tất cả các môn học trong thời khóa biểu
  Future<void> scheduleWeeklyTimetableNotifications(List<ScheduleItem> items) async {
    // Xóa toàn bộ thông báo cũ trước khi đặt lịch mới
    await _notificationsPlugin.cancelAll();

    int notifIdCounter = 100;

    for (final item in items) {
      final startTimeParts = ScheduleHelper.parseTime(item.startTime);
      final iosWeekday = (item.dayOfWeek == 8) ? DateTime.sunday : (item.dayOfWeek - 1);

      // 1. Thông báo trước 30 phút
      var reminderHour = startTimeParts.hour;
      var reminderMinute = startTimeParts.minute - 30;
      if (reminderMinute < 0) {
        reminderMinute += 60;
        reminderHour -= 1;
      }
      if (reminderHour >= 0) {
        await _scheduleWeeklyNotification(
          id: notifIdCounter++,
          title: '⏰ Sắp có tiết học (30 phút nữa)',
          body: '${item.subjectName} tại ${item.room} (${item.startTime} - ${item.endTime})',
          dayOfWeek: iosWeekday,
          hour: reminderHour,
          minute: reminderMinute,
        );
      }

      // 2. Thông báo đúng giờ bắt đầu vào học
      await _scheduleWeeklyNotification(
        id: notifIdCounter++,
        title: '🔔 Đã vào giờ học!',
        body: 'Môn ${item.subjectName} - Phòng ${item.room} - GV: ${item.teacher}',
        dayOfWeek: iosWeekday,
        hour: startTimeParts.hour,
        minute: startTimeParts.minute,
      );
    }
  }

  Future<void> _scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int dayOfWeek, // 1 (Mon) -> 7 (Sun)
    required int hour,
    required int minute,
  }) async {
    try {
      final scheduledDate = _nextInstanceOfDayAndTime(dayOfWeek, hour, minute);

      const NotificationDetails platformDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'timetable_channel',
          'Thời khóa biểu',
          channelDescription: 'Thông báo nhắc nhở lịch học và vào lớp',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi lên lịch thông báo: $e');
      }
    }
  }

  tz.TZDateTime _nextInstanceOfDayAndTime(int dayOfWeek, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduledDate.weekday != dayOfWeek || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
