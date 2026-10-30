import 'dart:async';

import 'package:material_4/material_4.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app_bar/app_bar_showcase_screen.dart';
import '../../avatar/avatar_showcase_screen.dart';
import '../../creative_gallery/creative_showcase_screen.dart';
import '../../progress/progress_showcase_screen.dart';
import '../../progress/wave_line_showcase_screen.dart';
import '../../showcase/material_4_showcase_screen.dart';
import '../widgets/fluid_wave_bottom_bar.dart';
import '../widgets/timeline_track_painter.dart';
import '../widgets/wave_background_painter.dart';

class SchoolDashboardScreen extends StatefulWidget {
  const SchoolDashboardScreen({super.key});

  @override
  State<SchoolDashboardScreen> createState() => _SchoolDashboardScreenState();
}

class _SchoolDashboardScreenState extends State<SchoolDashboardScreen> {
  int _currentNavIndex = 0;
  int _countdownSeconds = 930; // 00:15:30
  int _morphStep = 0; // State for real-time shape morphing animation
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimer(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _nextMorphShape() {
    setState(() {
      _morphStep = (_morphStep + 1) % 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Scrollable Content
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 14,
                bottom: 110,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 18),
                  _buildUpNextHeroCard(),
                  const SizedBox(height: 18),
                  _buildActionCardsGrid(),
                  const SizedBox(height: 18),
                  _buildTodaysTimetableCard(),
                  const SizedBox(height: 16),
                  _buildPendingMarksCard(),
                  const SizedBox(height: 16),
                  _buildMorphingAdaptiveShowcaseCard(),
                  const SizedBox(height: 16),
                  _buildLiveMorphingShowcaseCard(),
                  const SizedBox(height: 16),
                  _buildAcademicSpotlightArchCard(),
                  const SizedBox(height: 16),
                  _buildExamPassReceiptCard(),
                  const SizedBox(height: 16),
                  _buildFrostedLibraryCard(),
                  const SizedBox(height: 16),
                  _buildCompleteShowcaseLauncherButton(),
                  const SizedBox(height: 16),
                  _buildAvatarShowcaseLauncherButton(),
                  const SizedBox(height: 16),
                  _buildProgressShowcaseLauncherButton(),
                  const SizedBox(height: 16),
                  _buildWaveLineShowcaseLauncherButton(),
                  const SizedBox(height: 16),
                  _buildInteractiveShapePlaygroundButton(),
                  const SizedBox(height: 16),
                  _buildCreativeShowcaseButton(),
                  const SizedBox(height: 16),
                  _buildAppBarShowcaseButton(),
                ],
              ),
            ),

