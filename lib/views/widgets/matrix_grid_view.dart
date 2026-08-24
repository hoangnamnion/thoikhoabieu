import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/schedule_provider.dart';
import '../../utils/schedule_helper.dart';

class MatrixGridViewWidget extends StatelessWidget {
  const MatrixGridViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timetable = provider.timetableData;
    final now = DateTime.now();
    final todayCustomDay = ScheduleHelper.getFlutterWeekdayToCustomDay(now.weekday);

    if (timetable == null || timetable.items.isEmpty) {
      return const Center(
        child: Text('Chưa có dữ liệu thời khóa biểu.'),
      );
    }

    final days = [2, 3, 4, 5, 6, 7, 8];

    return RefreshIndicator(
      color: const Color(0xFF4F46E5),
      onRefresh: () => provider.refreshSchedule(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: days.map((dayNum) {
            final dayItems = timetable.getItemsForDay(dayNum);
            final dayName = ScheduleHelper.dayNames[dayNum] ?? '';
            final isToday = dayNum == todayCustomDay;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isToday
                      ? const Color(0xFF4F46E5).withOpacity(0.6)
                      : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06)),
                  width: isToday ? 1.8 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isToday
                        ? const Color(0xFF4F46E5).withOpacity(0.12)
                        : Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header thứ trong tuần
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isToday
                          ? const Color(0xFF4F46E5).withOpacity(0.1)
                          : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              dayName,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: isToday
                                    ? const Color(0xFF4F46E5)
                                    : (isDark ? Colors.white : const Color(0xFF0F172A)),
                              ),
                            ),
                            if (isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4F46E5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Hôm nay',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: dayItems.isNotEmpty
                                ? const Color(0xFF4F46E5).withOpacity(0.14)
                                : (isDark ? Colors.white.withOpacity(0.06) : Colors.grey.withOpacity(0.12)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            dayItems.isNotEmpty
                                ? '${dayItems.length} môn'
                                : 'Nghỉ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: dayItems.isNotEmpty
                                  ? const Color(0xFF4F46E5)
                                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Danh sách các môn học
                  if (dayItems.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Center(
                        child: Text(
                          'Không có lịch học',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dayItems.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.05),
                      ),
                      itemBuilder: (context, index) {
                        final item = dayItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              // Badge khối thời gian
                              Container(
                                width: 88,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: item.color.withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      item.startTime,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: item.color,
                                      ),
                                    ),
                                    Text(
                                      item.endTime,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: item.color.withOpacity(0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Thông tin môn & phòng học
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.subjectName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Phòng: ${item.room}  •  ${item.teacher}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
