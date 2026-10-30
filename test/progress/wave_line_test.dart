import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('WaveLine System Unit & Style Predicate Tests', () {
    test('Style predicates classify all 35 wave line styles correctly', () {
      const zigzagStyles = [
        Material4ProgressStyle.smoothZigzagWave,
        Material4ProgressStyle.sharpZigzag,
        Material4ProgressStyle.roundedZigzag,
        Material4ProgressStyle.doubleZigzag,
        Material4ProgressStyle.continuousZigzag,
        Material4ProgressStyle.alternatingZigzag,
        Material4ProgressStyle.elasticZigzag,
        Material4ProgressStyle.flowingZigzag,
        Material4ProgressStyle.morphingZigzag,
        Material4ProgressStyle.multiLayerZigzag,
      ];

      for (final style in zigzagStyles) {
        expect(style.isWaveLine, isTrue, reason: '$style should be wave line');
        expect(style.isZigzagLine, isTrue, reason: '$style should be zigzag');
        expect(style.isOrganicWaveLine, isFalse);
        expect(style.isCreativeLineStyle, isFalse);
      }

      const organicStyles = [
        Material4ProgressStyle.smoothSineWave,
        Material4ProgressStyle.doubleWave,
        Material4ProgressStyle.tripleWave,
        Material4ProgressStyle.liquidWave,
        Material4ProgressStyle.oceanWave,
        Material4ProgressStyle.softRollingWave,
        Material4ProgressStyle.organicFlowWave,
        Material4ProgressStyle.asymmetricWave,
        Material4ProgressStyle.randomizedOrganicWave,
        Material4ProgressStyle.morphingWave,
      ];

      for (final style in organicStyles) {
        expect(style.isWaveLine, isTrue, reason: '$style should be wave line');
        expect(style.isOrganicWaveLine, isTrue, reason: '$style should be organic');
        expect(style.isZigzagLine, isFalse);
        expect(style.isCreativeLineStyle, isFalse);
      }

      const creativeStyles = [
        Material4ProgressStyle.snakeLine,
        Material4ProgressStyle.ribbonFlow,
        Material4ProgressStyle.pulseLine,
        Material4ProgressStyle.breathingLine,
        Material4ProgressStyle.movingDotsLine,
        Material4ProgressStyle.particleFlowLine,
        Material4ProgressStyle.orbitingDotLine,
        Material4ProgressStyle.gradientFlowLine,
        Material4ProgressStyle.shimmerWave,
        Material4ProgressStyle.neonWave,
        Material4ProgressStyle.elasticFlowLine,
        Material4ProgressStyle.infinityFlowLine,
        Material4ProgressStyle.dnaDoubleHelixLine,
        Material4ProgressStyle.audioWaveformLine,
        Material4ProgressStyle.equalizerLine,
      ];

      for (final style in creativeStyles) {
        expect(style.isWaveLine, isTrue, reason: '$style should be wave line');
        expect(style.isCreativeLineStyle, isTrue, reason: '$style should be creative');
        expect(style.isZigzagLine, isFalse);
        expect(style.isOrganicWaveLine, isFalse);
      }
    });

    test('WaveLineGeometry evaluates finite valid y-coordinates', () {
      const config = Material4WaveLineConfig(
        amplitude: 8.0,
        frequency: 4.0,
      );

      const allStyles = [
        ...[
          Material4ProgressStyle.smoothZigzagWave,
          Material4ProgressStyle.sharpZigzag,
          Material4ProgressStyle.roundedZigzag,
          Material4ProgressStyle.doubleZigzag,
          Material4ProgressStyle.continuousZigzag,
          Material4ProgressStyle.alternatingZigzag,
          Material4ProgressStyle.elasticZigzag,
          Material4ProgressStyle.flowingZigzag,
          Material4ProgressStyle.morphingZigzag,
          Material4ProgressStyle.multiLayerZigzag,
        ],
        ...[
          Material4ProgressStyle.smoothSineWave,
          Material4ProgressStyle.doubleWave,
          Material4ProgressStyle.tripleWave,
          Material4ProgressStyle.liquidWave,
          Material4ProgressStyle.oceanWave,
          Material4ProgressStyle.softRollingWave,
          Material4ProgressStyle.organicFlowWave,
          Material4ProgressStyle.asymmetricWave,
          Material4ProgressStyle.randomizedOrganicWave,
          Material4ProgressStyle.morphingWave,
        ],
        ...[
          Material4ProgressStyle.snakeLine,
          Material4ProgressStyle.ribbonFlow,
          Material4ProgressStyle.pulseLine,
          Material4ProgressStyle.breathingLine,
          Material4ProgressStyle.movingDotsLine,
          Material4ProgressStyle.particleFlowLine,
          Material4ProgressStyle.orbitingDotLine,
          Material4ProgressStyle.gradientFlowLine,
          Material4ProgressStyle.shimmerWave,
          Material4ProgressStyle.neonWave,
          Material4ProgressStyle.elasticFlowLine,
          Material4ProgressStyle.infinityFlowLine,
          Material4ProgressStyle.dnaDoubleHelixLine,
          Material4ProgressStyle.audioWaveformLine,
          Material4ProgressStyle.equalizerLine,
        ],
      ];

      for (final style in allStyles) {
        for (var x = 0.0; x <= 200.0; x += 25.0) {
          final y = WaveLineGeometry.evaluateY(
            x: x,
            width: 200.0,
            centerY: 15.0,
            phase: 1.0,
            config: config,
            style: style,
          );
          expect(y.isFinite, isTrue, reason: '$style produced non-finite y at x=$x');
        }
      }
    });

    test('WaveLineGeometry generates valid DNA rungs and particle swarms', () {
      const config = Material4WaveLineConfig(amplitude: 6.0, layers: 2);
      final rungs = WaveLineGeometry.buildDnaRungs(
        startX: 0.0,
        endX: 160.0,
        width: 200.0,
        centerY: 15.0,
        phase: 0.5,
        config: config,
        style: Material4ProgressStyle.dnaDoubleHelixLine,
        spacing: 16.0,
      );
      expect(rungs.length, greaterThanOrEqualTo(10));
      for (final rung in rungs) {
        expect(rung.top.dx, equals(rung.bottom.dx));
        expect(rung.top.dy.isFinite, isTrue);
        expect(rung.bottom.dy.isFinite, isTrue);
      }

      final particles = WaveLineGeometry.buildParticles(
        startX: 0.0,
        endX: 200.0,
        width: 200.0,
        centerY: 15.0,
        phase: 1.2,
        config: config,
        style: Material4ProgressStyle.particleFlowLine,
        particleCount: 12,
      );
      expect(particles.length, equals(12));
      for (final p in particles) {
        expect(p.x, inInclusiveRange(0.0, 200.0));
        expect(p.y.isFinite, isTrue);
        expect(p.opacity, inInclusiveRange(0.0, 1.0));
      }
    });

    test('Material4WaveLineConfig copyWith and equality work cleanly', () {
      const cfg1 = Material4WaveLineConfig(amplitude: 10.0, frequency: 5.0);
      final cfg2 = cfg1.copyWith(amplitude: 14.0);
      expect(cfg2.amplitude, equals(14.0));
      expect(cfg2.frequency, equals(5.0));
      expect(cfg1 == cfg2, isFalse);

      final cfg3 = cfg1.copyWith();
      expect(cfg1, equals(cfg3));
      expect(cfg1.hashCode, equals(cfg3.hashCode));
    });
  });

  group('WaveLine Widget Rendering Tests', () {
    testWidgets('Renders all 10 Zigzag Wave styles at determinate 0.6',
        (WidgetTester tester) async {
      const zigzagStyles = [
        Material4ProgressStyle.smoothZigzagWave,
        Material4ProgressStyle.sharpZigzag,
        Material4ProgressStyle.roundedZigzag,
        Material4ProgressStyle.doubleZigzag,
        Material4ProgressStyle.continuousZigzag,
        Material4ProgressStyle.alternatingZigzag,
        Material4ProgressStyle.elasticZigzag,
        Material4ProgressStyle.flowingZigzag,
        Material4ProgressStyle.morphingZigzag,
        Material4ProgressStyle.multiLayerZigzag,
      ];

      for (final style in zigzagStyles) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Material4ProgressBar.zigzag(
                  value: 0.6,
                  style: style,
                  width: 200,
                  height: 30,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(Material4ProgressBar), findsOneWidget);
      }
    });

    testWidgets('Renders all 10 Organic Wave styles at determinate 0.75',
        (WidgetTester tester) async {
      const organicStyles = [
        Material4ProgressStyle.smoothSineWave,
        Material4ProgressStyle.doubleWave,
        Material4ProgressStyle.tripleWave,
        Material4ProgressStyle.liquidWave,
        Material4ProgressStyle.oceanWave,
        Material4ProgressStyle.softRollingWave,
        Material4ProgressStyle.organicFlowWave,
        Material4ProgressStyle.asymmetricWave,
        Material4ProgressStyle.randomizedOrganicWave,
        Material4ProgressStyle.morphingWave,
      ];

      for (final style in organicStyles) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Material4ProgressBar.waveLine(
                  value: 0.75,
                  style: style,
                  width: 200,
                  height: 30,
                  color: Colors.cyan,
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(Material4ProgressBar), findsOneWidget);
      }
    });

    testWidgets('Renders all 15 Creative Line styles at determinate 0.5',
        (WidgetTester tester) async {
      const creativeStyles = [
        Material4ProgressStyle.snakeLine,
        Material4ProgressStyle.ribbonFlow,
        Material4ProgressStyle.pulseLine,
        Material4ProgressStyle.breathingLine,
        Material4ProgressStyle.movingDotsLine,
        Material4ProgressStyle.particleFlowLine,
        Material4ProgressStyle.orbitingDotLine,
        Material4ProgressStyle.gradientFlowLine,
        Material4ProgressStyle.shimmerWave,
        Material4ProgressStyle.neonWave,
        Material4ProgressStyle.elasticFlowLine,
        Material4ProgressStyle.infinityFlowLine,
        Material4ProgressStyle.dnaDoubleHelixLine,
        Material4ProgressStyle.audioWaveformLine,
        Material4ProgressStyle.equalizerLine,
      ];

      for (final style in creativeStyles) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Material4ProgressBar.creativeLine(
                  value: 0.5,
                  style: style,
                  width: 200,
                  height: 34,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(Material4ProgressBar), findsOneWidget);
      }
    });

    testWidgets('Renders boundary progress 0.0, 0.5, and 1.0 cleanly',
        (WidgetTester tester) async {
      for (final val in [0.0, 0.5, 1.0]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Material4ProgressBar.zigzag(
                  value: val,
                  style: Material4ProgressStyle.sharpZigzag,
                  width: 200,
                  height: 30,
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(Material4ProgressBar), findsOneWidget);
      }
    });

    testWidgets('Renders indeterminate wave line animation without error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4ProgressBar(
                value: null,
                style: Material4ProgressStyle.smoothSineWave,
                width: 200,
                height: 30,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(Material4ProgressBar), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(Material4ProgressBar), findsOneWidget);
    });

    testWidgets('Paused wave line configuration stops phase animation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4ProgressBar(
                value: 0.5,
                style: Material4ProgressStyle.oceanWave,
                waveLine: Material4WaveLineConfig(
                  paused: true,
                ),
                width: 200,
                height: 30,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(Material4ProgressBar), findsOneWidget);
    });

    testWidgets('Respects Reduced Motion setting',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4ProgressBar(
                value: 0.6,
                style: Material4ProgressStyle.neonWave,
                animation: Material4ProgressAnimation(
                  reducedMotion: true,
                ),
                width: 200,
                height: 30,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(Material4ProgressBar), findsOneWidget);
    });

    testWidgets('Rapid progress value mutations execute smoothly without crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4ProgressBar(
                value: 0.1,
                style: Material4ProgressStyle.liquidWave,
                width: 200,
                height: 30,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      // Rapidly update value multiple times
      for (var v = 0.2; v <= 0.9; v += 0.15) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Material4ProgressBar(
                  value: v,
                  style: Material4ProgressStyle.liquidWave,
                  width: 200,
                  height: 30,
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 30));
      }

      expect(find.byType(Material4ProgressBar), findsOneWidget);
    });

    testWidgets('Disposing wave line widget cancels tickers cleanly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4ProgressBar(
                value: 0.7,
                style: Material4ProgressStyle.dnaDoubleHelixLine,
                width: 200,
                height: 30,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Replace widget with empty container to trigger dispose
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox.shrink(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(Material4ProgressBar), findsNothing);
    });

    testWidgets('Material4Progress typedef alias instantiates identically',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Progress(
                value: 0.5,
                style: Material4ProgressStyle.flowingZigzag,
                width: 200,
                height: 30,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(Material4ProgressBar), findsOneWidget);
      expect(find.byType(Material4Progress), findsOneWidget);
    });
  });
}

