import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/schedule_item.dart';

class CacheService {
  static const String _keyCachedSchedule = 'cached_timetable_json';
  static const String _keyCloudUrl = 'cloud_api_url';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyLastUpdated = 'last_cache_updated_time';

  // URL mẫu mặc định (có thể trỏ tới MockAPI, Supabase, Cloudflare Worker hoặc JSON Bin)
  static const String defaultCloudUrl =
      'https://raw.githubusercontent.com/minh-developer/sample-api/main/timetable.json';

  Future<void> saveSchedule(TimetableData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_keyCachedSchedule, jsonString);
    await prefs.setString(_keyLastUpdated, DateTime.now().toIso8601String());
  }

  Future<TimetableData?> getCachedSchedule() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyCachedSchedule);
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(jsonString);
        return TimetableData.fromJson(decoded);
      }
    } catch (_) {}
    return null;
  }

  Future<String> getCloudUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCloudUrl) ?? defaultCloudUrl;
  }

  Future<void> setCloudUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCloudUrl, url.trim());
  }

  Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  Future<String?> getLastCacheTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastUpdated);
  }
}
