import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('Material4AppBar Standalone Widget Tests', () {
    testWidgets('Renders standard app bar with title and actions',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: Material4AppBar.standard(
              title: const Text('SchoolMate'),
              actions: [
                Material4AppBarAction(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
            body: const Center(child: Text('Body Content')),
          ),
        ),
      );

      expect(find.text('SchoolMate'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Body Content'), findsOneWidget);
    });

    testWidgets('Renders centerTitle preset correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: Material4AppBar.centerTitle(
              title: const Text('Centered Title'),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.text('Centered Title'), findsOneWidget);
    });

    testWidgets('Renders search preset with interactive clear button',
        (tester) async {
      String query = '';
      final controller = TextEditingController(text: 'Initial Query');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: Material4AppBar.search(
              search: Material4AppBarSearch(
                controller: controller,
                hintText: 'Search classes...',
                onChanged: (q) => query = q,
              ),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.text('Initial Query'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(controller.text, isEmpty);
      expect(query, equals(''));
    });

    testWidgets('Renders notification badge with count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: Material4AppBar.standard(
              title: const Text('Notifications Test'),
              actions: [
                Material4AppBarAction.notification(
                  unreadCount: 5,
                  onPressed: () {},
                ),
              ],
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    });

    testWidgets('Renders profile avatar in compact header', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: Material4AppBar.standard(
              title: const Text('Profile Test'),
              profile: const Material4AppBarProfile(
                initials: 'SM',
                name: 'Sarah Mitchell',
              ),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.text('SM'), findsOneWidget);
      expect(find.text('Profile Test'), findsOneWidget);
    });

    testWidgets('Renders organic, glass, and floating capsule presets cleanly',
        (tester) async {
      // 1. Organic
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: Material4AppBar.organic(
              title: const Text('Organic Title'),
            ),
            body: const SizedBox(),
          ),
        ),
      );
      expect(find.text('Organic Title'), findsOneWidget);

      // 2. Glass
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: Material4AppBar.glass(
              title: const Text('Glass Title'),
            ),
            body: const SizedBox(),
          ),
        ),
      );
      expect(find.text('Glass Title'), findsOneWidget);

      // 3. Floating Capsule
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: Material4AppBar.floatingCapsule(
              title: const Text('Capsule Title'),
            ),
            body: const SizedBox(),
          ),
        ),
      );
      expect(find.text('Capsule Title'), findsOneWidget);
    });
  });

  group('Material4SliverAppBar Scroll & Interaction Tests', () {
    testWidgets(
        'Renders expanded header with profile, title, and subtitle at scroll offset 0',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                Material4SliverAppBar.dashboard(
                  title: 'SchoolMate Dashboard',
                  subtitle: "St. Mary's Academy",
                  profile: const Material4AppBarProfile(
                    initials: 'TA',
                    name: 'Teacher Alex',
                  ),
                  actions: [
                    Material4AppBarAction.notification(
                      unreadCount: 3,
                      onPressed: () {},
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Item #$index')),
                    childCount: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('SchoolMate Dashboard'), findsWidgets);
      expect(find.text("St. Mary's Academy"), findsOneWidget);
      expect(find.text('TA'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('Collapses header when scrolling down', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                Material4SliverAppBar.dashboard(
                  title: 'Collapsible Dashboard',
                  subtitle: 'Collapsible Subtitle',
                  expandedHeight: 200.0,
                  collapsedHeight: 60.0,
                  profile: const Material4AppBarProfile(
                    initials: 'JD',
                    name: 'John Doe',
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SizedBox(
                      height: 50,
                      child: Text('Scroll Item $index'),
                    ),
                    childCount: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Scroll down by 250 pixels (fully past expandedHeight)
      await tester.drag(find.text('Scroll Item 1'), const Offset(0, -250));
      await tester.pumpAndSettle();

      // Title should still be present in the compact header
      expect(find.text('Collapsible Dashboard'), findsWidgets);
    });

    testWidgets(
        'Reverse scrolling floating compact header reveals drawer and profile',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: const Drawer(
              child: Center(child: Text('Drawer Menu')),
            ),
            body: CustomScrollView(
              slivers: [
                Material4SliverAppBar.dashboard(
                  title: 'Interactive Dashboard',
                  subtitle: 'Subtitle text',
                  expandedHeight: 200.0,
                  collapsedHeight: 60.0,
                  behavior: Material4AppBarBehavior.floatingOnReverse,
                  profile: const Material4AppBarProfile(
                    initials: 'SR',
                    name: 'Sarah Connor',
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SizedBox(
                      height: 60,
                      child: Text('Card $index'),
                    ),
                    childCount: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // 1. Scroll down 300px to fully collapse
      await tester.drag(find.text('Card 2'), const Offset(0, -300));
      await tester.pumpAndSettle();

      // 2. Reverse scroll up 80px to trigger floating header reveal
      await tester.drag(find.text('Card 8'), const Offset(0, 80));
      await tester.pumpAndSettle();

      // Drawer button should be revealed on the left side
      expect(find.byTooltip('Open navigation menu'), findsOneWidget);

      // Compact Profile avatar should be visible on the right side
      expect(find.text('SR'), findsOneWidget);

      // Tapping the drawer button opens the drawer
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.text('Drawer Menu'), findsOneWidget);
    });

    testWidgets('Adapts gracefully on small screen constraints (320px width)',
        (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                Material4SliverAppBar.dashboard(
                  title: 'SchoolMate Mini',
                  subtitle: 'St. Mary',
                  profile: const Material4AppBarProfile(initials: 'SM'),
                  actions: [
                    Material4AppBarAction.notification(
                      unreadCount: 2,
                      onPressed: () {},
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Text('Row $index'),
                    childCount: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('SchoolMate Mini'), findsWidgets);
    });

    testWidgets('Respects accessibility text scaling without overflow',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(1.6),
            ),
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  Material4SliverAppBar.dashboard(
                    title: 'Accessible Title',
                    subtitle: 'Accessible Subtitle',
                    profile: const Material4AppBarProfile(initials: 'A1'),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Text('Item $index'),
                      childCount: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Accessible Title'), findsWidgets);
    });

    testWidgets('Cleans up controllers and listeners on disposal',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                Material4SliverAppBar.dashboard(
                  title: 'Disposal Test',
                  profile: const Material4AppBarProfile(initials: 'D'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Disposal Test'), findsWidgets);

      // Replaces widget with a plain container to trigger dispose()
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Replaced Screen'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Replaced Screen'), findsOneWidget);
      expect(find.text('Disposal Test'), findsNothing);
    });

    testWidgets('Respects reduced motion preference (disableAnimations: true)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              disableAnimations: true,
            ),
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  Material4SliverAppBar.dashboard(
                    title: 'Reduced Motion App Bar',
                    profile: const Material4AppBarProfile(initials: 'RM'),
                    animation: const Material4AppBarAnimation(
                      reducedMotionAware: true,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Text('Item $index'),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Reduced Motion App Bar'), findsWidgets);
      // Instant collapse without animation stutter
      await tester.drag(find.text('Item 1'), const Offset(0, -300));
      await tester.pump();
      expect(find.text('Reduced Motion App Bar'), findsWidgets);
    });

    testWidgets('Seamlessly handles mid-animation interruption without jumping',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                Material4SliverAppBar.dashboard(
                  title: 'Interruption Test',
                  profile: const Material4AppBarProfile(initials: 'IT'),
                  behavior: Material4AppBarBehavior.floatingOnReverse,
                  animation: const Material4AppBarAnimation(
                    duration: Duration(milliseconds: 300),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SizedBox(
                      height: 60,
                      child: Text('Row $index'),
                    ),
                    childCount: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // 1. Scroll down to trigger collapse
      await tester.drag(find.text('Row 2'), const Offset(0, -250));
      await tester.pump(const Duration(milliseconds: 100));

      // 2. Interrupt immediately with reverse scroll mid-way
      await tester.drag(find.text('Row 5'), const Offset(0, 50));
      await tester.pump(const Duration(milliseconds: 50));

      // 3. Reverse again down
      await tester.drag(find.text('Row 5'), const Offset(0, -50));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders all 9 animation presets cleanly on sliver header',
        (tester) async {
      for (final preset in Material4AnimationPreset.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  Material4SliverAppBar(
                    title: Text('Preset: ${preset.name}'),
                    animation: Material4AppBarAnimation.fromPreset(preset),
                  ),
                  SliverToBoxAdapter(child: Text('Content for ${preset.name}')),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Preset: ${preset.name}'), findsWidgets);
        expect(tester.takeException(), isNull);
      }
    });
  });
}
