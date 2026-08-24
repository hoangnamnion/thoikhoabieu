import 'package:flutter/material.dart';
import '../models/schedule_item.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../services/notification_service.dart';
import '../utils/schedule_helper.dart';

enum ViewMode {
  dayView,
  matrixGridView
}

class ScheduleProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();
  final NotificationService _notificationService = NotificationService();

  TimetableData? _timetableData;
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedDay = 2; // Mặc định Thứ 2 (2) -> CN (8)
  ViewMode _viewMode = ViewMode.dayView;
  String _cloudUrl = CacheService.defaultCloudUrl;
  bool _notificationsEnabled = true;

  TimetableData? get timetableData => _timetableData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedDay => _selectedDay;
  ViewMode get viewMode => _viewMode;
  String get cloudUrl => _cloudUrl;
  bool get notificationsEnabled => _notificationsEnabled;

  List<ScheduleItem> get currentDayItems {
    if (_timetableData == null) return [];
    return _timetableData!.getItemsForDay(_selectedDay);
  }

  ScheduleProvider() {
    _initToday();
    initData();
  }

  void _initToday() {
    final now = DateTime.now();
    _selectedDay = ScheduleHelper.getFlutterWeekdayToCustomDay(now.weekday);
  }

  Future<void> initData() async {
    _cloudUrl = await _cacheService.getCloudUrl();
    _notificationsEnabled = await _cacheService.isNotificationsEnabled();
    await _notificationService.initialize();
    await refreshSchedule();
  }

  void setSelectedDay(int day) {
    if (_selectedDay != day) {
      _selectedDay = day;
      notifyListeners();
    }
  }

  void toggleViewMode() {
    _viewMode = (_viewMode == ViewMode.dayView)
        ? ViewMode.matrixGridView
        : ViewMode.dayView;
    notifyListeners();
  }

  Future<void> refreshSchedule({String? customUrl}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchSchedule(customUrl: customUrl);
      _timetableData = data;

      if (_notificationsEnabled && data.items.isNotEmpty) {
        await _notificationService.scheduleWeeklyTimetableNotifications(data.items);
      }
    } catch (e) {
      _errorMessage = 'Không thể đồng bộ: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCloudUrl(String newUrl) async {
    final trimmed = newUrl.trim();
    if (trimmed.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    final isValid = await _apiService.testCloudConnection(trimmed);
    if (isValid) {
      await _cacheService.setCloudUrl(trimmed);
      _cloudUrl = trimmed;
      await refreshSchedule(customUrl: trimmed);
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _cacheService.setNotificationsEnabled(enabled);

    if (enabled) {
      final granted = await _notificationService.requestPermissions();
      if (granted && _timetableData != null) {
        await _notificationService.scheduleWeeklyTimetableNotifications(_timetableData!.items);
      }
    } else {
      await _notificationService.cancelAllNotifications();
    }
    notifyListeners();
  }

  Future<bool> triggerTestNotification() async {
    return await _notificationService.sendInstantNotification(
      title: '🔔 [Test] Thông báo Thời Khóa Biểu',
      body: 'Hệ thống nhắc giờ học và vào lớp đang hoạt động chính xác!',
    );
  }
}
