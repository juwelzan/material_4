import 'package:flutter/material.dart';
import 'package:material_4/material_4.dart';

import 'features/container/container_gallery.dart';
import 'features/container/liquid_glass_demo_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pre-loads the glass shaders so the first frame has no blank flash.
  await LiquidGlassWidgets.initialize();
  runApp(
    // Per-platform quality caps, accessibility (reduce motion/transparency)
    // and automatic downgrade on slow devices.
    LiquidGlassWidgets.wrap(
      adaptiveQuality: true,
      child: const Material4ExampleApp(),
    ),
  );
}

class Material4ExampleApp extends StatelessWidget {
  const Material4ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material 4 — Universal Container',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6366F1),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const ContainerGalleryHome(),
    );
  }
}

class ContainerGalleryHome extends StatefulWidget {
  const ContainerGalleryHome({super.key});

  @override
  State<ContainerGalleryHome> createState() => _ContainerGalleryHomeState();
}

class _ContainerGalleryHomeState extends State<ContainerGalleryHome> {
  // Start tab, e.g. `flutter run --dart-define=M4_START_TAB=4` opens Glass.
  int _index = const int.fromEnvironment('M4_START_TAB')
      .clamp(0, _pages.length - 1);

  static const _pages = <({String title, IconData icon, Widget page})>[
    (title: 'Shapes', icon: Icons.category_outlined, page: ShapesTab()),
    (title: 'Custom', icon: Icons.gesture, page: CustomShapesTab()),
    (title: 'Borders', icon: Icons.border_style, page: BordersTab()),
    (title: 'Surfaces', icon: Icons.texture, page: SurfacesTab()),
    (title: 'Glass', icon: Icons.blur_on, page: LiquidGlassDemoScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    final current = _pages[_index];
    final isGlass = current.page is LiquidGlassDemoScreen;
    return Scaffold(
      // The glass screen brings its own app bar.
      appBar: isGlass
          ? null
          : AppBar(title: Text('Material4Container · ${current.title}')),
      body: IndexedStack(
        index: _index,
        // Pause animations on hidden tabs.
        children: [
          for (var i = 0; i < _pages.length; i++)
            TickerMode(enabled: i == _index, child: _pages[i].page),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (final p in _pages)
            NavigationDestination(icon: Icon(p.icon), label: p.title),
        ],
      ),
    );
  }
}
