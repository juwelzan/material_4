import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dynamic_shape_config.dart';
import 'dynamic_shape_container.dart';
import 'shape_smart_layout.dart';

/// Developer tool that converts any [DynamicShapeConfig] into clean, ready-to-paste Dart code.
class ShapeCodeGenerator {
  const ShapeCodeGenerator._();

  static String toDartCode(
    DynamicShapeConfig config, {
    String varName = 'shapeConfig',
  }) {
    final buffer = StringBuffer();
    buffer.writeln('final $varName = DynamicShapeConfig(');
    buffer.writeln('  type: DynamicShapeType.${config.type.name},');
    if (config.borderStyle != BorderStyleType.solid) {
      buffer.writeln(
        '  borderStyle: BorderStyleType.${config.borderStyle.name},',
      );
    }
    if (config.cornerRadius != 24.0) {
      buffer.writeln('  cornerRadius: ${config.cornerRadius},');
    }
    if (config.cornerRadii != null) {
      final r = config.cornerRadii!;
      buffer.writeln(
        '  cornerRadii: CornerRadii(topLeft: ${r.topLeft}, topRight: ${r.topRight}, bottomLeft: ${r.bottomLeft}, bottomRight: ${r.bottomRight}),',
      );
    }
    if (config.anchor != ShapeAnchor.topRight) {
      buffer.writeln('  anchor: ShapeAnchor.${config.anchor.name},');
    }
    if (config.backgroundEffect != BackgroundEffectType.none) {
      buffer.writeln(
        '  backgroundEffect: BackgroundEffectType.${config.backgroundEffect.name},',
      );
    }
    if (config.rotation != 0.0) {
      buffer.writeln('  rotation: ${config.rotation},');
    }
    if (config.scaleX != 1.0 || config.scaleY != 1.0) {
      buffer.writeln('  scaleX: ${config.scaleX},');
      buffer.writeln('  scaleY: ${config.scaleY},');
    }
    buffer.writeln(');');
    return buffer.toString();
  }
}

/// Interactive Live Studio & Playground for experimenting with shapes, borders,
/// and background effects in real time.
class ShapePlayground extends StatefulWidget {
  final DynamicShapeConfig initialConfig;

  const ShapePlayground({
    super.key,
    this.initialConfig = const DynamicShapeConfig(),
  });

  @override
  State<ShapePlayground> createState() => _ShapePlaygroundState();
}

class _ShapePlaygroundState extends State<ShapePlayground> {
  late DynamicShapeType _type;
  late BorderStyleType _borderStyle;
  late BackgroundEffectType _bgEffect;
  late double _cornerRadius;
  late double _borderWidth;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialConfig.type;
    _borderStyle = widget.initialConfig.borderStyle;
    _bgEffect = widget.initialConfig.backgroundEffect;
    _cornerRadius = widget.initialConfig.cornerRadius;
    _borderWidth = 2.0;
  }

  DynamicShapeConfig get _activeConfig => DynamicShapeConfig(
    type: _type,
    borderStyle: _borderStyle,
    backgroundEffect: _bgEffect,
    cornerRadius: _cornerRadius,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // Preview Card Stage
          Expanded(
            child: Center(
              child: DynamicShapeContainer(
                config: _activeConfig,
                width: 260,
                height: 160,
                color: _isDark ? const Color(0xFF1E293B) : Colors.white,
                borderColor: _isDark
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF6366F1),
                borderWidth: _borderWidth,
                child: ShapeSafeArea(
                  config: _activeConfig,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _type.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Border: ${_borderStyle.name}',
                          style: TextStyle(
                            fontSize: 12,
                            color: _isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Property Control Panel
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: _isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border(
                top: BorderSide(
                  color: _isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<DynamicShapeType>(
                        value: _type,
                        isExpanded: true,
                        dropdownColor: _isDark
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                        style: TextStyle(
                          color: _isDark ? Colors.white : Colors.black87,
                        ),
                        items: DynamicShapeType.values
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.name),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _type = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<BorderStyleType>(
                        value: _borderStyle,
                        isExpanded: true,
                        dropdownColor: _isDark
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                        style: TextStyle(
                          color: _isDark ? Colors.white : Colors.black87,
                        ),
                        items: BorderStyleType.values
                            .map(
                              (b) => DropdownMenuItem(
                                value: b,
                                child: Text(b.name),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _borderStyle = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Corner: ${_cornerRadius.round()}',
                      style: TextStyle(
                        color: _isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _cornerRadius,
                        min: 0,
                        max: 48,
                        onChanged: (v) => setState(() => _cornerRadius = v),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isDark ? Icons.light_mode : Icons.dark_mode,
                        color: _isDark ? Colors.yellow : Colors.grey,
                      ),
                      onPressed: () => setState(() => _isDark = !_isDark),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Code'),
                      onPressed: () {
                        final code = ShapeCodeGenerator.toDartCode(
                          _activeConfig,
                        );
                        Clipboard.setData(ClipboardData(text: code));
                        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          const SnackBar(
                            content: Text('Dart code copied to clipboard!'),
                          ),
                        );
                      },
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
}

/// Visual gallery displaying presets in an adaptive grid.
class PresetGallery extends StatelessWidget {
  final ValueChanged<DynamicShapeConfig>? onPresetSelected;

  const PresetGallery({super.key, this.onPresetSelected});

  @override
  Widget build(BuildContext context) {
    final presets = DynamicShapeType.values;

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: presets.length,
      itemBuilder: (context, i) {
        final shape = presets[i];
        final config = DynamicShapeConfig(type: shape);

        return GestureDetector(
          onTap: () => onPresetSelected?.call(config),
          child: DynamicShapeContainer(
            config: config,
            color: const Color(0xFFF1F5F9),
            borderColor: const Color(0xFFCBD5E1),
            borderWidth: 1.5,
            child: Center(
              child: Text(
                shape.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xFF334155),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
