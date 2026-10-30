import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_4/material_4.dart';

/// Complete showcase screen and gallery for the Material 4 Dynamic Profile Avatar System.
///
/// Demonstrates all 13 required avatar variants:
/// 1. Basic Circle Avatar
/// 2. Squircle Avatar
/// 3. Organic Avatar
/// 4. Asymmetric Avatar
/// 5. Blob Avatar
/// 6. Hexagon Avatar
/// 7. Gradient Border Avatar
/// 8. Online Status Avatar
/// 9. Verified Badge Avatar
/// 10. Animated Avatar (Shape Morphing)
/// 11. Initials Avatar (Deterministic Backgrounds)
/// 12. Group Avatar (Overlapping Layout)
/// 13. Custom Shape Avatar (Flower, Shield, Ticket, Star)
/// 14. Automatic Infinite Shape Morphing
/// 15. Programmatic Controller Studio
/// 16. Living Avatar Studio (Breathing, Floating & Glow)
/// 17. Morphing & Living Group Avatar
///
/// Each item includes a live interactive preview and a viewable/copyable code snippet.
class AvatarShowcaseScreen extends StatefulWidget {
  /// When true, renders without a [Scaffold] and [AppBar] for embedding in tabs.
  final bool isEmbedded;

  const AvatarShowcaseScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<AvatarShowcaseScreen> createState() => _AvatarShowcaseScreenState();
}

class _AvatarShowcaseScreenState extends State<AvatarShowcaseScreen> {
  // Category filter state
  String _selectedCategory = 'All';
  final List<String> _categories = const [
    'All',
    'Basic Shapes',
    'Organic Shapes',
    'Creative Shapes',
    'Status & Badges',
    'Morphing & Groups',
  ];

  // Interactive state for #10 Animated Morphing Avatar
  int _morphStep = 0;
  final List<(String, Material4AvatarShape)> _morphShapes = [
    ('Circle', Material4AvatarShape.circle()),
    ('Squircle', Material4AvatarShape.squircle(smoothness: 0.85)),
    ('Flower', Material4AvatarShape.flower(petals: 8)),
    ('Hexagon', Material4AvatarShape.hexagon(cornerRadius: 10)),
    ('Shield', Material4AvatarShape.shield()),
    ('Organic Blob', Material4AvatarShape.organicBlob(seed: 42)),
  ];

  // Interactive state for #12 Group Avatar
  int _groupVisibleCount = 4;
  final double _groupSpacing = -14.0;

  // Interactive state for #14 Infinite Morphing
  Material4AvatarAnimationPreset _infinitePreset =
      Material4AvatarAnimationPreset.organicFlow;

  // Controller and options for #15 Programmatic Controller Studio
  late final Material4AvatarController _programmaticController;
  final List<(String, Material4AvatarShape)> _controllerShapeOptions = [
    ('Circle', Material4AvatarShape.circle()),
    ('Squircle', Material4AvatarShape.squircle(smoothness: 0.85)),
    ('Organic Blob', Material4AvatarShape.organicBlob(seed: 42)),
    ('Hexagon', Material4AvatarShape.hexagon(cornerRadius: 10)),
    ('Shield', Material4AvatarShape.shield()),
  ];

  // Interactive state for #16 Living Avatar Studio
  bool _livingBreathing = true;
  bool _livingFloating = true;
  bool _livingRotatingBorder = true;
  bool _livingGrayscale = false;
  bool _livingGlow = true;

  @override
  void initState() {
    super.initState();
    _programmaticController = Material4AvatarController();
  }

  @override
  void dispose() {
    _programmaticController.dispose();
    super.dispose();
  }

  void _nextMorphStep() {
    setState(() {
      _morphStep = (_morphStep + 1) % _morphShapes.length;
    });
  }

  void _copyToClipboard(BuildContext context, String code, String title) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Copied code snippet for "$title" to clipboard!',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      children: [
        _buildHeroBanner(),
        const SizedBox(height: 18),
        _buildCategoryFilterChips(),
        const SizedBox(height: 20),