            // Fluid Wave Bottom Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FluidWaveBottomBar(
                selectedIndex: _currentNavIndex,
                onItemSelected: (index) {
                  setState(() {
                    _currentNavIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Top Header with School Logo, School Name, Notification Bell, and Scalloped Flower Avatar
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x1F000000), width: 1.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.shield_outlined,
              size: 26,
              color: Color(0xFF2C2C2C),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SchoolMate',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E1E24),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "St. Mary's Academy",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7A7A85),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifications: 3 new teacher notices!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                size: 26,
                color: Color(0xFF2C2C2C),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5252),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Material4Avatar.icon(
          icon: Icons.face_retouching_natural_rounded,
          size: 44,
          shape: Material4AvatarShape.flower(petals: 10),
          backgroundColor: const Color(0xFFFFD5E5),
          iconColor: const Color(0xFF703352),
          border: const Material4AvatarBorder.solid(
            color: Color(0x33B388FF),
            width: 1.5,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AvatarShowcaseScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 2. "UP NEXT" Hero Card
  Widget _buildUpNextHeroCard() {
    return Material4Container.notchedBadge(
      anchor: ShapeAnchor.bottomRight,
      notchWidth: 110,
      notchHeight: 34,
      cornerRadius: 28,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6B58F8), Color(0xFF4C35D5)],
      ),
      borderColor: const Color(0x334830DB),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x284830DB),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
      dockedBadge: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF3320A8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x33FFFFFF), width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_outlined, size: 14, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              _formatTimer(_countdownSeconds),
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: const WaveBackgroundPainter(
                waveColor: Color(0x20FFFFFF),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 18,
              bottom: 22,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'UP NEXT:',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Physics (Grade 11-A1)',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.meeting_room_outlined,
                      size: 14,
                      color: Color(0xDDFFFFFF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Room: 302',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withValues(alpha: 0.90),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: Color(0xDDFFFFFF),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '10:30 AM - 11:15 AM',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withValues(alpha: 0.90),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Quick Action Grid (2x2) Powered by AdaptiveShapeCard
  /// Features shape-aware safe padding so text/icons NEVER get clipped,
  /// plus tactile click scale animations and haptic feedback!
  Widget _buildActionCardsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AdaptiveShapeCard(
                title: 'Take\nAttendance',
                icon: Icons.assignment_turned_in_outlined,
                shapeType: Material4Type.steppedCorner,
                color: const Color(0xFFFFDFD3),
                borderColor: const Color(0x28E0A994),
                textColor: const Color(0xFF221F1F),
                iconColor: const Color(0xFF4A342B),
                height: 86,
                onTap: () => _showFeedback('Opening Take Attendance...'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AdaptiveShapeCard(
                title: 'Marks\nEntry',
                icon: Icons.fact_check_outlined,
                shapeType: Material4Type.folderTab,
                color: const Color(0xFFD6F5E3),
                borderColor: const Color(0x2897CFAD),
                textColor: const Color(0xFF1A261E),
                iconColor: const Color(0xFF285E3B),
                height: 86,
                onTap: () => _showFeedback('Opening Marks Entry...'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AdaptiveShapeCard(
                title: 'Daily\nRegister',
                icon: Icons.edit_note_rounded,
                shapeType: Material4Type.steppedCorner,
                color: const Color(0xFFD3E9FD),
                borderColor: const Color(0x289DC0DF),
                textColor: const Color(0xFF15222E),
                iconColor: const Color(0xFF234C6F),
                height: 86,
                onTap: () => _showFeedback('Opening Daily Register...'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Material4Card.noticeBoard(
                title: 'Notice\nBoard',
                icon: Icons.campaign_outlined,
                backgroundColor: const Color(0xFFDDBCFB),
                border: const Material4CardBorder.thin(
                  color: Color(0xFF1E1E24),
                  width: 1.2,
                ),
                height: 86,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                onTap: () => _showFeedback('Opening Notice Board...'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 4. "Today's Timetable" Section Card
  Widget _buildTodaysTimetableCard() {
    return Material4Container.notchedBadge(
      anchor: ShapeAnchor.topRight,
      notchWidth: 92,
      notchHeight: 28,
      cornerRadius: 24,
      color: const Color(0xFFF9F7F2),
      borderColor: const Color(0x1F2A2A2A),
      borderWidth: 1.0,
      padding: const EdgeInsets.only(left: 18, right: 18, top: 16, bottom: 18),
      dockedBadge: Container(
        margin: const EdgeInsets.only(right: 6, top: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE4D8FD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x336C52EE), width: 1.0),
        ),
        child: Text(
          '85% Done',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF573AE6),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Timetable",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF202026),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 22,
                height: 64,
                child: CustomPaint(painter: TimelineTrackPainter()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _buildTimetableItem(
                      timeAndSubject: '09:00 AM - Chemistry (10-B)',
                      isCompleted: true,
                    ),
                    const SizedBox(height: 8),
                    _buildTimetableItem(
                      timeAndSubject: '10:30 AM - Physics (11-A)',
                      isCompleted: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableItem({
    required String timeAndSubject,
    required bool isCompleted,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x18000000), width: 0.8),
      ),
      child: Text(
        timeAndSubject,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color:
              isCompleted ? const Color(0xFF6B6B75) : const Color(0xFF222228),
        ),
      ),
    );
  }

  /// 5. "Pending Marks" Section Card with Dashed Border
  Widget _buildPendingMarksCard() {
    return Material4Container.ticket(
      color: const Color(0xFFFAF9F6),
      borderColor: const Color(0x442A2A2A),
      borderWidth: 1.2,
      borderStyle: BorderStyleType.dashed,
      cornerRadius: 22,
      scallopRadius: 10,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Marks',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF202026),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Midterm Exam - Math (12-C)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF7A7A85),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8DD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x33E07342), width: 1.0),
            ),
            child: Text(
              'Pending',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFD4561E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 6. Anti-Clipping Auto-Morphing Adaptive Card
  /// Demonstrates shape changing on every tap without clipping text or icon!
  Widget _buildMorphingAdaptiveShowcaseCard() {
    return AdaptiveShapeCard(
      title: 'Smart Class Access Pass',
      subtitle: 'Tap to Morph Shape • Zero Text/Icon Clipping',
      icon: Icons.auto_awesome_rounded,
      autoMorphOnTap: true,
      color: const Color(0xFFEDE7F6),
      borderColor: const Color(0xFF5E43EE),
      borderWidth: 1.4,
      textColor: const Color(0xFF21153B),
      iconColor: const Color(0xFF5E43EE),
      subtitleColor: const Color(0xFF674FA3),
      badge: Container(
        margin: const EdgeInsets.only(right: 6, top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF5E43EE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'TAP TO MORPH',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 9.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
      height: 94,
    );
  }

  /// 7. Live Interactive Shape Morphing Showcase Card (AnimatedMaterial4Container)
  Widget _buildLiveMorphingShowcaseCard() {
    // Defines 4 state configs to morph smoothly between
    final configs = [
      const Material4Config(
        type: Material4Type.folderTab,
        cornerRadius: 24,
        tabWidth: 70,
        tabHeight: 18,
        borderStyle: BorderStyleType.solid,
      ),
      const Material4Config(
        type: Material4Type.notchedBadge,
        cornerRadius: 28,
        tabWidth: 88,
        tabHeight: 28,
        borderStyle: BorderStyleType.solid,
      ),
      const Material4Config(
        type: Material4Type.ticketScallop,
        cornerRadius: 20,
        scallopRadius: 14,
        borderStyle: BorderStyleType.dashed,
      ),
      const Material4Config(
        type: Material4Type.hexagonSoft,
        cornerRadius: 18,
        borderStyle: BorderStyleType.solid,
      ),
    ];

    final colors = [
      const Color(0xFFE2F0D9),
      const Color(0xFFE6E6FA),
      const Color(0xFFFFF0E0),
      const Color(0xFFE0F7FA),
    ];

    final titles = [
      'Folder Tab (State 1)',
      'Notched Badge (State 2)',
      'Ticket Scallop (State 3)',
      'Soft Hexagon (State 4)',
    ];

    return AnimatedMaterial4Container(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      config: configs[_morphStep],
      color: colors[_morphStep],
      borderColor: const Color(0x33000000),
      borderWidth: 1.4,
      onTap: _nextMorphShape,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.animation_rounded,
              color: Color(0xFF4A34D4),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        titles[_morphStep],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E1E24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A34D4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Tap to Morph',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Smooth implicit path interpolation with zero lag',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B6B75),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.touch_app_rounded,
            size: 22,
            color: Color(0xFF4A34D4),
          ),
        ],
      ),
    );
  }

  /// 7. Cathedral Arch Spotlight Card with Layered Double Border Frame
  Widget _buildAcademicSpotlightArchCard() {
    return Material4Container.arch(
      height: 125,
      color: const Color(0xFFFFF9EE),
      borderColor: const Color(0xFFD4A745),
      borderWidth: 1.4,
      borderStyle: BorderStyleType.doubleStroke,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      onTap: () => _showFeedback('Academic Honors View'),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E2B8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '★ MERIT SPOTLIGHT',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF785507),
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 6,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBEBC7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xFFB58416),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Grade 11 Science Exhibition',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF261D09),
                        ),
                      ),
                      Text(
                        '1st Place Project • 2 Days Remaining',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7A6B48),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 8. Sawtooth / Zigzag Cut Receipt Card with Technical Grid Pattern
  Widget _buildExamPassReceiptCard() {
    return Material4Container.zigzagReceipt(
      color: const Color(0xFFFFFFFF),
      borderColor: const Color(0x3835495E),
      borderWidth: 1.2,
      borderStyle: BorderStyleType.dashed,
      padding: const EdgeInsets.only(left: 18, right: 18, top: 14, bottom: 20),
      onTap: () => _showFeedback('Downloading Exam Hall Pass...'),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 22,
              color: Color(0xFF2764A8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Final Term Hall Pass #9281',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1C2834),
                  ),
                ),
                Text(
                  'Verified • Ready to Print',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF65788A),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.qr_code_2_rounded,
            size: 26,
            color: Color(0xFF425668),
          ),
        ],
      ),
    );
  }

  /// 9. Frosted Glassmorphic Library Pass with Guilloche Waves Texture
  Widget _buildFrostedLibraryCard() {
    return Material4Container.patterned(
      pattern: ShapePattern.guillocheWaves,
      patternSpacing: 14,
      patternColor: const Color(0x122D68C4),
      color: const Color(0xFFEBF3FD),
      borderColor: const Color(0x40316BC2),
      borderWidth: 1.2,
      config: const Material4Config(
        type: Material4Type.folderTab,
        cornerRadius: 22,
        tabWidth: 65,
        tabHeight: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      onTap: () => _showFeedback('Digital Library Card Opened'),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD6E7FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_library_rounded,
              size: 22,
              color: Color(0xFF1D55A6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Digital Library Pass',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF163766),
                  ),
                ),
                Text(
                  'Guilloche Security Watermark • 4 Books Checked Out',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF456D9F),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.badge_outlined, size: 22, color: Color(0xFF1D55A6)),
        ],
      ),
    );
  }

