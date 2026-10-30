import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('RenderBox Preset Compatibility Tests', () {
    testWidgets('All 28 Material4Type presets render inside RenderMaterial4',
        (tester) async {
      for (final shapeType in Material4Type.values) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: Material4Container(
                width: 160,
                height: 100,
                config: Material4Config(type: shapeType),
                child: Text('Preset: ${shapeType.name}'),
              ),
            ),
          ),
        );

        final renderBox = tester.renderObject<RenderMaterial4>(
          find.byType(Material4RenderWidget),
        );
        expect(renderBox.size.width, equals(160.0));
        expect(renderBox.size.height, equals(100.0));
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets(
        'All 10 SchoolShapePresets render cleanly inside RenderMaterial4',
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
                  child: schoolCards[i],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(Material4RenderWidget), findsAtLeastNWidgets(1));
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets(
        'All 38 Material4Container factory constructors render cleanly with RenderBox',
        (tester) async {
      final factories = <Widget>[
        Material4Container.glass(child: const Text('glass')),
        Material4Container.patterned(child: const Text('patterned')),
        Material4Container.innerShadow(child: const Text('innerShadow')),
        Material4Container.neon(child: const Text('neon')),
        Material4Container.metallic(child: const Text('metallic')),
        Material4Container.rainbow(child: const Text('rainbow')),
        Material4Container.multiLayer(
          layers: const [BorderLayer(color: Colors.blue, width: 2)],
          child: const Text('multiLayer'),
        ),
        Material4Container.cornerOnly(child: const Text('cornerOnly')),
        Material4Container.handDrawn(child: const Text('handDrawn')),
        Material4Container.folderTab(child: const Text('folderTab')),
        Material4Container.notchedBadge(child: const Text('notchedBadge')),
        Material4Container.sideTab(child: const Text('sideTab')),
        Material4Container.steppedCorner(child: const Text('steppedCorner')),
        Material4Container.ticket(child: const Text('ticket')),
        Material4Container.postageStamp(child: const Text('postageStamp')),
        Material4Container.zigzagReceipt(child: const Text('zigzagReceipt')),
        Material4Container.arch(child: const Text('arch')),
        Material4Container.hexagon(child: const Text('hexagon')),
        Material4Container.chamferDiagonal(
            child: const Text('chamferDiagonal')),
        Material4Container.organicBlob(child: const Text('organicBlob')),
        Material4Container.scallopedPetal(child: const Text('scallopedPetal')),
        Material4Container.neo3d(child: const Text('neo3d')),
        Material4Container.asymmetricCard(child: const Text('asymmetricCard')),
        Material4Container.capsule(child: const Text('capsule')),
        Material4Container.waveEdge(child: const Text('waveEdge')),
        Material4Container.cloud(child: const Text('cloud')),
        Material4Container.speechBubble(child: const Text('speechBubble')),
        Material4Container.shield(child: const Text('shield')),
        Material4Container.diamond(child: const Text('diamond')),
        Material4Container.octagon(child: const Text('octagon')),
        Material4Container.waveCut(child: const Text('waveCut')),
        Material4Container.concaveRounded(child: const Text('concaveRounded')),
        Material4Container.convexRounded(child: const Text('convexRounded')),
        Material4Container.squircle(child: const Text('squircle')),
        Material4Container.parallelogram(child: const Text('parallelogram')),
        Material4Container.ribbon(child: const Text('ribbon')),
        Material4Container.bookmark(child: const Text('bookmark')),
        Material4Container.customBezier(
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

        expect(find.byType(Material4RenderWidget), findsOneWidget);
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
            child: Material4Container(
              width: 200,
              height: 150,
              config: Material4Config.customBezier(
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

      final renderBox = tester.renderObject<RenderMaterial4>(
        find.byType(Material4RenderWidget),
      );
      expect(renderBox.size, equals(const Size(200, 150)));
      expect(renderBox.currentPath, isNotNull);
    });

    testWidgets(
        'ShapeTransform (rotation, scale, skew) integrates with RenderMaterial4 hit testing',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Material4Container(
              width: 100,
              height: 100,
              config: const Material4Config(
                type: Material4Type.smoothRounded,
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

      final shapeFinder = find.byType(Material4RenderWidget);
      await tester.tap(shapeFinder);
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets(
        'AnimatedMaterial4Container drives RenderMaterial4 during animation transitions',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedMaterial4Container(
                duration: const Duration(milliseconds: 300),
                config: const Material4Config(type: Material4Type.squircle),
                width: 150,
                height: 80,
                color: Colors.blue,
                child: const Text('Animated Shape'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Material4RenderWidget), findsOneWidget);

      // Rebuild with different shape configuration to trigger animation
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedMaterial4Container(
                duration: const Duration(milliseconds: 300),
                config: const Material4Config(type: Material4Type.capsule),
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
      expect(find.byType(Material4RenderWidget), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Settle animation
      await tester.pumpAndSettle();
      expect(find.byType(Material4RenderWidget), findsOneWidget);
    });
  });
}