        // 1. Basic Circle Avatar
        if (_matchesFilter('Basic Shapes')) ...[
          _buildAvatarShowcaseCard(
            index: '01',
            title: 'Basic Circle Avatar',
            subtitle:
                'Standard circular avatar with solid border and soft shadow.',
            tag: 'BASIC',
            tagColor: const Color(0xFF5E43EE),
            avatar: Material4Avatar.initials(
              initials: 'SC',
              size: 68,
              shape: Material4AvatarShape.circle(),
              border: const Material4AvatarBorder.solid(
                color: Color(0xFF5E43EE),
                width: 2.5,
              ),
              backgroundColor: const Color(0xFF5E43EE),
              textColor: Colors.white,
              onTap: () => _notifyTap('Circle Avatar'),
            ),
            codeSnippet: '''Material4Avatar.initials(
  initials: 'SC',
  size: 68,
  shape: Material4AvatarShape.circle(),
  backgroundColor: const Color(0xFF5E43EE),
  textColor: Colors.white,
  border: const Material4AvatarBorder.solid(
    color: Color(0xFF5E43EE),
    width: 2.5,
  ),
  onTap: () => print('Tapped Circle Avatar'),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 2. Squircle Avatar
        if (_matchesFilter('Basic Shapes')) ...[
          _buildAvatarShowcaseCard(
            index: '02',
            title: 'Squircle Avatar',
            subtitle:
                'G2 continuous superellipse curvature for iOS-style polish.',
            tag: 'BASIC',
            tagColor: const Color(0xFF00897B),
            avatar: Material4Avatar.initials(
              initials: 'SQ',
              size: 68,
              shape: Material4AvatarShape.squircle(smoothness: 0.82),
              border: const Material4AvatarBorder.solid(
                color: Color(0xFF26A69A),
                width: 2.0,
              ),
              backgroundColor: const Color(0xFF00695C),
              textColor: Colors.white,
              onTap: () => _notifyTap('Squircle Avatar'),
            ),
            codeSnippet: '''Material4Avatar.initials(
  initials: 'SQ',
  size: 68,
  shape: Material4AvatarShape.squircle(smoothness: 0.82),
  backgroundColor: const Color(0xFF00695C),
  textColor: Colors.white,
  border: const Material4AvatarBorder.solid(
    color: Color(0xFF26A69A),
    width: 2.0,
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 3. Organic Avatar
        if (_matchesFilter('Organic Shapes')) ...[
          _buildAvatarShowcaseCard(
            index: '03',
            title: 'Organic Avatar',
            subtitle: 'Procedurally generated multi-curve blob silhouette.',
            tag: 'ORGANIC',
            tagColor: const Color(0xFFE65100),
            avatar: Material4Avatar.initials(
              initials: 'OA',
              size: 68,
              shape: Material4AvatarShape.organicBlob(seed: 42),
              border: const Material4AvatarBorder.sculpted(
                highlightColor: Color(0xFFFFB74D),
                shadowColor: Color(0xFFBF360C),
                width: 2.5,
              ),
              backgroundColor: const Color(0xFFE65100),
              textColor: Colors.white,
              onTap: () => _notifyTap('Organic Blob Avatar'),
            ),
            codeSnippet: '''Material4Avatar.initials(
  initials: 'OA',
  size: 68,
  shape: Material4AvatarShape.organicBlob(seed: 42),
  backgroundColor: const Color(0xFFE65100),
  textColor: Colors.white,
  border: const Material4AvatarBorder.sculpted(
    highlightColor: Color(0xFFFFB74D),
    shadowColor: Color(0xFFBF360C),
    width: 2.5,
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 4. Asymmetric Avatar
        if (_matchesFilter('Organic Shapes')) ...[
          _buildAvatarShowcaseCard(
            index: '04',
            title: 'Asymmetric Avatar',
            subtitle:
                'Different corner radii creating an organic sculpt silhouette.',
            tag: 'ORGANIC',
            tagColor: const Color(0xFF8E24AA),
            avatar: Material4Avatar.initials(
              initials: 'AR',
              size: 68,
              shape: Material4AvatarShape.asymmetricRounded(
                rTL: 36,
                rTR: 10,
                rBR: 36,
                rBL: 10,
              ),
              border: const Material4AvatarBorder.solid(
                color: Color(0xFFBA68C8),
                width: 2.0,
              ),
              backgroundColor: const Color(0xFF6A1B9A),
              textColor: Colors.white,
              onTap: () => _notifyTap('Asymmetric Rounded Avatar'),
            ),
            codeSnippet: '''Material4Avatar.initials(
  initials: 'AR',
  size: 68,
  shape: Material4AvatarShape.asymmetricRounded(
    rTL: 36,
    rTR: 10,
    rBR: 36,
    rBL: 10,
  ),
  backgroundColor: const Color(0xFF6A1B9A),
  textColor: Colors.white,
  border: const Material4AvatarBorder.solid(
    color: Color(0xFFBA68C8),
    width: 2.0,
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 5. Blob Avatar
        if (_matchesFilter('Organic Shapes')) ...[
          _buildAvatarShowcaseCard(
            index: '05',
            title: 'Blob Avatar',
            subtitle:
                'Smooth irregular cubic curve contour with a glowing aura.',
            tag: 'ORGANIC',
            tagColor: const Color(0xFF0277BD),
            avatar: Material4Avatar.initials(
              initials: 'BL',
              size: 68,
              shape: Material4AvatarShape.irregularCurve(),
              border: const Material4AvatarBorder.glow(
                color: Color(0xFF00E5FF),
                width: 2.0,
                glowRadius: 8.0,
              ),
              backgroundColor: const Color(0xFF01579B),
              textColor: Colors.white,
              onTap: () => _notifyTap('Irregular Curve Blob Avatar'),
            ),
            codeSnippet: '''Material4Avatar.initials(
  initials: 'BL',
  size: 68,
  shape: Material4AvatarShape.irregularCurve(),
  backgroundColor: const Color(0xFF01579B),
  textColor: Colors.white,
  border: const Material4AvatarBorder.glow(
    color: Color(0xFF00E5FF),
    width: 2.0,
    glowRadius: 8.0,
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 6. Hexagon Avatar
        if (_matchesFilter('Basic Shapes')) ...[
          _buildAvatarShowcaseCard(
            index: '06',
            title: 'Hexagon Avatar',
            subtitle:
                '6-vertex geometric polygon with rounded corners and dashed border.',
            tag: 'GEOMETRIC',
            tagColor: const Color(0xFF2E7D32),
            avatar: Material4Avatar.initials(
              initials: 'HX',
              size: 68,
              shape: Material4AvatarShape.hexagon(cornerRadius: 12),
              border: const Material4AvatarBorder.dashed(
                color: Color(0xFF66BB6A),
                width: 2.0,
                dashLength: 6,
                dashGap: 4,
              ),
              backgroundColor: const Color(0xFF1B5E20),
              textColor: Colors.white,
              onTap: () => _notifyTap('Hexagon Avatar'),
            ),
            codeSnippet: '''Material4Avatar.initials(
  initials: 'HX',
  size: 68,
  shape: Material4AvatarShape.hexagon(cornerRadius: 12),
  backgroundColor: const Color(0xFF1B5E20),
  textColor: Colors.white,
  border: const Material4AvatarBorder.dashed(
    color: Color(0xFF66BB6A),
    width: 2.0,
    dashLength: 6.0,
    dashGap: 4.0,
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 7. Gradient Border Avatar
        if (_matchesFilter('Status & Badges') ||
            _matchesFilter('Basic Shapes')) ...[
          _buildAvatarShowcaseCard(
            index: '07',
            title: 'Gradient Border Avatar',
            subtitle:
                'Multicolor linear gradient border hugging the exact shape vector.',
            tag: 'BORDER',
            tagColor: const Color(0xFFFF007A),
            avatar: Material4Avatar.initials(
              initials: 'GB',
              size: 68,
              shape: Material4AvatarShape.squircle(),
              border: const Material4AvatarBorder.gradient(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF007A),
                    Color(0xFF7928CA),
                    Color(0xFF0070F3),
                  ],
                ),
                width: 3.5,
                offset: AvatarBorderOffset.outer,
              ),
              backgroundColor: const Color(0xFF111827),
              textColor: Colors.white,
              onTap: () => _notifyTap('Gradient Border Avatar'),
            ),
            codeSnippet: '''Material4Avatar.initials(
  initials: 'GB',
  size: 68,
  shape: Material4AvatarShape.squircle(),
  backgroundColor: const Color(0xFF111827),
  textColor: Colors.white,
  border: const Material4AvatarBorder.gradient(
    gradient: LinearGradient(
      colors: [Color(0xFFFF007A), Color(0xFF7928CA), Color(0xFF0070F3)],
    ),
    width: 3.5,
    offset: AvatarBorderOffset.outer,
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 8. Online Status Avatar
        if (_matchesFilter('Status & Badges')) ...[
          _buildAvatarShowcaseCard(
            index: '08',
            title: 'Online Status Avatar',
            subtitle:
                'Real-time presence indicator with pulsing animated radar halo.',
            tag: 'STATUS',
            tagColor: const Color(0xFF4CAF50),
            avatar: Material4Avatar.initials(
              initials: 'ON',
              size: 68,
              shape: Material4AvatarShape.circle(),
              status: Material4AvatarStatus.online(
                pulse: true,
                size: 16,
                position: AvatarStatusPosition.bottomRight,
              ),
              backgroundColor: const Color(0xFF2E7D32),
              textColor: Colors.white,
              onTap: () => _notifyTap('Online Status Avatar'),
            ),
            codeSnippet: '''Material4Avatar.initials(
  initials: 'ON',
  size: 68,
  shape: Material4AvatarShape.circle(),
  backgroundColor: const Color(0xFF2E7D32),
  textColor: Colors.white,
  status: Material4AvatarStatus.online(
    pulse: true,
    size: 16.0,
    position: AvatarStatusPosition.bottomRight,
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 9. Verified Badge Avatar
        if (_matchesFilter('Status & Badges')) ...[
          _buildAvatarShowcaseCard(
            index: '09',
            title: 'Verified Badge Avatar',
            subtitle:
                'Official verification checkmark badge placed along shape boundary.',
            tag: 'BADGE',
            tagColor: const Color(0xFF1DA1F2),
            avatar: Material4Avatar.initials(
              initials: 'VB',
              size: 68,
              shape: Material4AvatarShape.softSculpted(),
              badge: const Material4AvatarBadge.verified(
                size: 22,
                color: Color(0xFF1DA1F2),
              ),
              backgroundColor: const Color(0xFF0D47A1),
              textColor: Colors.white,
              onTap: () => _notifyTap('Verified Badge Avatar'),
            ),
            codeSnippet: '''Material4Avatar.initials(
  initials: 'VB',
  size: 68,
  shape: Material4AvatarShape.softSculpted(),
  backgroundColor: const Color(0xFF0D47A1),
  textColor: Colors.white,
  badge: const Material4AvatarBadge.verified(
    size: 22.0,
    color: Color(0xFF1DA1F2),
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 10. Animated Avatar (Morphing)
        if (_matchesFilter('Morphing & Groups')) ...[
          _buildAvatarShowcaseCard(
            index: '10',
            title: 'Animated Avatar (Shape Morphing)',
            subtitle:
                'Interactive Bézier shape interpolation. Tap the avatar to morph!',
            tag: 'ANIMATION',
            tagColor: const Color(0xFFE91E63),
            avatar: Column(
              children: [
                AnimatedMaterial4Avatar(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubicEmphasized,
                  shape: _morphShapes[_morphStep].$2,
                  size: 72,
                  initials: 'AM',
                  backgroundColor: const Color(0xFF5E43EE),
                  border: const Material4AvatarBorder.solid(
                    color: Color(0xFF8C7AE6),
                    width: 2.5,
                  ),
                  onTap: _nextMorphStep,
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _nextMorphStep,
                  icon: const Icon(Icons.sync_rounded, size: 16),
                  label: Text(
                      'Shape: ${_morphShapes[_morphStep].$1} (Tap to Morph)'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF5E43EE),
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ),
              ],
            ),
            codeSnippet: '''AnimatedMaterial4Avatar(
  duration: const Duration(milliseconds: 500),
  curve: Curves.easeInOutCubicEmphasized,
  shape: currentShape, // Morphs between circle, squircle, flower, etc.
  size: 72,
  initials: 'AM',
  backgroundColor: const Color(0xFF5E43EE),
  border: const Material4AvatarBorder.solid(
    color: Color(0xFF8C7AE6),
    width: 2.5,
  ),
  onTap: () => setState(() => nextShape()),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 11. Initials Avatar (Deterministic Backgrounds)
        if (_matchesFilter('Status & Badges') ||
            _matchesFilter('Basic Shapes')) ...[
          _buildAvatarShowcaseCard(
            index: '11',
            title: 'Initials Avatar (Deterministic Palettes)',
            subtitle:
                'Auto-computes high-contrast deterministic branding from user name.',
            tag: 'FALLBACK',
            tagColor: const Color(0xFF795548),
            avatar: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                Material4Avatar.initials(
                  initials: 'JD',
                  size: 52,
                  shape: Material4AvatarShape.diamond(cornerRadius: 10),
                  onTap: () => _notifyTap('John Doe'),
                ),
                Material4Avatar.initials(
                  initials: 'EM',
                  size: 52,
                  shape: Material4AvatarShape.capsule(),
                  onTap: () => _notifyTap('Elon Musk'),
                ),
                Material4Avatar.initials(
                  initials: 'AW',
                  size: 52,
                  shape: Material4AvatarShape.oval(),
                  onTap: () => _notifyTap('Alan Walker'),
                ),
                Material4Avatar.initials(
                  initials: 'ZT',
                  size: 52,
                  shape: Material4AvatarShape.octagon(cornerRadius: 8),
                  onTap: () => _notifyTap('Zack Taylor'),
                ),
              ],
            ),
            codeSnippet:
                '''// Deterministic background color automatically derived from initials checksum:
Material4Avatar.initials(
  initials: 'JD',
  size: 52,
  shape: Material4AvatarShape.diamond(cornerRadius: 10),
  onTap: () => print('John Doe tapped'),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 12. Group Avatar
        if (_matchesFilter('Morphing & Groups')) ...[
          _buildAvatarShowcaseCard(
            index: '12',
            title: 'Group Avatar (Overlapping Stack)',
            subtitle:
                'Dynamic horizontal stacking with negative spacing & overflow count.',
            tag: 'GROUP',
            tagColor: const Color(0xFF673AB7),
            avatar: Column(
              children: [
                Material4AvatarGroup(
                  size: 48,
                  spacing: _groupSpacing,
                  maxVisible: _groupVisibleCount,
                  stackOrder: AvatarStackOrder.lastOnTop,
                  avatars: [
                    Material4Avatar.initials(
                      initials: 'AL',
                      shape: Material4AvatarShape.squircle(),
                      backgroundColor: const Color(0xFF5E43EE),
                      textColor: Colors.white,
                    ),
                    Material4Avatar.initials(
                      initials: 'BK',
                      shape: Material4AvatarShape.squircle(),
                      backgroundColor: const Color(0xFF00897B),
                      textColor: Colors.white,
                    ),
                    Material4Avatar.initials(
                      initials: 'CR',
                      shape: Material4AvatarShape.squircle(),
                      backgroundColor: const Color(0xFFE65100),
                      textColor: Colors.white,
                    ),
                    Material4Avatar.initials(
                      initials: 'DN',
                      shape: Material4AvatarShape.squircle(),
                      backgroundColor: const Color(0xFF8E24AA),
                      textColor: Colors.white,
                    ),
                    Material4Avatar.initials(
                      initials: 'EO',
                      shape: Material4AvatarShape.squircle(),
                      backgroundColor: const Color(0xFF0277BD),
                      textColor: Colors.white,
                    ),
                    Material4Avatar.initials(
                      initials: 'FP',
                      shape: Material4AvatarShape.squircle(),
                      backgroundColor: const Color(0xFF2E7D32),
                      textColor: Colors.white,
                    ),
                  ],
                  onOverflowTap: () => _notifyTap('Remaining Members (+2)'),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Visible: $_groupVisibleCount',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                      onPressed: _groupVisibleCount > 2
                          ? () => setState(() => _groupVisibleCount--)
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      onPressed: _groupVisibleCount < 5
                          ? () => setState(() => _groupVisibleCount++)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
            codeSnippet: '''Material4AvatarGroup(
  size: 48,
  spacing: -14.0,
  maxVisible: 4,
  stackOrder: AvatarStackOrder.lastOnTop,
  avatars: [
    Material4Avatar.initials(initials: 'AL', shape: Material4AvatarShape.squircle()),
    Material4Avatar.initials(initials: 'BK', shape: Material4AvatarShape.squircle()),
    Material4Avatar.initials(initials: 'CR', shape: Material4AvatarShape.squircle()),
    Material4Avatar.initials(initials: 'DN', shape: Material4AvatarShape.squircle()),
    Material4Avatar.initials(initials: 'EO', shape: Material4AvatarShape.squircle()),
  ],
  onOverflowTap: () => print('Show all group members'),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 13. Custom Shape Avatar (Flower, Shield, Ticket, Star)
        if (_matchesFilter('Creative Shapes')) ...[
          _buildAvatarShowcaseCard(
            index: '13',
            title: 'Custom Shape Avatar Collection',
            subtitle:
                'Creative architectural silhouettes: Flower, Shield, Ticket, and Star.',
            tag: 'CREATIVE',
            tagColor: const Color(0xFFD81B60),
            avatar: Wrap(
              spacing: 14,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material4Avatar.initials(
                      initials: 'FL',
                      size: 56,
                      shape: Material4AvatarShape.flower(petals: 8),
                      backgroundColor: const Color(0xFFF06292),
                      textColor: Colors.white,
                      border: const Material4AvatarBorder.solid(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      onTap: () => _notifyTap('Flower Avatar (8 Petals)'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Flower',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material4Avatar.icon(
                      icon: Icons.security_rounded,
                      size: 56,
                      shape: Material4AvatarShape.shield(),
                      backgroundColor: const Color(0xFF3949AB),
                      iconColor: Colors.white,
                      badge: const Material4AvatarBadge.admin(size: 18),
                      onTap: () => _notifyTap('Shield Avatar'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Shield',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material4Avatar.initials(
                      initials: 'TK',
                      size: 56,
                      shape: Material4AvatarShape.ticket(),
                      backgroundColor: const Color(0xFF00ACC1),
                      textColor: Colors.white,
                      onTap: () => _notifyTap('Ticket Scallop Avatar'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ticket',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material4Avatar.initials(
                      initials: 'ST',
                      size: 56,
                      shape: Material4AvatarShape.star(points: 5),
                      backgroundColor: const Color(0xFFFB8C00),
                      textColor: Colors.white,
                      badge: const Material4AvatarBadge.premium(size: 18),
                      onTap: () => _notifyTap('5-Point Star Avatar'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Star',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            codeSnippet: '''// Flower Avatar
Material4Avatar.initials(
  initials: 'FL',
  size: 56,
  shape: Material4AvatarShape.flower(petals: 8),
  backgroundColor: const Color(0xFFF06292),
  textColor: Colors.white,
  border: const Material4AvatarBorder.solid(color: Colors.white, width: 2.0),
)

// Shield Avatar with Admin Badge
Material4Avatar.icon(
  icon: Icons.security_rounded,
  size: 56,
  shape: Material4AvatarShape.shield(),
  backgroundColor: const Color(0xFF3949AB),
  badge: const Material4AvatarBadge.admin(size: 18),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 14. Automatic Infinite Shape Morphing
        if (_matchesFilter('Morphing & Groups')) ...[
          _buildAvatarShowcaseCard(
            index: '14',
            title: 'Automatic Infinite Shape Morphing',
            subtitle:
                'Phase-aligned Bézier interpolation looping through arbitrary shapes.',
            tag: 'INFINITE MORPH',
            tagColor: const Color(0xFF6200EE),
            avatar: Column(
              children: [
                Material4Avatar.animated(
                  key: ValueKey(_infinitePreset),
                  shapes: [
                    Material4AvatarShape.circle(),
                    Material4AvatarShape.squircle(smoothness: 0.85),
                    Material4AvatarShape.organicBlob(seed: 42),
                    Material4AvatarShape.hexagon(cornerRadius: 10),
                    Material4AvatarShape.shield(),
                    Material4AvatarShape.circle(),
                  ],
                  animation: Material4AvatarAnimation(
                    autoStart: true,
                    duration: const Duration(milliseconds: 1400),
                    holdDuration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOutCubic,
                    preset: _infinitePreset,
                  ),
                  size: 76,
                  initials: 'IM',
                  backgroundColor: const Color(0xFF6200EE),
                  border: const Material4AvatarBorder.gradient(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
                    ),
                    width: 3.0,
                  ),
                  effects: const Material4AvatarEffects(
                    ambientGlow: true,
                    glowColor: Color(0x557C4DFF),
                    glowRadius: 10.0,
                  ),
                  onTap: () => _notifyTap('Infinite Morph Avatar'),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    Material4AvatarAnimationPreset.organicFlow,
                    Material4AvatarAnimationPreset.smoothMorph,
                    Material4AvatarAnimationPreset.softBounce,
                    Material4AvatarAnimationPreset.pulseMorph,
                  ].map((preset) {
                    final isSelected = _infinitePreset == preset;
                    return ChoiceChip(
                      label: Text(
                        preset.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFFEDE7F6),
                      onSelected: (_) {
                        setState(() => _infinitePreset = preset);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            codeSnippet: '''Material4Avatar.animated(
  shapes: [
    Material4AvatarShape.circle(),
    Material4AvatarShape.squircle(smoothness: 0.85),
    Material4AvatarShape.organicBlob(seed: 42),
    Material4AvatarShape.hexagon(cornerRadius: 10),
    Material4AvatarShape.shield(),
    Material4AvatarShape.circle(),
  ],
  animation: const Material4AvatarAnimation(
    autoStart: true,
    duration: Duration(milliseconds: 1400),
    holdDuration: Duration(milliseconds: 600),
    curve: Curves.easeInOutCubic,
    preset: Material4AvatarAnimationPreset.organicFlow,
  ),
  size: 76,
  initials: 'IM',
  backgroundColor: const Color(0xFF6200EE),
  border: const Material4AvatarBorder.gradient(
    gradient: LinearGradient(colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)]),
    width: 3.0,
  ),
  effects: const Material4AvatarEffects(
    ambientGlow: true,
    glowColor: Color(0x557C4DFF),
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 15. Programmatic Controller Studio
        if (_matchesFilter('Morphing & Groups')) ...[
          _buildAvatarShowcaseCard(
            index: '15',
            title: 'Programmatic Controller Studio',
            subtitle:
                'External control: play, pause, step forward/back, and animateTo.',
            tag: 'CONTROLLER',
            tagColor: const Color(0xFF00897B),
            avatar: AnimatedBuilder(
              animation: _programmaticController,
              builder: (context, _) {
                final safeIndex = _programmaticController.currentIndex
                    .clamp(0, _controllerShapeOptions.length - 1);
                final currentName = _controllerShapeOptions[safeIndex].$1;
                return Column(
                  children: [
                    Material4Avatar.animated(
                      controller: _programmaticController,
                      shapes:
                          _controllerShapeOptions.map((e) => e.$2).toList(),
                      animation: const Material4AvatarAnimation(
                        autoStart: false,
                        duration: Duration(milliseconds: 650),
                        holdDuration: Duration(milliseconds: 400),
                        preset: Material4AvatarAnimationPreset.smoothMorph,
                      ),
                      size: 72,
                      initials: 'PC',
                      backgroundColor: const Color(0xFF00897B),
                      border: const Material4AvatarBorder.solid(
                        color: Color(0xFF80CBC4),
                        width: 2.5,
                      ),
                      onTap: () => _programmaticController.nextShape(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Shape: $currentName  •  ${_programmaticController.isPlaying ? "Playing ▶" : "Paused ⏸"}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF004D40),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            if (_programmaticController.isPlaying) {
                              _programmaticController.pause();
                            } else {
                              _programmaticController.play();
                            }
                          },
                          icon: Icon(
                            _programmaticController.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 16,
                          ),
                          label: Text(_programmaticController.isPlaying
                              ? 'Pause'
                              : 'Play'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF00897B),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () =>
                              _programmaticController.previousShape(),
                          icon:
                              const Icon(Icons.skip_previous_rounded, size: 16),
                          label: const Text('Prev'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF00897B),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _programmaticController.nextShape(),
                          icon: const Icon(Icons.skip_next_rounded, size: 16),
                          label: const Text('Next'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF00897B),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _programmaticController.stop(),
                          icon: const Icon(Icons.stop_rounded, size: 16),
                          label: const Text('Stop'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE53935),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: List.generate(_controllerShapeOptions.length,
                          (idx) {
                        final item = _controllerShapeOptions[idx];
                        final isSelected =
                            _programmaticController.currentIndex == idx;
                        return ChoiceChip(
                          label: Text(item.$1,
                              style: const TextStyle(fontSize: 11)),
                          selected: isSelected,
                          selectedColor: const Color(0xFFB2DFDB),
                          onSelected: (_) {
                            _programmaticController.animateTo(item.$2);
                          },
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
            codeSnippet: '''final controller = Material4AvatarController();

// Embed with programmatic controller:
Material4Avatar.animated(
  controller: controller,
  shapes: [
    Material4AvatarShape.circle(),
    Material4AvatarShape.squircle(),
    Material4AvatarShape.hexagon(),
  ],
  size: 72,
  initials: 'PC',
)

// Programmatic controls:
controller.play();
controller.pause();
controller.nextShape();
controller.previousShape();
controller.animateTo(Material4AvatarShape.flower(petals: 8));''',
          ),
          const SizedBox(height: 16),
        ],

        // 16. Living Avatar Studio (Breathing, Floating & Glow)
        if (_matchesFilter('Morphing & Groups') ||
            _matchesFilter('Organic Shapes')) ...[
          _buildAvatarShowcaseCard(
            index: '16',
            title: 'Living Avatar Studio (Breathing, Floating & Glow)',
            subtitle:
                'Micro-interactions: subtle breathing, floating, rotating border & glow.',
            tag: 'LIVING EFFECTS',
            tagColor: const Color(0xFFE65100),
            avatar: Column(
              children: [
                Material4Avatar(
                  size: 76,
                  initials: 'LA',
                  shape: Material4AvatarShape.squircle(smoothness: 0.9),
                  backgroundColor: const Color(0xFFE65100),
                  textColor: Colors.white,
                  border: const Material4AvatarBorder.gradient(
                    gradient: SweepGradient(
                      colors: [
                        Color(0xFFFFD54F),
                        Color(0xFFFF7043),
                        Color(0xFFE91E63),
                        Color(0xFFFFD54F),
                      ],
                    ),
                    width: 3.5,
                  ),
                  effects: Material4AvatarEffects(
                    breathing: _livingBreathing,
                    floating: _livingFloating,
                    animatedBorder: _livingRotatingBorder,
                    borderRotationDuration: const Duration(seconds: 4),
                    ambientGlow: _livingGlow,
                    glowColor: const Color(0x66FF7043),
                    glowRadius: 14.0,
                    grayscale: _livingGrayscale,
                  ),
                  badge: const Material4AvatarBadge.status(
                    status: Material4AvatarStatus.online(pulse: true),
                    position: Material4AvatarBadgePosition.bottomRight,
                  ),
                  onTap: () => _notifyTap('Living Avatar'),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    FilterChip(
                      label: const Text('Breathing',
                          style: TextStyle(fontSize: 11)),
                      selected: _livingBreathing,
                      selectedColor: const Color(0xFFFFE0B2),
                      onSelected: (val) =>
                          setState(() => _livingBreathing = val),
                    ),
                    FilterChip(
                      label: const Text('Floating',
                          style: TextStyle(fontSize: 11)),
                      selected: _livingFloating,
                      selectedColor: const Color(0xFFFFE0B2),
                      onSelected: (val) =>
                          setState(() => _livingFloating = val),
                    ),
                    FilterChip(
                      label: const Text('Rotating Border',
                          style: TextStyle(fontSize: 11)),
                      selected: _livingRotatingBorder,
                      selectedColor: const Color(0xFFFFE0B2),
                      onSelected: (val) =>
                          setState(() => _livingRotatingBorder = val),
                    ),
                    FilterChip(
                      label:
                          const Text('Glow', style: TextStyle(fontSize: 11)),
                      selected: _livingGlow,
                      selectedColor: const Color(0xFFFFE0B2),
                      onSelected: (val) => setState(() => _livingGlow = val),
                    ),
                    FilterChip(
                      label: const Text('Grayscale',
                          style: TextStyle(fontSize: 11)),
                      selected: _livingGrayscale,
                      selectedColor: const Color(0xFFFFE0B2),
                      onSelected: (val) =>
                          setState(() => _livingGrayscale = val),
                    ),
                  ],
                ),
              ],
            ),
            codeSnippet: '''Material4Avatar(
  size: 76,
  initials: 'LA',
  shape: Material4AvatarShape.squircle(smoothness: 0.9),
  backgroundColor: const Color(0xFFE65100),
  border: const Material4AvatarBorder.gradient(
    gradient: SweepGradient(colors: [
      Color(0xFFFFD54F),
      Color(0xFFFF7043),
      Color(0xFFE91E63),
      Color(0xFFFFD54F),
    ]),
    width: 3.5,
  ),
  effects: const Material4AvatarEffects(
    breathing: true,
    floating: true,
    animatedBorder: true,
    ambientGlow: true,
    glowRadius: 14.0,
  ),
  badge: const Material4AvatarBadge.status(
    status: Material4AvatarStatus.online(pulse: true),
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 17. Morphing & Living Group Avatar
        if (_matchesFilter('Morphing & Groups')) ...[
          _buildAvatarShowcaseCard(
            index: '17',
            title: 'Morphing & Living Group Avatar',
            subtitle:
                'Stacked group avatar where members have individual morphing & micro-animations.',
            tag: 'GROUP MORPH',
            tagColor: const Color(0xFF1565C0),
            avatar: Material4AvatarGroup(
              maxVisible: 4,
              spacing: -14,
              avatars: [
                Material4Avatar.animated(
                  initials: 'AG',
                  size: 52,
                  shapes: [
                    Material4AvatarShape.circle(),
                    Material4AvatarShape.squircle(smoothness: 0.8),
                    Material4AvatarShape.circle(),
                  ],
                  animation: const Material4AvatarAnimation(
                    duration: Duration(milliseconds: 1000),
                    holdDuration: Duration(milliseconds: 500),
                  ),
                  backgroundColor: const Color(0xFF6200EE),
                  border: const Material4AvatarBorder.solid(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  onTap: () => _notifyTap('Morphing Member (AG)'),
                ),
                Material4Avatar.breathing(
                  initials: 'BR',
                  size: 52,
                  shape: Material4AvatarShape.hexagon(cornerRadius: 8),
                  backgroundColor: const Color(0xFF00B0FF),
                  border: const Material4AvatarBorder.solid(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  onTap: () => _notifyTap('Breathing Member (BR)'),
                ),
                Material4Avatar.floating(
                  initials: 'FL',
                  size: 52,
                  shape: Material4AvatarShape.organicBlob(seed: 12),
                  backgroundColor: const Color(0xFF00E676),
                  border: const Material4AvatarBorder.solid(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  onTap: () => _notifyTap('Floating Member (FL)'),
                ),
                Material4Avatar.animated(
                  initials: 'SH',
                  size: 52,
                  shapes: [
                    Material4AvatarShape.shield(),
                    Material4AvatarShape.squircle(),
                    Material4AvatarShape.shield(),
                  ],
                  animation: const Material4AvatarAnimation(
                    duration: Duration(milliseconds: 1400),
                    holdDuration: Duration(milliseconds: 400),
                  ),
                  backgroundColor: const Color(0xFFFF9100),
                  border: const Material4AvatarBorder.solid(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  onTap: () => _notifyTap('Shield Morpher (SH)'),
                ),
              ],
              onOverflowTap: () => _notifyTap('Group Overflow (Show All)'),
            ),
            codeSnippet: '''Material4AvatarGroup(
  maxVisible: 4,
  spacing: -14,
  avatars: [
    Material4Avatar.animated(
      initials: 'AG',
      size: 52,
      shapes: [
        Material4AvatarShape.circle(),
        Material4AvatarShape.squircle(),
        Material4AvatarShape.circle(),
      ],
      animation: const Material4AvatarAnimation(
        duration: Duration(milliseconds: 1000),
      ),
    ),
    Material4Avatar.breathing(
      initials: 'BR',
      size: 52,
      shape: Material4AvatarShape.hexagon(cornerRadius: 8),
    ),
    Material4Avatar.floating(
      initials: 'FL',
      size: 52,
      shape: Material4AvatarShape.organicBlob(seed: 12),
    ),
    Material4Avatar.animated(
      initials: 'SH',
      size: 52,
      shapes: [
        Material4AvatarShape.shield(),
        Material4AvatarShape.squircle(),
        Material4AvatarShape.shield(),
      ],
    ),
  ],
)''',
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 30),
      ],
    );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Dynamic Avatar Gallery',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E1E24),
        elevation: 0.5,
      ),
      body: content,
    );
  }

  bool _matchesFilter(String category) {
    if (_selectedCategory == 'All') return true;
    return _selectedCategory == category;
  }

  void _notifyTap(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Interacted with $name'),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5E43EE), Color(0xFF8C7AE6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x335E43EE),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Material 4 Avatar System',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '24+ Shapes • Vector Path Borders • Badges • Morphing',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Explore production-ready profile avatars with hardware-accelerated Bézier clipping, glowing and dashed borders, live presence indicators, verification badges, and group compositions.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              selectedColor: const Color(0xFF5E43EE),
              backgroundColor: Colors.white,
              labelStyle: GoogleFonts.plusJakartaSans(
                color: isSelected ? Colors.white : const Color(0xFF495057),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF5E43EE)
                      : const Color(0xFFE9ECEF),
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAvatarShowcaseCard({
    required String index,
    required String title,
    required String subtitle,
    required String tag,
    required Color tagColor,
    required Widget avatar,
    required String codeSnippet,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tagColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: tagColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$index. $title',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1E24),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6C757D),
            ),
          ),
          const SizedBox(height: 16),

          // Live Interactive Avatar Presentation Stage
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEDF2F7)),
            ),
            child: Center(child: avatar),
          ),
          const SizedBox(height: 14),

          // Code Snippet Header & Copy Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.code_rounded,
                      size: 16, color: Color(0xFF6C757D)),
                  const SizedBox(width: 6),
                  Text(
                    'Dart Snippet',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF495057),
                    ),
                  ),
                ],
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _copyToClipboard(context, codeSnippet, title),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E43EE).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.copy_rounded,
                          size: 14, color: Color(0xFF5E43EE)),
                      const SizedBox(width: 4),
                      Text(
                        'Copy Code',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF5E43EE),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Monospace Code Block
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E24),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                codeSnippet,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11.5,
                  color: Color(0xFF80CBC4),
                  height: 1.45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
