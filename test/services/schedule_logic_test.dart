import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_khoa_bieu/models/schedule_item.dart';
import 'package:thoi_khoa_bieu/utils/schedule_helper.dart';

void main() {
  group('Schedule Logic & Time Helpers Tests', () {
    final item = ScheduleItem(
      id: 'test_item',
      dayOfWeek: 2,
      subjectName: 'Test Subject',
      room: 'A101',
      teacher: 'GV A',
      startTime: '08:00',
      endTime: '10:00',
      colorHex: '#4F46E5',
    );

    test('Helper parses time string to TimeOfDay parts correctly', () {
      final parts = ScheduleHelper.parseTime('08:30');
      expect(parts.hour, 8);
      expect(parts.minute, 30);
    });

    test('Status calculation: Ongoing when current time is between start and end', () {
      final now = DateTime(2026, 8, 24, 9, 0); // 9:00 AM (Monday)
      final status = ScheduleHelper.getScheduleStatus(item, now);
      expect(status, ScheduleStatus.ongoing);
    });

    test('Status calculation: Upcoming when current time is before start', () {
      final now = DateTime(2026, 8, 24, 7, 15); // 7:15 AM
      final status = ScheduleHelper.getScheduleStatus(item, now);
      expect(status, ScheduleStatus.upcoming);
    });

    test('Status calculation: Finished when current time is after end', () {
      final now = DateTime(2026, 8, 24, 10, 30); // 10:30 AM
      final status = ScheduleHelper.getScheduleStatus(item, now);
      expect(status, ScheduleStatus.finished);
    });

    test('Status calculation: Finished for passed days and Upcoming for future days', () {
      final nowMonday = DateTime(2026, 8, 24, 9, 0); // Monday (Day 2)
      
      final wednesdayItem = ScheduleItem(
        id: 'wed_item',
        dayOfWeek: 4,
        subjectName: 'Wed Subject',
        room: 'B101',
        teacher: 'GV B',
        startTime: '08:00',
        endTime: '10:00',
      );
      expect(ScheduleHelper.getScheduleStatus(wednesdayItem, nowMonday), ScheduleStatus.upcoming);

      final nowFriday = DateTime(2026, 8, 28, 9, 0); // Friday (Day 6)
      expect(ScheduleHelper.getScheduleStatus(item, nowFriday), ScheduleStatus.finished);
    });
  });
}
