import 'package:flutter/material.dart';

class ScheduleItem {
  final String id;
  final int dayOfWeek; // 2: Thứ 2, 3: Thứ 3, ..., 7: Thứ 7, 8: Chủ Nhật
  final String subjectName;
  final String room;
  final String teacher;
  final String startTime; // "HH:mm" e.g., "07:30"
  final String endTime;   // "HH:mm" e.g., "09:50"
  final String colorHex;  // e.g., "#4F46E5"
  final String notes;

  const ScheduleItem({
    required this.id,
    required this.dayOfWeek,
    required this.subjectName,
    required this.room,
    required this.teacher,
    required this.startTime,
    required this.endTime,
    this.colorHex = '#4F46E5',
    this.notes = '',
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id']?.toString() ?? UniqueKey().toString(),
      dayOfWeek: (json['day_of_week'] is int)
          ? json['day_of_week']
          : int.tryParse(json['day_of_week']?.toString() ?? '2') ?? 2,
      subjectName: json['subject_name']?.toString() ?? 'Môn học',
      room: json['room']?.toString() ?? 'Chưa có phòng',
      teacher: json['teacher']?.toString() ?? 'Chưa phân công',
      startTime: json['start_time']?.toString() ?? '07:00',
      endTime: json['end_time']?.toString() ?? '08:00',
      colorHex: json['color']?.toString() ?? '#4F46E5',
      notes: json['notes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_of_week': dayOfWeek,
      'subject_name': subjectName,
      'room': room,
      'teacher': teacher,
      'start_time': startTime,
      'end_time': endTime,
      'color': colorHex,
      'notes': notes,
    };
  }

  Color get color {
    try {
      final hex = colorHex.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return const Color(0xFF4F46E5);
  }
}

class TimetableData {
  final String semester;
  final String studentName;
  final DateTime updatedAt;
  final List<ScheduleItem> items;

  const TimetableData({
    required this.semester,
    required this.studentName,
    required this.updatedAt,
    required this.items,
  });

  factory TimetableData.fromJson(Map<String, dynamic> json) {
    final list = json['schedule'] as List<dynamic>? ?? [];
    return TimetableData(
      semester: json['semester']?.toString() ?? 'Học kỳ',
      studentName: json['student_name']?.toString() ?? 'Sinh viên',
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      items: list.map((item) => ScheduleItem.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'semester': semester,
      'student_name': studentName,
      'updated_at': updatedAt.toIso8601String(),
      'schedule': items.map((e) => e.toJson()).toList(),
    };
  }

  List<ScheduleItem> getItemsForDay(int dayOfWeek) {
    final dayList = items.where((item) => item.dayOfWeek == dayOfWeek).toList();
    dayList.sort((a, b) => a.startTime.compareTo(b.startTime));
    return dayList;
  }
}
