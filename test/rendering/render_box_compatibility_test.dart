import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_shape/dynamic_shape.dart';

void main() {
  group('RenderBox Preset Compatibility Tests', () {
    testWidgets(
        'All 28 DynamicShapeType presets render inside RenderDynamicShape',
        (tester) async {
      for (final shapeType in DynamicShapeType.values) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: DynamicShapeContainer(
                width: 160,
                height: 100,
                config: DynamicShapeConfig(type: shapeType),
                child: Text('Preset: ${shapeType.name}'),
              ),
            ),
          ),
        );

        final renderBox = tester.renderObject<RenderDynamicShape>(
          find.byType(DynamicShapeRenderWidget),
        );
        expect(renderBox.size.width, equals(160.0));
        expect(renderBox.size.height, equals(100.0));
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets(
        'All 10 SchoolShapePresets render cleanly inside RenderDynamicShape',
        (tester) async {
      final schoolCards = <Widget>[
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
          amount: r'$450.00',
          date: 'Oct 30, 2026',
        ),
        SchoolShapePresets.noticeBoardCard(
          headline: 'Sports Meet Announcement',
          summary: 'Annual athletics meet starts next Monday at 8 AM.',
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
      ];

      for (int i = 0; i < schoolCards.length; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 500,
                    child: schoolCards[i],
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(DynamicShapeRenderWidget), findsAtLeastNWidgets(1));
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets(
        'All 38 DynamicShapeContainer factory constructors render cleanly with RenderBox',
        (tester) async {
      final factories = <Widget>[
        DynamicShapeContainer.glass(child: const Text('glass')),
        DynamicShapeContainer.patterned(child: const Text('patterned')),
        DynamicShapeContainer.innerShadow(child: const Text('innerShadow')),
        DynamicShapeContainer.neon(child: const Text('neon')),
        DynamicShapeContainer.metallic(child: const Text('metallic')),
        DynamicShapeContainer.rainbow(child: const Text('rainbow')),
        DynamicShapeContainer.multiLayer(
          layers: const [BorderLayer(color: Colors.blue, width: 2)],
          child: const Text('multiLayer'),
        ),
        DynamicShapeContainer.cornerOnly(child: const Text('cornerOnly')),
        DynamicShapeContainer.handDrawn(child: const Text('handDrawn')),
        DynamicShapeContainer.folderTab(child: const Text('folderTab')),
        DynamicShapeContainer.notchedBadge(child: const Text('notchedBadge')),
        DynamicShapeContainer.sideTab(child: const Text('sideTab')),
        DynamicShapeContainer.steppedCorner(child: const Text('steppedCorner')),
        DynamicShapeContainer.ticket(child: const Text('ticket')),
        DynamicShapeContainer.postageStamp(child: const Text('postageStamp')),
        DynamicShapeContainer.zigzagReceipt(child: const Text('zigzagReceipt')),
        DynamicShapeContainer.arch(child: const Text('arch')),
        DynamicShapeContainer.hexagon(child: const Text('hexagon')),
        DynamicShapeContainer.chamferDiagonal(
            child: const Text('chamferDiagonal')),
        DynamicShapeContainer.organicBlob(child: const Text('organicBlob')),
        DynamicShapeContainer.scallopedPetal(
            child: const Text('scallopedPetal')),
        DynamicShapeContainer.neo3d(child: const Text('neo3d')),
        DynamicShapeContainer.asymmetricCard(
            child: const Text('asymmetricCard')),
        DynamicShapeContainer.capsule(child: const Text('capsule')),
        DynamicShapeContainer.waveEdge(child: const Text('waveEdge')),
        DynamicShapeContainer.cloud(child: const Text('cloud')),
        DynamicShapeContainer.speechBubble(child: const Text('speechBubble')),
        DynamicShapeContainer.shield(child: const Text('shield')),
        DynamicShapeContainer.diamond(child: const Text('diamond')),
        DynamicShapeContainer.octagon(child: const Text('octagon')),
        DynamicShapeContainer.waveCut(child: const Text('waveCut')),
        DynamicShapeContainer.concaveRounded(
            child: const Text('concaveRounded')),
        DynamicShapeContainer.convexRounded(child: const Text('convexRounded')),
        DynamicShapeContainer.squircle(child: const Text('squircle')),
        DynamicShapeContainer.parallelogram(child: const Text('parallelogram')),
        DynamicShapeContainer.ribbon(child: const Text('ribbon')),
        DynamicShapeContainer.bookmark(child: const Text('bookmark')),
        DynamicShapeContainer.customBezier(
          builder: (size) => Path()
            ..moveTo(0, 0)
            ..lineTo(size.width, 0)
            ..lineTo(size.width, size.height)
            ..close(),
          child: const Text('customBezier'),
        ),
      ];

      expect(factories.length, equals(38));

      for (int i = 0; i < factories.length; i++) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 150,
                height: 80,
                child: factories[i],
              ),
            ),
          ),
        );

        expect(find.byType(DynamicShapeRenderWidget), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('RenderBox Transformations & Animation Integration', () {
    testWidgets('Custom Bezier shape renders and sizes correctly',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: DynamicShapeContainer(
              width: 200,
              height: 150,
              config: DynamicShapeConfig.customBezier(
                builder: (size) {
                  return Path()
                    ..moveTo(0, size.height / 2)
                    ..quadraticBezierTo(
                        size.width / 2, 0, size.width, size.height / 2)
                    ..quadraticBezierTo(
                        size.width / 2, size.height, 0, size.height / 2)
                    ..close();
                },
              ),
              child: const Text('Bezier Lens'),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderDynamicShape>(
        find.byType(DynamicShapeRenderWidget),
      );
      expect(renderBox.size, equals(const Size(200, 150)));
      expect(renderBox.currentPath, isNotNull);
    });

    testWidgets(
        'ShapeTransform (rotation, scale, skew) integrates with RenderDynamicShape hit testing',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: DynamicShapeContainer(
              width: 100,
              height: 100,
              config: const DynamicShapeConfig(
                type: DynamicShapeType.smoothRounded,
                transform: ShapeTransform(
                  scaleX: 1.2,
                  scaleY: 1.2,
                  rotation: 0.1,
                ),
              ),
              onTap: () {
                tapped = true;
              },
              child: const Text('Transformed'),
            ),
          ),
        ),
      );

      final shapeFinder = find.byType(DynamicShapeRenderWidget);
      await tester.tap(shapeFinder);
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets(
        'AnimatedDynamicShapeContainer drives RenderDynamicShape during animation transitions',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedDynamicShapeContainer(
                duration: const Duration(milliseconds: 300),
                config:
                    const DynamicShapeConfig(type: DynamicShapeType.squircle),
                width: 150,
                height: 80,
                color: Colors.blue,
                child: const Text('Animated Shape'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(DynamicShapeRenderWidget), findsOneWidget);

      // Rebuild with different shape configuration to trigger animation
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedDynamicShapeContainer(
                duration: const Duration(milliseconds: 300),
                config:
                    const DynamicShapeConfig(type: DynamicShapeType.capsule),
                width: 200,
                height: 100,
                color: Colors.purple,
                child: const Text('Animated Shape'),
              ),
            ),
          ),
        ),
      );

      // Advance animation halfway
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.byType(DynamicShapeRenderWidget), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Settle animation
      await tester.pumpAndSettle();
      expect(find.byType(DynamicShapeRenderWidget), findsOneWidget);
    });
  });
}