  /// Complete Material 4 Showcase Launcher (10 Sections)
  Widget _buildCompleteShowcaseLauncherButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5E43EE), Color(0xFF7E60FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x335E43EE),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const Material4ShowcaseScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Material 4 Complete Showcase',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '10 Interactive Sections: Shapes, Borders, Paper, Cards & Morphing',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 9b. Dynamic Profile Avatar Gallery Launcher
  Widget _buildAvatarShowcaseLauncherButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33E91E63),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AvatarShowcaseScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Material 4 Avatar Gallery',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '13 Presets: 24+ Shapes, Vector Borders, Status Pulse & Badges',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 9c. Dynamic Progress Bar Studio Launcher
  Widget _buildProgressShowcaseLauncherButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B0FF), Color(0xFF00E676)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3300B0FF),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProgressBarShowcaseScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Material 4 Progress Bar Studio',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '11 Presets: 48+ Styles, Linear, Rings, Waves, Fluid & Equalizer',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 9d. Dynamic Animated Wave Line Studio Launcher
  Widget _buildWaveLineShowcaseLauncherButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF00E5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x336366F1),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WaveLineShowcaseScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.waves_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Material 4 Wave & Zigzag Line Studio',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '35 Styles: Zigzags, Organic Waves, ECG Pulse, DNA Helix & Neon',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 10. Interactive Shape Playground Launcher
  Widget _buildInteractiveShapePlaygroundButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1F5E43EE), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A5E43EE),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showShapePlayground(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEADBFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_mosaic_rounded,
                    color: Color(0xFF5E43EE),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Material 4 & Texture Studio',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E1E24),
                        ),
                      ),
                      Text(
                        '13 shapes, 7 borders, 5 patterns, glass & inner shadows',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7A7A85),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF7A7A85),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 11. Creative & Tactile Studio Launcher (Phase 7.1)
  Widget _buildCreativeShowcaseButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x338D6E63), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreativeShowcaseScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECC8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.palette_rounded,
                    color: Color(0xFF8D6E63),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Creative & Tactile Studio',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E1E24),
                        ),
                      ),
                      Text(
                        'Torn paper, notebook rulings, sculpted cards & neumorphism',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7A7A85),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF7A7A85),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarShowcaseButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x335E43EE), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AppBarShowcaseScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E43EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.view_agenda_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adaptive AppBar Studio',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E1E24),
                        ),
                      ),
                      Text(
                        'Reverse-scroll floating compact header, drawer, profile & shapes',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7A7A85),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF7A7A85),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showShapePlayground(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ShapePlaygroundModal(),
    );
  }
}

