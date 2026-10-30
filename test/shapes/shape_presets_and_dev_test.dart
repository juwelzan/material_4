import 'package:material_4/material_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 8 & 9: Developer Tools & School Presets Tests', () {
    test(
      'Material4Config JSON serialization round-trip retains properties',
      () {
        final original = Material4Config(
          type: Material4Type.waveEdge,
          borderStyle: BorderStyleType.neonPulse,
          cornerRadius: 32.0,
          cornerRadii: const CornerRadii(
            topLeft: 30,
            topRight: 10,
            bottomLeft: 15,
            bottomRight: 25,
          ),
          anchor: ShapeAnchor.bottomCenter,
          waveAmplitude: 9.0,
          waveCount: 4.0,
          rotation: 0.5,
          scaleX: 1.1,
          scaleY: 0.9,
          stretchOffset: const Offset(3, -2),
          backgroundEffect: BackgroundEffectType.meshGradient,
          notches: const [
            ShapeNotch(position: ShapeAnchor.topRight, width: 40, height: 16),
          ],
        );

        final json = original.toJson();
        final restored = Material4Config.fromJson(json);

        expect(restored.type, original.type);
        expect(restored.borderStyle, original.borderStyle);
        expect(restored.cornerRadius, original.cornerRadius);
        expect(restored.cornerRadii?.topLeft, 30.0);
        expect(restored.anchor, original.anchor);
        expect(restored.waveAmplitude, 9.0);
        expect(restored.rotation, 0.5);
        expect(restored.scaleX, 1.1);
        expect(restored.stretchOffset.dx, 3.0);
        expect(restored.backgroundEffect, BackgroundEffectType.meshGradient);
        expect(restored.notches?.length, 1);
        expect(restored.notches?.first.position, ShapeAnchor.topRight);
      },
    );

    test('ShapeCodeGenerator outputs valid Dart string', () {
      const config = Material4Config(
        type: Material4Type.speechBubble,
        cornerRadius: 18.0,
      );

      final code = ShapeCodeGenerator.toDartCode(config, varName: 'testConfig');
      expect(code, contains('final testConfig = Material4Config('));
      expect(code, contains('type: Material4Type.speechBubble,'));
      expect(code, contains('cornerRadius: 18.0,'));
    });

    testWidgets('ShapePlayground renders interactive stage and controls', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShapePlayground())),
      );

      expect(find.byType(ShapePlayground), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('Code'), findsOneWidget);
    });

    testWidgets('All 10 SchoolShapePresets render cleanly in widget tree', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SchoolShapePresets.attendanceCard(
                    title: 'Physics Grade 11',
                    status: 'Active',
                    time: '09:00 AM',
                  ),
                  SchoolShapePresets.academicCard(
                    subject: 'Mathematics',
                    grade: 'A+',
                    term: 'Midterm 2026',
                  ),
                  SchoolShapePresets.studentIdCard(
                    studentName: 'Alex Mercer',
                    studentId: 'STU-9921',
                    gradeClass: 'Grade 11 - Science',
                  ),
                  SchoolShapePresets.achievementCard(
                    title: 'Science Olympiad',
                    subtitle: '1st Place Gold Medal',
                  ),
                  SchoolShapePresets.feeReceiptCard(
                    invoiceNo: 'INV-2026-08',
                    amount: '\$450.00',
                    date: 'Oct 30, 2026',
                  ),
                  SchoolShapePresets.noticeBoardCard(
                    headline: 'Sports Meet Announcement',
                    summary:
                        'Annual athletics meet starts next Monday at 8 AM.',
                    date: '30 Oct',
                  ),
                  SchoolShapePresets.examinationCard(
                    examTitle: 'Final Exam',
                    subject: 'Chemistry',
                    hall: 'Hall 4',
                    timing: '10:30 AM - 12:30 PM',
                  ),
                  SchoolShapePresets.resultCard(
                    examSession: 'Spring 2026 Session',
                    gpa: '3.94',
                    status: 'Honors Standing',
                  ),
                  SchoolShapePresets.timetableSlot(
                    time: '11:15 AM',
                    subject: 'English Lit',
                    room: '305',
                    isCurrent: true,
                  ),
                  SchoolShapePresets.teacherProfileCard(
                    teacherName: 'Dr. Sarah Connor',
                    designation: 'Senior Faculty',
                    department: 'Physics & Astronomy',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Physics Grade 11'), findsOneWidget);
      expect(find.text('Mathematics'), findsOneWidget);
      expect(find.text('Alex Mercer'), findsOneWidget);
      expect(find.text('Science Olympiad'), findsOneWidget);
      expect(find.text('INV-2026-08'), findsOneWidget);
      expect(find.text('Sports Meet Announcement'), findsOneWidget);
      expect(find.text('Chemistry'), findsOneWidget);
      expect(find.text('3.94'), findsOneWidget);
      expect(find.text('English Lit'), findsOneWidget);
      expect(find.text('Dr. Sarah Connor'), findsOneWidget);
    });
  });
}
