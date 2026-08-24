import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/schedule_provider.dart';
import '../../theme/doraemon_theme.dart';
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

    final currentMonday = now.subtract(Duration(days: now.weekday - 1));

    return Column(
      children: [
        // Thanh chọn ngày phong cách Anime Doraemon
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131B2E) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : DoraemonTheme.doraemonBlue.withOpacity(0.1),
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
                              colors: [Color(0xFF00A0E9), Color(0xFF38BDF8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: !isSelected
                          ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF0F9FF))
                          : null,
                      borderRadius: BorderRadius.circular(18),
                      border: isToday && !isSelected
                          ? Border.all(color: const Color(0xFF00A0E9), width: 2.0)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF00A0E9).withOpacity(0.38),
                                blurRadius: 12,
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
                                : (isDark ? Colors.grey[400] : const Color(0xFF0284C7)),
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
                        // Dấu chuông / chấm chỉ báo
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: itemsCount > 0
                                ? (isSelected ? const Color(0xFFFFD800) : const Color(0xFF10B981))
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

        // Tiêu đề ngày & Badge số lượng tiết phong cách Anime
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00A0E9), Color(0xFF38BDF8)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Text('🔔 ', style: TextStyle(fontSize: 10)),
                          Text(
                            'Hôm nay',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  provider.currentDayItems.isNotEmpty
                      ? '✨ ${provider.currentDayItems.length} tiết học'
                      : '🥮 Nghỉ học',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: provider.currentDayItems.isNotEmpty
                        ? const Color(0xFF0284C7)
                        : const Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Danh sách tiết học
        Expanded(
          child: RefreshIndicator(
            color: DoraemonTheme.doraemonBlue,
            onRefresh: () => provider.refreshSchedule(),
            child: provider.currentDayItems.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      const SizedBox(height: 60),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFFEF3C7),
                              ),
                              child: const Center(
                                child: Text('🥮', style: TextStyle(fontSize: 48)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Hôm nay không có lịch học!',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.grey[300] : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Thưởng thức bánh rán Dorayaki và nghỉ ngơi thôi nào! 🐱✨',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
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
