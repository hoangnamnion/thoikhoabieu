import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_khoa_bieu/models/schedule_item.dart';

void main() {
  group('ScheduleItem Model Tests', () {
    final sampleJson = {
      'id': 'test_1',
      'day_of_week': 2,
      'subject_name': 'Lập trình iOS',
      'room': 'A3-201',
      'teacher': 'Thầy Nam',
      'start_time': '07:30',
      'end_time': '09:50',
      'color': '#4F46E5',
      'notes': 'Bài tập lớn'
    };

    test('ScheduleItem fromJson parses correctly', () {
      final item = ScheduleItem.fromJson(sampleJson);
      expect(item.id, 'test_1');
      expect(item.dayOfWeek, 2);
      expect(item.subjectName, 'Lập trình iOS');
      expect(item.room, 'A3-201');
      expect(item.teacher, 'Thầy Nam');
      expect(item.startTime, '07:30');
      expect(item.endTime, '09:50');
      expect(item.colorHex, '#4F46E5');
      expect(item.notes, 'Bài tập lớn');
    });

    test('ScheduleItem toJson serializes correctly', () {
      final item = ScheduleItem.fromJson(sampleJson);
      final json = item.toJson();
      expect(json['id'], 'test_1');
      expect(json['day_of_week'], 2);
      expect(json['subject_name'], 'Lập trình iOS');
      expect(json['room'], 'A3-201');
    });

    test('TimetableData fromJson parses list of schedules and metadata', () {
      final timetableJson = {
        'semester': 'Học kỳ 1 (2026)',
        'student_name': 'Sinh viên A',
        'updated_at': '2026-08-24T08:00:00Z',
        'schedule': [sampleJson]
      };

      final data = TimetableData.fromJson(timetableJson);
      expect(data.semester, 'Học kỳ 1 (2026)');
      expect(data.studentName, 'Sinh viên A');
      expect(data.items.length, 1);
      expect(data.items.first.subjectName, 'Lập trình iOS');
    });

    test('TimetableData filters items by day correctly', () {
      final itemMonday = ScheduleItem.fromJson(sampleJson);
      final itemTuesday = ScheduleItem.fromJson({
        ...sampleJson,
        'id': 'test_2',
        'day_of_week': 3,
        'subject_name': 'Cơ sở dữ liệu',
      });

      final data = TimetableData(
        semester: 'Học kỳ 1',
        studentName: 'Test',
        updatedAt: DateTime.now(),
        items: [itemMonday, itemTuesday],
      );

      final mondayItems = data.getItemsForDay(2);
      expect(mondayItems.length, 1);
      expect(mondayItems.first.subjectName, 'Lập trình iOS');

      final tuesdayItems = data.getItemsForDay(3);
      expect(tuesdayItems.length, 1);
      expect(tuesdayItems.first.subjectName, 'Cơ sở dữ liệu');

      final sundayItems = data.getItemsForDay(8);
      expect(sundayItems.isEmpty, true);
    });
  });
}
