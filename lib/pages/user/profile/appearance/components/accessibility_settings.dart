import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../main.dart';

class AccessibilitySettings extends StatefulWidget {
  final bool isDesktop;

  const AccessibilitySettings({super.key, this.isDesktop = false});

  @override
  State<AccessibilitySettings> createState() => _AccessibilitySettingsState();
}

class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  late bool _animationsEnabled;

  @override
  void initState() {
    super.initState();
    _animationsEnabled = FlutterFlowTheme.animationsEnabled;
  }

  Future<void> _updateAnimations(bool value) async {
    setState(() => _animationsEnabled = value);
    FlutterFlowTheme.saveAnimationsEnabled(value);
    // Force rebuild
    MyApp.of(context).setThemeMode(FlutterFlowTheme.themeMode);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDesktop) {
      return _buildSwitchRow("Animaciones", "Efectos visuales",
          _animationsEnabled, (v) => _updateAnimations(v));
    } else {
      return _buildSwitchTile(
        title: "Animaciones",
        subtitle: "Reducir movimiento en la interfaz",
        value: !_animationsEnabled,
        onChanged: (v) => _updateAnimations(
            !v), // Logic inverted for "Reduce motion" vs "Animations enabled"?
        // Original code: value: !_animationsEnabled. subtitle: "Reducir movimiento".
        // If _animationsEnabled is true, value is false. Toggle -> true -> _updateAnimations(!true) -> false. Correct.
        icon: Icons.animation_rounded,
      );
    }
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration:
                BoxDecoration(color: theme.accent4, shape: BoxShape.circle),
            child: Icon(icon, color: theme.secondaryText, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: GoogleFonts.outfit(
                        color: theme.secondaryText, fontSize: 13)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: theme.primary,
            activeTrackColor: theme.primary.withValues(alpha: 0.3),
            inactiveTrackColor: theme.secondaryText.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    final theme = FlutterFlowTheme.of(context);
    final kPrimaryColor = theme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
                  GoogleFonts.outfit(color: theme.primaryText, fontSize: 15)),
          Text(subtitle,
              style:
                  GoogleFonts.outfit(color: theme.secondaryText, fontSize: 12)),
        ]),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: kPrimaryColor,
        ),
      ],
    );
  }
}
