import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class InteractiveColorPicker extends StatefulWidget {
  final Color? initialColor;
  final ValueChanged<Color> onColorChanged;
  final double size;

  const InteractiveColorPicker({
    super.key,
    this.initialColor,
    required this.onColorChanged,
    this.size = 40.0,
  });

  @override
  State<InteractiveColorPicker> createState() => _InteractiveColorPickerState();
}

class _InteractiveColorPickerState extends State<InteractiveColorPicker> {
  late Color _currentColor;
  late TextEditingController _hexController;
  bool _isEditing = false;

  // Predefined premium palette based on the Netflix/Dark theme
  final List<Color> _presetColors = const [
    Color(0xFFE50914), // brand-primary (Netflix Red)
    Color(0xFFB81D24), // brand-secondary
    Color(0xFFFFFFFF), // white
    Color(0xFF14181B), // dark-text
    Color(0xFF57636C), // secondary-text
    Color(0xFF46D160), // success
    Color(0xFFFFC107), // warning
    Color(0xFF2196F3), // info
    Color(0xFF9C27B0), // purple
    Color(0xFFFF5252), // accent1
    Color(0xFFFFD740), // accent2
  ];

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor ?? const Color(0xFFE50914);
    _hexController = TextEditingController(
      text: _colorToHex(_currentColor),
    );
  }

  @override
  void didUpdateWidget(InteractiveColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != oldWidget.initialColor &&
        widget.initialColor != null &&
        widget.initialColor != _currentColor) {
      setState(() {
        _currentColor = widget.initialColor!;
        if (!_isEditing) {
          _hexController.text = _colorToHex(_currentColor);
        }
      });
    }
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  void _handleHexSubmit(String value) {
    String hex = value.replaceAll('#', '').toUpperCase();
    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    if (hex.length == 8) {
      try {
        final newColor = Color(int.parse(hex, radix: 16));
        setState(() {
          _currentColor = newColor;
          _isEditing = false;
        });
        widget.onColorChanged(newColor);
      } catch (_) {
        // Invalid hex, revert to current
        _hexController.text = _colorToHex(_currentColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Preview and Hex Input
        Row(
          children: [
            // Color Preview Circle
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: _currentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.alternate,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _currentColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Hex Input
            Expanded(
              child: TextFormField(
                controller: _hexController,
                style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'HEX Color',
                  labelStyle: GoogleFonts.outfit(
                    color: theme.secondaryText,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.alternate,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: theme.secondaryBackground,
                ),
                onTap: () => setState(() => _isEditing = true),
                onFieldSubmitted: _handleHexSubmit,
                onChanged: (value) {
                  if (value.startsWith('#') && value.length > 7) {
                    _handleHexSubmit(value);
                  } else if (!value.startsWith('#') && value.length > 6) {
                    _handleHexSubmit(value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Preset Palette
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _presetColors.map((color) {
            final isSelected = color.value == _currentColor.value;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentColor = color;
                  _hexController.text = _colorToHex(color);
                });
                widget.onColorChanged(color);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: theme.primaryText, width: 2)
                      : Border.all(
                          color: theme.alternate.withValues(alpha: 0.5),
                          width: 1),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 6,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(Icons.check,
                        size: 16, color: _getContrastColor(color))
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getContrastColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
