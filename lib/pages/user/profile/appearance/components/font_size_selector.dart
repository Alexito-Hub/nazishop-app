import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../main.dart';

class FontSizeSelector extends StatefulWidget {
  final bool isDesktop;

  const FontSizeSelector({super.key, this.isDesktop = false});

  @override
  State<FontSizeSelector> createState() => _FontSizeSelectorState();
}

class _FontSizeSelectorState extends State<FontSizeSelector> {
  late String _fontSize;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final factor = FlutterFlowTheme.fontSizeFactor;
    if (factor <= 0.85) {
      _fontSize = 'Pequeño';
    } else if (factor >= 1.15) {
      _fontSize = 'Grande';
    } else {
      _fontSize = 'Normal';
    }
  }

  Future<void> _updateFontSize(String sizeKey) async {
    setState(() => _fontSize = sizeKey);
    double factor = 1.0;
    if (sizeKey == 'Pequeño') factor = 0.85;
    if (sizeKey == 'Grande') factor = 1.15;

    FlutterFlowTheme.saveFontSizeFactor(factor);
    // Force rebuild
    MyApp.of(context).setThemeMode(FlutterFlowTheme.themeMode);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDesktop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Tamaño de texto",
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText)),
          _buildFontSizeToggle(),
        ],
      );
    } else {
      return _buildMobileSelector();
    }
  }

  Widget _buildMobileSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tamaño de texto",
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Row(
            children: [
              _fontSizeBtn("A", "Pequeño"),
              const SizedBox(width: 12),
              _fontSizeBtn("Aa", "Normal"),
              const SizedBox(width: 12),
              _fontSizeBtn("AAA", "Grande"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeToggle() {
    return Row(
      children: [
        _miniFontBtn("A-", "Pequeño"),
        const SizedBox(width: 8),
        _miniFontBtn("A", "Normal"),
        const SizedBox(width: 8),
        _miniFontBtn("A+", "Grande"),
      ],
    );
  }

  Widget _miniFontBtn(String text, String key) {
    final isSelected = _fontSize == key;
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: () => _updateFontSize(key),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : theme.alternate,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text,
            style: GoogleFonts.outfit(
                color: isSelected ? theme.secondaryText : theme.primaryText,
                fontSize: 12)),
      ),
    );
  }

  Widget _fontSizeBtn(String label, String valueKey) {
    final isSelected = _fontSize == valueKey;
    final theme = FlutterFlowTheme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: () => _updateFontSize(valueKey),
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? theme.primary : theme.alternate,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: isSelected ? theme.secondaryText : theme.primaryText,
              fontWeight: FontWeight.bold,
              fontSize:
                  valueKey == 'Pequeño' ? 12 : (valueKey == 'Grande' ? 20 : 16),
            ),
          ),
        ),
      ),
    );
  }
}
