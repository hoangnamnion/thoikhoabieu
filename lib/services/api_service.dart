import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../models/schedule_item.dart';
import 'cache_service.dart';

class ApiService {
  final CacheService _cacheService;
  final http.Client _client;

  ApiService({CacheService? cacheService, http.Client? client})
      : _cacheService = cacheService ?? CacheService(),
        _client = client ?? http.Client();

  /// Tải dữ liệu thời khóa biểu từ Cloud URL
  /// Tự động fallback về Offline Cache hoặc Local Asset nếu mất mạng
  Future<TimetableData> fetchSchedule({String? customUrl}) async {
    final url = customUrl ?? await _cacheService.getCloudUrl();

    try {
      final uri = Uri.parse(url);
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'ThoiKhoaBieuApp/1.0',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        final data = TimetableData.fromJson(json);
        // Lưu vào Offline Cache
        await _cacheService.saveSchedule(data);
        return data;
      }
    } catch (_) {
      // Khi mất mạng hoặc lỗi URL, thử đọc từ Cache
    }

    // 1. Thử lấy từ Offline Cache
    final cached = await _cacheService.getCachedSchedule();
    if (cached != null) {
      return cached;
    }

    // 2. Nếu chưa có cache, lấy từ file json mặc định trong app
    return await loadFallbackAsset();
  }

  /// Tải file JSON mẫu kèm theo app
  Future<TimetableData> loadFallbackAsset() async {
    try {
      final jsonString = await rootBundle.loadString('assets/sample_schedule.json');
      final Map<String, dynamic> json = jsonDecode(jsonString);
      final data = TimetableData.fromJson(json);
      await _cacheService.saveSchedule(data);
      return data;
    } catch (e) {
      return TimetableData(
        semester: 'Học kỳ mặc định',
        studentName: 'Sinh viên',
        updatedAt: DateTime.now(),
        items: [],
      );
    }
  }

  /// Kiểm tra xem Cloud URL có hoạt động và trả về dữ liệu đúng định dạng không
  Future<bool> testCloudConnection(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        return decoded is Map && decoded.containsKey('schedule');
      }
    } catch (_) {}
    return false;
  }
}