/// Interactive Modal demonstrating all 13 shapes, 7 border styles, and 5 pattern textures live.
class _ShapePlaygroundModal extends StatefulWidget {
  const _ShapePlaygroundModal();

  @override
  State<_ShapePlaygroundModal> createState() => _ShapePlaygroundModalState();
}

class _ShapePlaygroundModalState extends State<_ShapePlaygroundModal> {
  Material4Type _selectedType = Material4Type.folderTab;
  BorderStyleType _selectedBorder = BorderStyleType.solid;
  ShapePattern _selectedPattern = ShapePattern.none;
  ShapeAnchor _selectedAnchor = ShapeAnchor.topRight;
  bool _enableInnerShadow = false;
  bool _enableGlassmorphic = false;
  double _cornerRadius = 24.0;
  double _tabWidth = 80.0;
  double _tabHeight = 24.0;
  double _dashLength = 7.0;
  double _dashGap = 4.0;
  Color _cardColor = const Color(0xFFD6F5E3);
  Color _borderColor = const Color(0xFF2A2A2A);

  @override
  Widget build(BuildContext context) {
    final config = Material4Config(
      type: _selectedType,
      borderStyle: _selectedBorder,
      anchor: _selectedAnchor,
      pattern: _selectedPattern,
      isGlassmorphic: _enableGlassmorphic,
      innerShadows: _enableInnerShadow
          ? const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 8,
                offset: Offset(2, 3),
              ),
              BoxShadow(
                color: Color(0x66FFFFFF),
                blurRadius: 6,
                offset: Offset(-2, -2),
              ),
            ]
          : null,
      cornerRadius: _cornerRadius,
      tabWidth: _tabWidth,
      tabHeight: _tabHeight,
      dashLength: _dashLength,
      dashGap: _dashGap,
      borderGradient: const LinearGradient(
        colors: [Color(0xFF5E43EE), Color(0xFFFF5252), Color(0xFFFFB300)],
      ),
      glowColor: const Color(0xFF5E43EE),
      neoColor: const Color(0xFF1E1E24),
      neoOffset: const Offset(4, 4),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.86,
      decoration: const BoxDecoration(
        color: Color(0xFFF7F5F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0x33000000),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Material 4 & Texture Studio',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E1E24),
            ),
          ),
          Text(
            'Any shape, texture, glassmorphism, or border with zero repetitive code.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6A6A75),
            ),
          ),
          const SizedBox(height: 16),

          // LIVE INTERACTIVE PREVIEW CONTAINER
          Center(
            child: Material4Container(
              width: double.infinity,
              height: 130,
              config: config,
              color: _cardColor,
              borderColor: _borderColor,
              borderWidth: _selectedBorder == BorderStyleType.neo3d ? 2.0 : 1.4,
              padding: const EdgeInsets.all(18),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_selectedType.name.toUpperCase()} • ${_selectedBorder.name.toUpperCase()}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: const Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedPattern != ShapePattern.none
                            ? 'Pattern: ${_selectedPattern.name}'
                            : 'Dynamically adapts to content geometry',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4A4A55),
                        ),
                      ),
                    ],
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF333333),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Controls & Selector Tabs
          Expanded(
            child: ListView(
              children: [
                // 1. Unique Border Styles
                Text(
                  'Border Style (7 Styles):',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: BorderStyleType.values.map((border) {
                    final isSelected = _selectedBorder == border;
                    return ChoiceChip(
                      label: Text(border.name),
                      selected: isSelected,
                      selectedColor: const Color(0xFF5E43EE),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedBorder = border);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // 2. Background Texture Patterns
                Text(
                  'Background Pattern Fill (5 Patterns):',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: ShapePattern.values.map((pat) {
                    final isSelected = _selectedPattern == pat;
                    return ChoiceChip(
                      label: Text(pat.name),
                      selected: isSelected,
                      selectedColor: const Color(0xFF2E7D32),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedPattern = pat);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // 3. Tactile Features: Inner Shadow & Glassmorphic
                Row(
                  children: [
                    Expanded(
                      child: FilterChip(
                        label: const Text('Inner Inset Shadow'),
                        selected: _enableInnerShadow,
                        selectedColor: const Color(0xFFEADBFF),
                        onSelected: (val) {
                          setState(() => _enableInnerShadow = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilterChip(
                        label: const Text('Glassmorphism'),
                        selected: _enableGlassmorphic,
                        selectedColor: const Color(0xFFD0E8FF),
                        onSelected: (val) {
                          setState(() => _enableGlassmorphic = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 4. Material 4 Presets
                Text(
                  'Select Shape Type (28 Presets):',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: Material4Type.values.map((type) {
                    final isSelected = _selectedType == type;
                    return ChoiceChip(
                      label: Text(type.name),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1E1E24),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedType = type;
                            switch (type) {
                              case Material4Type.folderTab:
                                _cardColor = const Color(0xFFD6F5E3);
                                _borderColor = const Color(0xFF285E3B);
                                break;
                              case Material4Type.notchedBadge:
                                _cardColor = const Color(0xFFF9F7F2);
                                _borderColor = const Color(0xFF2A2A2A);
                                break;
                              case Material4Type.sideTab:
                                _cardColor = const Color(0xFFEADBFF);
                                _borderColor = const Color(0xFF563583);
                                break;
                              case Material4Type.steppedCorner:
                                _cardColor = const Color(0xFFFFDFD3);
                                _borderColor = const Color(0xFF8B4D36);
                                break;
                              case Material4Type.ticketScallop:
                                _cardColor = const Color(0xFFFAF9F6);
                                _borderColor = const Color(0xFF333333);
                                break;
                              case Material4Type.postageStamp:
                                _cardColor = const Color(0xFFFFF0F5);
                                _borderColor = const Color(0xFF9C27B0);
                                break;
                              case Material4Type.zigzagCut:
                                _cardColor = const Color(0xFFF0F7FF);
                                _borderColor = const Color(0xFF1976D2);
                                break;
                              case Material4Type.arch:
                                _cardColor = const Color(0xFFFFF9EE);
                                _borderColor = const Color(0xFFB58416);
                                break;
                              case Material4Type.hexagonSoft:
                                _cardColor = const Color(0xFFE0F7FA);
                                _borderColor = const Color(0xFF00838F);
                                break;
                              case Material4Type.chamferDiagonal:
                                _cardColor = const Color(0xFFFBE9E7);
                                _borderColor = const Color(0xFFD84315);
                                break;
                              case Material4Type.organicBlob:
                                _cardColor = const Color(0xFFF3E5F5);
                                _borderColor = const Color(0xFF6A1B9A);
                                break;
                              case Material4Type.scallopedPetal:
                                _cardColor = const Color(0xFFFFE0EC);
                                _borderColor = const Color(0xFFAD1457);
                                break;
                              case Material4Type.smoothRounded:
                                _cardColor = const Color(0xFFD3E9FD);
                                _borderColor = const Color(0xFF1565C0);
                                break;
                              case Material4Type.asymmetricCard:
                                _cardColor = const Color(0xFFE8F5E9);
                                _borderColor = const Color(0xFF388E3C);
                                break;
                              case Material4Type.capsule:
                                _cardColor = const Color(0xFFEDE7F6);
                                _borderColor = const Color(0xFF512DA8);
                                break;
                              case Material4Type.waveEdge:
                                _cardColor = const Color(0xFFE1F5FE);
                                _borderColor = const Color(0xFF0288D1);
                                break;
                              case Material4Type.cloud:
                                _cardColor = const Color(0xFFF1F8E9);
                                _borderColor = const Color(0xFF689F38);
                                break;
                              case Material4Type.speechBubble:
                                _cardColor = const Color(0xFFFFF8E1);
                                _borderColor = const Color(0xFFFFA000);
                                break;
                              case Material4Type.shield:
                                _cardColor = const Color(0xFFFCE4EC);
                                _borderColor = const Color(0xFFC2185B);
                                break;
                              case Material4Type.diamond:
                                _cardColor = const Color(0xFFE0F2F1);
                                _borderColor = const Color(0xFF00796B);
                                break;
                              case Material4Type.octagon:
                                _cardColor = const Color(0xFFEFEBE9);
                                _borderColor = const Color(0xFF5D4037);
                                break;
                              case Material4Type.waveCut:
                                _cardColor = const Color(0xFFE8EAF6);
                                _borderColor = const Color(0xFF3949AB);
                                break;
                              case Material4Type.concaveRounded:
                                _cardColor = const Color(0xFFFFF3E0);
                                _borderColor = const Color(0xFFF57C00);
                                break;
                              case Material4Type.convexRounded:
                                _cardColor = const Color(0xFFF9FBE7);
                                _borderColor = const Color(0xFFAFB42B);
                                break;
                              case Material4Type.squircle:
                                _cardColor = const Color(0xFFEDE7F6);
                                _borderColor = const Color(0xFF673AB7);
                                break;
                              case Material4Type.parallelogram:
                                _cardColor = const Color(0xFFE0F7FA);
                                _borderColor = const Color(0xFF0097A7);
                                break;
                              case Material4Type.ribbon:
                                _cardColor = const Color(0xFFFFEBEE);
                                _borderColor = const Color(0xFFD32F2F);
                                break;
                              case Material4Type.bookmark:
                                _cardColor = const Color(0xFFE8F5E9);
                                _borderColor = const Color(0xFF2E7D32);
                                break;
                              case Material4Type.customBezier:
                                _cardColor = const Color(0xFFF3E5F5);
                                _borderColor = const Color(0xFF7B1FA2);
                                break;
                            }
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Corner Radius Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Corner Radius: ${_cornerRadius.toInt()}px',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _cornerRadius,
                        min: 10,
                        max: 40,
                        activeColor: const Color(0xFF5E43EE),
                        onChanged: (val) => setState(() => _cornerRadius = val),
                      ),
                    ),
                  ],
                ),

                // Tab / Notch Width Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tab/Feature Width: ${_tabWidth.toInt()}px',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _tabWidth,
                        min: 30,
                        max: 140,
                        activeColor: const Color(0xFF5E43EE),
                        onChanged: (val) => setState(() => _tabWidth = val),
                      ),
                    ),
                  ],
                ),

                // Tab / Notch Height Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tab/Feature Height: ${_tabHeight.toInt()}px',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _tabHeight,
                        min: 10,
                        max: 60,
                        activeColor: const Color(0xFF5E43EE),
                        onChanged: (val) => setState(() => _tabHeight = val),
                      ),
                    ),
                  ],
                ),

                // Dash Length & Gap Sliders (when Dashed)
                if (_selectedBorder == BorderStyleType.dashed) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dash Length: ${_dashLength.toInt()}px',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _dashLength,
                          min: 3,
                          max: 20,
                          activeColor: const Color(0xFF5E43EE),
                          onChanged: (val) => setState(() => _dashLength = val),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dash Gap: ${_dashGap.toInt()}px',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _dashGap,
                          min: 2,
                          max: 12,
                          activeColor: const Color(0xFF5E43EE),
                          onChanged: (val) => setState(() => _dashGap = val),
                        ),
                      ),
                    ],
                  ),
                ],

                // Anchor Selector
                Text(
                  'Anchor Position:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    ShapeAnchor.topRight,
                    ShapeAnchor.topLeft,
                    ShapeAnchor.bottomRight,
                    ShapeAnchor.bottomLeft,
                  ].map((anchor) {
                    final isSelected = _selectedAnchor == anchor;
                    return ChoiceChip(
                      label: Text(anchor.name),
                      selected: isSelected,
                      selectedColor: const Color(0xFF5E43EE),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 11,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedAnchor = anchor);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
