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
        statusBgColor = const Color(0xFF10B981).withOpacity(0.18);
        statusTextColor = const Color(0xFF10B981);
        statusText = 'Đang diễn ra';
        statusIcon = CupertinoIcons.play_circle_fill;
        break;
      case ScheduleStatus.upcoming:
        statusBgColor = const Color(0xFF3B82F6).withOpacity(0.15);
        statusTextColor = const Color(0xFF3B82F6);
        statusText = 'Sắp diễn ra';
        statusIcon = CupertinoIcons.time;
        break;
      case ScheduleStatus.finished:
        statusBgColor = (isDark ? Colors.grey[800] : Colors.grey[200])!;
        statusTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
        statusText = 'Đã kết thúc';
        statusIcon = CupertinoIcons.checkmark_circle_fill;
        break;
    }

    final accentColor = item.color;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status == ScheduleStatus.ongoing
              ? accentColor.withOpacity(0.6)
              : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
          width: status == ScheduleStatus.ongoing ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : accentColor.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thanh màu chỉ thị bên trái
              Container(
                width: 6,
                color: accentColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Thời gian & Trạng thái
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.clock,
                                size: 16,
                                color: accentColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${item.startTime} - ${item.endTime}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  statusIcon,
                                  size: 13,
                                  color: statusTextColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: statusTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Tên môn học
                      Text(
                        item.subjectName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Thông tin Phòng & Giảng viên
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.location_solid,
                                  size: 15,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    item.room,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                                      fontWeight: FontWeight.w500,
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
                                Icon(
                                  CupertinoIcons.person_crop_circle,
                                  size: 15,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    item.teacher,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Ghi chú nếu có
                      if (item.notes.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.04)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                CupertinoIcons.info_circle,
                                size: 14,
                                color: isDark ? Colors.grey[400] : Colors.grey[500],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.notes,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
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
