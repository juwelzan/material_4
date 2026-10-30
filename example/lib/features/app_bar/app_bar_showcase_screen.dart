import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_4/material_4.dart';

/// Interactive showcase screen displaying all capabilities of the
/// Material 4 Advanced Adaptive AppBar System.
class AppBarShowcaseScreen extends StatefulWidget {
  const AppBarShowcaseScreen({super.key});

  @override
  State<AppBarShowcaseScreen> createState() => _AppBarShowcaseScreenState();
}

class _AppBarShowcaseScreenState extends State<AppBarShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      appBar: AppBar(
        title: Text(
          'Adaptive AppBar Studio',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: const Color(0xFF1E1E24),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF5E43EE),
          unselectedLabelColor: const Color(0xFF7A7A85),
          indicatorColor: const Color(0xFF5E43EE),
          indicatorWeight: 3,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: '1. Dashboard (Reference)'),
            Tab(text: '2. Profile & Morphing'),
            Tab(text: '3. Organic Wave Shape'),
            Tab(text: '4. Frosted Glass'),
            Tab(text: '5. Search Engine'),
            Tab(text: '6. Floating Capsule'),
            Tab(text: '7. Preset Catalog'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReferenceDashboardTab(),
          _buildProfileMorphingTab(),
          _buildOrganicWaveTab(),
          _buildGlassSurfaceTab(),
          _buildSearchEngineTab(),
          _buildFloatingCapsuleTab(),
          _buildPresetCatalogTab(),
        ],
      ),
    );
  }

  // =========================================================================
  // Tab 1: The Reference Dashboard Demo
  // =========================================================================
  Widget _buildReferenceDashboardTab() {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5E43EE), Color(0xFF4C35D5)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Material4Avatar(
                    size: 52,
                    initials: 'SM',
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF5E43EE),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Dr. Sarah Mitchell',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Principal • St. Mary Academy',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_rounded),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.class_rounded),
              title: const Text('Classroom Timetable'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.analytics_rounded),
              title: const Text('Student Analytics'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          Material4SliverAppBar.dashboard(
            title: 'SchoolMate Dashboard',
            subtitle: "St. Mary's Academy",
            expandedHeight: 220.0,
            collapsedHeight: 64.0,
            behavior: Material4AppBarBehavior.floatingOnReverse,
            profile: Material4AppBarProfile(
              initials: 'SM',
              name: 'Dr. Sarah Mitchell',
              subtitle: 'Principal • St. Mary Academy',
              status: Material4AvatarStatus.online(),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile tapped!')),
                );
              },
            ),
            actions: [
              Material4AppBarAction.notification(
                unreadCount: 4,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Notifications: 4 unread notices')),
                  );
                },
              ),
              Material4AppBarAction(
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Filters',
                onPressed: () {},
              ),
            ],
            search: Material4AppBarSearch(
              hintText: 'Search students, classes, records...',
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildDemoFeedCard(index),
                childCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // Tab 2: Profile Morphing Tab
  // =========================================================================
  Widget _buildProfileMorphingTab() {
    return CustomScrollView(
      slivers: [
        Material4SliverAppBar.profile(
          expandedHeight: 230,
          collapsedHeight: 64,
          profile: Material4AppBarProfile(
            initials: 'AM',
            name: 'Alex Morgan',
            subtitle: 'Creative Director & Designer',
            expandedSize: 72,
            compactSize: 36,
            shape: Material4AvatarShape.flower(petals: 8),
            status: Material4AvatarStatus.online(),
            badge: Material4AvatarBadge.verified(),
          ),
          actions: [
            Material4AppBarAction(
              icon: const Icon(Icons.share_rounded),
              onPressed: () {},
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(18),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _buildDemoFeedCard(index, title: 'Portfolio Project #$index'),
              childCount: 15,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // Tab 3: Organic Wave Shape Tab
  // =========================================================================
  Widget _buildOrganicWaveTab() {
    return CustomScrollView(
      slivers: [
        Material4SliverAppBar.organic(
          title: const Text('Organic Wave Design'),
          subtitle: const Text('Sculpted Vector Curve Edge'),
          expandedHeight: 200,
          collapsedHeight: 64,
          profile: const Material4AppBarProfile(initials: 'OW'),
          actions: [
            Material4AppBarAction(
              icon: const Icon(Icons.palette_rounded, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(18),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _buildDemoFeedCard(index, title: 'Sculpted Feed #$index'),
              childCount: 15,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // Tab 4: Frosted Glass Surface Tab
  // =========================================================================
  Widget _buildGlassSurfaceTab() {
    return Stack(
      children: [
        // Decorative gradient background to prove glass transparency
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFD5E5),
                  Color(0xFFE2E7FF),
                  Color(0xFFF7F5F2)
                ],
              ),
            ),
          ),
        ),
        CustomScrollView(
          slivers: [
            Material4SliverAppBar.glass(
              title: const Text('Frosted Glass Header'),
              subtitle: const Text('Real-time GPU Backdrop Blur'),
              expandedHeight: 190,
              collapsedHeight: 64,
              backdropBlur: 20.0,
              profile: const Material4AppBarProfile(initials: 'GL'),
              actions: [
                Material4AppBarAction(
                  icon: const Icon(Icons.blur_on_rounded),
                  onPressed: () {},
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(18),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildDemoFeedCard(index, title: 'Glass Layer #$index'),
                  childCount: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // Tab 5: Search Engine Tab
  // =========================================================================
  Widget _buildSearchEngineTab() {
    return CustomScrollView(
      slivers: [
        Material4SliverAppBar(
          title: const Text('Search & Explore'),
          expandedHeight: 180,
          collapsedHeight: 64,
          search: Material4AppBarSearch(
            hintText: 'Live query search...',
          ),
          actions: [
            Material4AppBarAction(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () {},
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(18),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _buildDemoFeedCard(index, title: 'Search Result #$index'),
              childCount: 15,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // Tab 6: Floating Capsule Tab
  // =========================================================================
  Widget _buildFloatingCapsuleTab() {
    return Scaffold(
      appBar: Material4AppBar.floatingCapsule(
        title: const Text('Capsule Navigation Bar'),
        profile: const Material4AppBarProfile(initials: 'FC'),
        actions: [
          Material4AppBarAction(
            icon: const Icon(Icons.star_rounded, color: Color(0xFF5E43EE)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: 15,
        itemBuilder: (context, index) =>
            _buildDemoFeedCard(index, title: 'Capsule Item #$index'),
      ),
    );
  }

  // =========================================================================
  // Tab 7: Preset Catalog
  // =========================================================================
  Widget _buildPresetCatalogTab() {
    final presets = [
      'Standard Clean AppBar',
      'Center Title Balanced',
      'Leading Title Prominent',
      'Large Dashboard Header',
      'Minimalist Transparent Bar',
      'Organic Wave Shape Bar',
      'Sculpted Neo-3D Surface',
      'Frosted Glass Blur Surface',
      'Floating Capsule Pill',
      'Collapsing Avatar Profile',
      'Drawer-Aware Floating Reverse Bar',
      'Multi-Row Header with Tab Bar',
    ];

    final animationPresets = Material4AnimationPreset.values;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Layout & Surface Catalog',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: const Color(0xFF1E1E24),
            ),
          ),
        ),
        ...presets.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material4Container(
              config: const Material4Config(
                type: Material4Type.smoothRounded,
                cornerRadius: 16,
              ),
              color: Colors.white,
              shadows: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E43EE).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF5E43EE),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  'Full layout geometry, surface & animation fidelity',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: const Color(0xFF7A7A85),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            '9 Coordinated Animation Presets',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: const Color(0xFF1E1E24),
            ),
          ),
        ),
        ...animationPresets.map((preset) {
          final anim = Material4AppBarAnimation.fromPreset(preset);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material4Container(
              config: const Material4Config(
                type: Material4Type.smoothRounded,
                cornerRadius: 14,
              ),
              color: Colors.white,
              shadows: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
              child: ListTile(
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E43EE).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.animation_rounded,
                    color: Color(0xFF5E43EE),
                    size: 20,
                  ),
                ),
                title: Text(
                  'Preset: ${preset.name.toUpperCase()}',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text(
                  'Duration: ${anim.duration.inMilliseconds}ms • Curve: ${anim.curve.runtimeType}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: const Color(0xFF7A7A85),
                  ),
                ),
                trailing: Text(
                  anim.interruptible ? 'Interruptible' : 'Locked',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDemoFeedCard(int index, {String? title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material4Container(
        config: const Material4Config(
          type: Material4Type.smoothRounded,
          cornerRadius: 16,
        ),
        color: Colors.white,
        shadows: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF5E43EE).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF5E43EE),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'Academic Record #$index',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: const Color(0xFF1E1E24),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Mathematics & Advanced Physics • Room 402',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: const Color(0xFF7A7A85),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFB0B0BB),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
