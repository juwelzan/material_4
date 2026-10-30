import 'package:flutter/material.dart';

import 'dynamic_shape_config.dart';
import 'dynamic_shape_container.dart';
import 'shape_smart_layout.dart';
import 'shape_widgets.dart';

/// Next-Generation School Management System Presets.
///
/// Handcrafted, production-grade presets tailored for modern educational apps:
/// Attendance, Academic Records, Student ID, Achievement, Fee Receipt,
/// Notice Board, Examination, Result, Timetable, and Teacher Profile.
class SchoolShapePresets {
  const SchoolShapePresets._();

  // =========================================================================
  // 1. Attendance Card Preset
  // =========================================================================
  static DynamicShapeConfig attendanceConfig({
    ShapeAnchor anchor = ShapeAnchor.topRight,
  }) => DynamicShapeConfig(
    type: DynamicShapeType.folderTab,
    anchor: anchor,
    cornerRadius: 22.0,
    tabWidth: 80.0,
    tabHeight: 18.0,
    borderStyle: BorderStyleType.solid,
  );

  static Widget attendanceCard({
    required String title,
    required String status,
    required String time,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      config: attendanceConfig(),
      color: const Color(0xFFFFECE5),
      borderColor: const Color(0xFFFFB099),
      borderWidth: 1.5,
      onTap: onTap,
      child: ShapeSafeArea(
        config: attendanceConfig(),
        basePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7043).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_turned_in_rounded,
                color: Color(0xFFE64A19),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF263238),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$time • $status',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF78909C),
                    ),
                  ),
                ],
              ),
            ),
            const ShapeBadge(
              label: 'Present',
              backgroundColor: Color(0xFF4CAF50),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 2. Academic Records Preset
  // =========================================================================
  static DynamicShapeConfig academicConfig() => const DynamicShapeConfig(
    type: DynamicShapeType.asymmetricCard,
    cornerRadii: CornerRadii(
      topLeft: 28,
      topRight: 10,
      bottomLeft: 10,
      bottomRight: 28,
    ),
    borderStyle: BorderStyleType.solid,
  );

  static Widget academicCard({
    required String subject,
    required String grade,
    required String term,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      config: academicConfig(),
      color: const Color(0xFFE8F5E9),
      borderColor: const Color(0xFFA5D6A7),
      borderWidth: 1.5,
      onTap: onTap,
      child: ShapeSafeArea(
        config: academicConfig(),
        basePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.auto_stories_rounded,
              color: Color(0xFF2E7D32),
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  Text(
                    term,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                grade,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 3. Student ID Card Preset
  // =========================================================================
  static DynamicShapeConfig studentIdConfig() => const DynamicShapeConfig(
    type: DynamicShapeType.smoothRounded,
    cornerRadius: 24.0,
    borderStyle: BorderStyleType.metallic,
    metallicType: MetallicType.silver,
    isShimmering: true,
    shimmerProgress: 0.5,
  );

  static Widget studentIdCard({
    required String studentName,
    required String studentId,
    required String gradeClass,
  }) {
    return DynamicShapeContainer(
      config: studentIdConfig(),
      color: const Color(0xFF1E293B),
      child: ShapeSafeArea(
        config: studentIdConfig(),
        basePadding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const ShapeAvatar(
              size: 52,
              fallback: Icon(Icons.person, color: Colors.white, size: 28),
              borderColor: Color(0xFF94A3B8),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    studentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ID: $studentId',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    gradeClass,
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.qr_code_2_rounded,
              color: Colors.white70,
              size: 36,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 4. Achievement Certificate Card Preset
  // =========================================================================
  static DynamicShapeConfig achievementConfig() => const DynamicShapeConfig(
    type: DynamicShapeType.shield,
    cornerRadius: 20.0,
    borderStyle: BorderStyleType.metallic,
    metallicType: MetallicType.gold,
  );

  static Widget achievementCard({
    required String title,
    required String subtitle,
  }) {
    return DynamicShapeContainer(
      config: achievementConfig(),
      color: const Color(0xFFFFFBEB),
      child: ShapeSafeArea(
        config: achievementConfig(),
        basePadding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              color: Color(0xFFD97706),
              size: 34,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: Color(0xFF92400E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xFFB45309)),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 5. Fee Receipt Preset
  // =========================================================================
  static DynamicShapeConfig feeReceiptConfig() => const DynamicShapeConfig(
    type: DynamicShapeType.ticketScallop,
    scallopRadius: 12.0,
    borderStyle: BorderStyleType.dashed,
    dashLength: 6.0,
    dashGap: 4.0,
  );

  static Widget feeReceiptCard({
    required String invoiceNo,
    required String amount,
    required String date,
    bool isPaid = true,
  }) {
    return DynamicShapeContainer(
      config: feeReceiptConfig(),
      color: Colors.white,
      borderColor: const Color(0xFFCBD5E1),
      borderWidth: 1.5,
      child: ShapeSafeArea(
        config: feeReceiptConfig(),
        basePadding: const EdgeInsets.symmetric(
          horizontal: 22.0,
          vertical: 16.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  invoiceNo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  isPaid ? 'PAID' : 'PENDING',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPaid
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFEA580C),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 6. Notice Board Preset
  // =========================================================================
  static DynamicShapeConfig noticeBoardConfig() => const DynamicShapeConfig(
    type: DynamicShapeType.folderTab,
    anchor: ShapeAnchor.topLeft,
    tabWidth: 70.0,
    tabHeight: 16.0,
    borderStyle: BorderStyleType.solid,
  );

  static Widget noticeBoardCard({
    required String headline,
    required String summary,
    required String date,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      config: noticeBoardConfig(),
      color: const Color(0xFFFAF5FF),
      borderColor: const Color(0xFFE9D5FF),
      borderWidth: 1.5,
      onTap: onTap,
      child: ShapeSafeArea(
        config: noticeBoardConfig(),
        basePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.campaign_rounded,
                  color: Color(0xFF9333EA),
                  size: 20,
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFA855F7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              headline,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF581C87),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Color(0xFF7E22CE)),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 7. Examination Schedule Preset
  // =========================================================================
  static DynamicShapeConfig examScheduleConfig() => const DynamicShapeConfig(
    type: DynamicShapeType.chamferDiagonal,
    anchor: ShapeAnchor.topRight,
    filletRadius: 14.0,
    borderStyle: BorderStyleType.solid,
  );

  static Widget examinationCard({
    required String examTitle,
    required String subject,
    required String hall,
    required String timing,
  }) {
    return DynamicShapeContainer(
      config: examScheduleConfig(),
      color: const Color(0xFFFFF1F2),
      borderColor: const Color(0xFFFECDD3),
      borderWidth: 1.5,
      child: ShapeSafeArea(
        config: examScheduleConfig(),
        basePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        child: Row(
          children: [
            const Icon(Icons.quiz_rounded, color: Color(0xFFE11D48), size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF881337),
                    ),
                  ),
                  Text(
                    '$examTitle • Room $hall',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFBE123C),
                    ),
                  ),
                  Text(
                    timing,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFB7185),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 8. Result Card Preset
  // =========================================================================
  static DynamicShapeConfig resultConfig() => const DynamicShapeConfig(
    type: DynamicShapeType.squircle,
    cornerRadius: 22.0,
    borderStyle: BorderStyleType.rainbow,
  );

  static Widget resultCard({
    required String examSession,
    required String gpa,
    required String status,
  }) {
    return DynamicShapeContainer(
      config: resultConfig(),
      color: Colors.white,
      borderWidth: 2.5,
      child: ShapeSafeArea(
        config: resultConfig(),
        basePadding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  examSession,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  gpa,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4F46E5),
                  ),
                ),
                const Text(
                  'GPA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF818CF8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 9. Timetable Slot Preset
  // =========================================================================
  static DynamicShapeConfig timetableConfig() => const DynamicShapeConfig(
    type: DynamicShapeType.capsule,
    borderStyle: BorderStyleType.solid,
  );

  static Widget timetableSlot({
    required String time,
    required String subject,
    required String room,
    bool isCurrent = false,
  }) {
    return DynamicShapeContainer(
      config: timetableConfig(),
      color: isCurrent ? const Color(0xFF6366F1) : const Color(0xFFF1F5F9),
      borderColor: isCurrent
          ? const Color(0xFF4338CA)
          : const Color(0xFFE2E8F0),
      borderWidth: 1.0,
      child: ShapeSafeArea(
        config: timetableConfig(),
        basePadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isCurrent ? Colors.white : const Color(0xFF475569),
              ),
            ),
            Text(
              subject,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isCurrent ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            Text(
              'Room $room',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isCurrent ? Colors.white70 : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 10. Teacher Profile Preset
  // =========================================================================
  static DynamicShapeConfig teacherProfileConfig() => const DynamicShapeConfig(
    type: DynamicShapeType.concaveRounded,
    cornerRadius: 18.0,
    borderStyle: BorderStyleType.neonPulse,
    neonPulseIntensity: 0.9,
  );

  static Widget teacherProfileCard({
    required String teacherName,
    required String designation,
    required String department,
  }) {
    return DynamicShapeContainer(
      config: teacherProfileConfig(),
      color: const Color(0xFF0F172A),
      borderColor: const Color(0xFF38BDF8),
      borderWidth: 1.5,
      child: ShapeSafeArea(
        config: teacherProfileConfig(),
        basePadding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            const ShapeAvatar(
              size: 48,
              isOnline: true,
              fallback: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 26,
              ),
              borderColor: Color(0xFF38BDF8),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    teacherName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    designation,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    department,
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.mail_outline_rounded,
              color: Colors.white70,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
