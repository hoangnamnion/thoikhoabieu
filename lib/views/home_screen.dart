import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import 'settings_screen.dart';
import 'widgets/day_view.dart';
import 'widgets/matrix_grid_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timetable = provider.timetableData;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timetable?.semester ?? 'Thời Khóa Biểu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  timetable?.studentName ?? 'Đang tải...',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Nút chuyển đổi giao diện: Xem theo ngày / Xem bảng lưới tuần
          IconButton(
            tooltip: provider.viewMode == ViewMode.dayView
                ? 'Xem bảng lưới toàn tuần'
                : 'Xem từng ngày',
            icon: Icon(
              provider.viewMode == ViewMode.dayView
                  ? CupertinoIcons.square_grid_2x2
                  : CupertinoIcons.list_bullet,
              color: const Color(0xFF4F46E5),
            ),
            onPressed: () => provider.toggleViewMode(),
          ),

          // Nút Cài đặt nguồn Cloud & Thông báo
          IconButton(
            tooltip: 'Cài đặt Cloud & Thông báo',
            icon: Icon(
              CupertinoIcons.gear_alt,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Thông báo lỗi nếu có
              if (provider.errorMessage != null)
                Container(
                  width: double.infinity,
                  color: Colors.amber.withOpacity(0.15),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.exclamationmark_triangle_fill,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.errorMessage!,
                          style: const TextStyle(fontSize: 12, color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
                ),

              // Nội dung hiển thị
              Expanded(
                child: provider.viewMode == ViewMode.dayView
                    ? const DayViewWidget()
                    : const MatrixGridViewWidget(),
              ),
            ],
          ),

          // Loading Indicator Overlay
          if (provider.isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                color: const Color(0xFF4F46E5),
              ),
            ),
        ],
      ),
    );
  }
}
