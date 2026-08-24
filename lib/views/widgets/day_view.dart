import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/schedule_provider.dart';
import '../../utils/schedule_helper.dart';
import 'schedule_card.dart';

class DayViewWidget extends StatelessWidget {
  const DayViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final todayCustomDay = ScheduleHelper.getFlutterWeekdayToCustomDay(now.weekday);

    // Tính toán ngày trong tháng ứng với từng thứ của tuần hiện tại
    final currentMonday = now.subtract(Duration(days: now.weekday - 1));

    return Column(
      children: [
        // Thanh chọn ngày phong cách iOS Segmented Scrollable
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05),
              ),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [2, 3, 4, 5, 6, 7, 8].map((dayNum) {
                final isSelected = provider.selectedDay == dayNum;
                final isToday = todayCustomDay == dayNum;
                final itemsCount = provider.timetableData?.getItemsForDay(dayNum).length ?? 0;
                
                final dayDate = currentMonday.add(Duration(days: dayNum - 2));

                return GestureDetector(
                  onTap: () => provider.setSelectedDay(dayNum),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: !isSelected
                          ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      border: isToday && !isSelected
                          ? Border.all(color: const Color(0xFF4F46E5), width: 1.8)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF4F46E5).withOpacity(0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ScheduleHelper.dayShortNames[dayNum] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.grey[400] : const Color(0xFF64748B)),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${dayDate.day}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white : const Color(0xFF0F172A)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Dấu chấm chỉ báo có lịch học
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: itemsCount > 0
                                ? (isSelected ? Colors.white : const Color(0xFF10B981))
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Tiêu đề ngày & Badge số lượng tiết
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    ScheduleHelper.dayNames[provider.selectedDay] ?? '',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (todayCustomDay == provider.selectedDay) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Hôm nay',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  provider.currentDayItems.isNotEmpty
                      ? '${provider.currentDayItems.length} tiết học'
                      : 'Nghỉ học',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: provider.currentDayItems.isNotEmpty
                        ? const Color(0xFF4F46E5)
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Danh sách tiết học
        Expanded(
          child: RefreshIndicator(
            color: const Color(0xFF4F46E5),
            onRefresh: () => provider.refreshSchedule(),
            child: provider.currentDayItems.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      const SizedBox(height: 70),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9),
                              ),
                              child: Icon(
                                CupertinoIcons.bed_double_fill,
                                size: 38,
                                color: isDark ? Colors.grey[500] : Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Hôm nay không có lịch học!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.grey[300] : Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Hãy tận hưởng thời gian nghỉ ngơi hoặc tự ôn tập nhé.',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey[500] : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.only(bottom: 24, top: 4),
                    itemCount: provider.currentDayItems.length,
                    itemBuilder: (context, index) {
                      final item = provider.currentDayItems[index];
                      return ScheduleCard(item: item);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
