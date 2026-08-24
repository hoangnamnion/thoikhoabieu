import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/schedule_item.dart';
import '../../utils/schedule_helper.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleItem item;

  const ScheduleCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();
    final status = ScheduleHelper.getScheduleStatus(item, now);

    Color statusBgColor;
    Color statusTextColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case ScheduleStatus.ongoing:
        statusBgColor = const Color(0xFF10B981).withOpacity(0.16);
        statusTextColor = const Color(0xFF10B981);
        statusText = 'Đang diễn ra';
        statusIcon = CupertinoIcons.play_arrow_solid;
        break;
      case ScheduleStatus.upcoming:
        statusBgColor = const Color(0xFF3B82F6).withOpacity(0.14);
        statusTextColor = const Color(0xFF3B82F6);
        statusText = 'Sắp diễn ra';
        statusIcon = CupertinoIcons.time_solid;
        break;
      case ScheduleStatus.finished:
        statusBgColor = isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05);
        statusTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
        statusText = 'Đã kết thúc';
        statusIcon = CupertinoIcons.check_mark_circled_solid;
        break;
    }

    final accentColor = item.color;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: status == ScheduleStatus.ongoing
              ? accentColor.withOpacity(0.7)
              : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06)),
          width: status == ScheduleStatus.ongoing ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.35)
                : (status == ScheduleStatus.ongoing
                    ? accentColor.withOpacity(0.15)
                    : Colors.black.withOpacity(0.04)),
            blurRadius: status == ScheduleStatus.ongoing ? 20 : 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dải màu nhận diện môn học bên trái
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    bottomLeft: Radius.circular(22),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Thời gian & Trạng thái tiết học
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.clock_fill,
                                  size: 13,
                                  color: accentColor,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${item.startTime} - ${item.endTime}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  statusIcon,
                                  size: 12,
                                  color: statusTextColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: statusTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Tên môn học
                      Text(
                        item.subjectName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Thông tin: Phòng học & Giảng viên
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.06)
                                        : Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.location_solid,
                                    size: 13,
                                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Flexible(
                                  child: Text(
                                    item.room,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.grey[200] : const Color(0xFF334155),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.06)
                                        : Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.person_crop_circle_fill,
                                    size: 13,
                                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Flexible(
                                  child: Text(
                                    item.teacher,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.grey[200] : const Color(0xFF334155),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Ghi chú chi tiết (Mã lớp, tiết học)
                      if (item.notes.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.04)
                                  : Colors.black.withOpacity(0.03),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                CupertinoIcons.info_circle_fill,
                                size: 13,
                                color: isDark ? Colors.grey[400] : Colors.grey[500],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.notes,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
