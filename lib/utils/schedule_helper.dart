import 'package:flutter/material.dart';
import '../models/schedule_item.dart';

enum ScheduleStatus {
  upcoming, // Sắp diễn ra
  ongoing,  // Đang trong giờ học
  finished  // Đã kết thúc
}

class ParsedTime {
  final int hour;
  final int minute;
  const ParsedTime(this.hour, this.minute);
}

class ScheduleHelper {
  static const Map<int, String> dayNames = {
    2: 'Thứ 2',
    3: 'Thứ 3',
    4: 'Thứ 4',
    5: 'Thứ 5',
    6: 'Thứ 6',
    7: 'Thứ 7',
    8: 'Chủ Nhật',
  };

  static const Map<int, String> dayShortNames = {
    2: 'T2',
    3: 'T3',
    4: 'T4',
    5: 'T5',
    6: 'T6',
    7: 'T7',
    8: 'CN',
  };

  static ParsedTime parseTime(String timeStr) {
    try {
      final parts = timeStr.trim().split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        return ParsedTime(hour, minute);
      }
    } catch (_) {}
    return const ParsedTime(0, 0);
  }

  static DateTime getDateTimeForSchedule(
    ScheduleItem item,
    int year,
    int month,
    int day, {
    bool isStart = true,
  }) {
    final parsed = parseTime(isStart ? item.startTime : item.endTime);
    return DateTime(year, month, day, parsed.hour, parsed.minute);
  }

  static DateTime calculate30MinReminderTime(
    ScheduleItem item,
    int year,
    int month,
    int day,
  ) {
    final startDateTime = getDateTimeForSchedule(item, year, month, day, isStart: true);
    return startDateTime.subtract(const Duration(minutes: 30));
  }

  static ScheduleStatus getScheduleStatus(ScheduleItem item, DateTime now) {
    final start = getDateTimeForSchedule(item, now.year, now.month, now.day, isStart: true);
    final end = getDateTimeForSchedule(item, now.year, now.month, now.day, isStart: false);

    if (now.isBefore(start)) {
      return ScheduleStatus.upcoming;
    } else if (now.isAfter(end)) {
      return ScheduleStatus.finished;
    } else {
      return ScheduleStatus.ongoing;
    }
  }

  static int getFlutterWeekdayToCustomDay(int weekday) {
    // Flutter DateTime.weekday: 1 (Mon) -> 7 (Sun)
    // Custom day: 2 (Mon) -> 8 (Sun)
    return weekday + 1;
  }
}
