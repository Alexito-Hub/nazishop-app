import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// A compact color field that shows the selected color + hex code.
/// Tapping it opens a floating bottom sheet with preset palette + hex input.
class InteractiveColorPicker extends StatefulWidget {
  final Color? initialColor;
  final ValueChanged<Color> onColorChanged;
  final String label;

  const InteractiveColorPicker({
    super.key,
    this.initialColor,
    required this.onColorChanged,
    this.label = 'COLOR',
  });

  @override
  State<InteractiveColorPicker> createState() => _InteractiveColorPickerState();
}

class _InteractiveColorPickerState extends State<InteractiveColorPicker> {
  late Color _currentColor;

  final List<Color> _presetColors = const [
    Color(0xFFE50914),
    Color(0xFFB81D24),
    Color(0xFFFF5252),
    Color(0xFFFF9800),
    Color(0xFFFFD740),
    Color(0xFF46D160),
    Color(0xFF00BCD4),
    Color(0xFF2196F3),
    Color(0xFF3F51B5),
    Color(0xFF9C27B0),
    Color(0xFFFFFFFF),
    Color(0xFF57636C),
    Color(0xFF14181B),
    Color(0xFF000000),
  ];

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor ?? const Color(0xFF2196F3);
  }

  @override
  void didUpdateWidget(InteractiveColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialColor != null &&
        widget.initialColor != oldWidget.initialColor) {
      setState(() => _currentColor = widget.initialColor!);
    }
  }

  String _colorToHex(Color c) =>
      '#${c.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  void _openPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ColorPickerSheet(
        currentColor: _currentColor,
        presetColors: _presetColors,
        onColorSelected: (color) {
          setState(() => _currentColor = color);
          widget.onColorChanged(color);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: GoogleFonts.outfit(
              color: theme.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Trigger button — looks like a form field
        InkWell(
          onTap: _openPicker,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.alternate),
            ),
            child: Row(
              children: [
                // Swatch
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _currentColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: theme.alternate.withValues(alpha: 0.6),
                        width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: _currentColor.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _colorToHex(_currentColor),
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                Icon(Icons.color_lens_outlined,
                    color: theme.secondaryText, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Bottom Sheet ──────────────────────────────────────────────

class _ColorPickerSheet extends StatefulWidget {
  final Color currentColor;
  final List<Color> presetColors;
  final ValueChanged<Color> onColorSelected;

  const _ColorPickerSheet({
    required this.currentColor,
    required this.presetColors,
    required this.onColorSelected,
  });

  @override
  State<_ColorPickerSheet> createState() => _ColorPickerSheetState();
}

class _ColorPickerSheetState extends State<_ColorPickerSheet> {
  late Color _selected;
  late TextEditingController _hexCtrl;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentColor;
    _hexCtrl = TextEditingController(text: _colorToHex(_selected));
  }

  @override
  void dispose() {
    _hexCtrl.dispose();
    super.dispose();
  }

  String _colorToHex(Color c) =>
      '#${c.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  Color _getContrast(Color c) =>
      ThemeData.estimateBrightnessForColor(c) == Brightness.dark
          ? Colors.white
          : Colors.black;

  void _applyHex(String value) {
    String hex = value.replaceAll('#', '').toUpperCase();
    if (hex.length == 6) hex = 'FF$hex';
    if (hex.length == 8) {
      try {
        setState(() {
          _selected = Color(int.parse(hex, radix: 16));
        });
      } catch (_) {}
    }
  }

  void _select(Color color) {
    setState(() {
      _selected = color;
      _hexCtrl.text = _colorToHex(color);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.alternate),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.alternate,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      'Seleccionar Color',
                      style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Preview swatch large
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _selected,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: theme.alternate.withValues(alpha: 0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: _selected.withValues(alpha: 0.4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // HEX input
                TextFormField(
                  controller: _hexCtrl,
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[#a-fA-F0-9]')),
                    LengthLimitingTextInputFormatter(7),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Código HEX',
                    labelStyle: GoogleFonts.outfit(color: theme.secondaryText),
                    prefixIcon: Icon(Icons.tag, color: theme.secondaryText),
                    filled: true,
                    fillColor: theme.primaryBackground,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.alternate),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  onChanged: _applyHex,
                  onFieldSubmitted: (_) {
                    widget.onColorSelected(_selected);
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 20),

                // Palette title
                Text(
                  'PALETA',
                  style: GoogleFonts.outfit(
                    color: theme.secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Color grid
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.presetColors.map((color) {
                    final isSelected = color.value == _selected.value;
                    return GestureDetector(
                      onTap: () => _select(color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected
                              ? Border.all(color: theme.primaryText, width: 2.5)
                              : Border.all(
                                  color: theme.alternate.withValues(alpha: 0.4),
                                  width: 1),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  )
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? Icon(Icons.check,
                                size: 18, color: _getContrast(color))
                            : null,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onColorSelected(_selected);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selected,
                      foregroundColor: _getContrast(_selected),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Confirmar Color',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
