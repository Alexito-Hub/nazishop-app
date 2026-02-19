import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../../main.dart';

class ThemeSelector extends StatefulWidget {
  final bool isDesktop;

  const ThemeSelector({super.key, this.isDesktop = false});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  @override
  Widget build(BuildContext context) {
    if (widget.isDesktop) {
      return _buildDesktopSelector();
    } else {
      return _buildMobileSelector();
    }
  }

  Widget _buildMobileSelector() {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        children: [
          _buildThemeOptionMobile(
              ThemeMode.light, "Claro", Icons.wb_sunny_rounded),
          Divider(color: theme.alternate, height: 1),
          _buildThemeOptionMobile(
              ThemeMode.dark, "Oscuro", Icons.nights_stay_rounded),
          Divider(color: theme.alternate, height: 1),
          _buildThemeOptionMobile(
              ThemeMode.system, "Sistema", Icons.brightness_auto_rounded),
        ],
      ),
    );
  }

  Widget _buildThemeOptionMobile(ThemeMode mode, String title, IconData icon) {
    final isSelected = FlutterFlowTheme.themeMode == mode;
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: () async {
        FlutterFlowTheme.saveThemeMode(mode);
        if (mounted) {
          MyApp.of(context).setThemeMode(mode);
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? theme.primary : theme.secondaryText,
                size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  color: isSelected ? theme.primaryText : theme.secondaryText,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check, color: theme.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopSelector() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildThemeOptionDesktop(
              ThemeMode.light, Icons.wb_sunny_rounded, "Claro"),
          const SizedBox(width: 16),
          _buildThemeOptionDesktop(
              ThemeMode.dark, Icons.nights_stay_rounded, "Oscuro"),
          const SizedBox(width: 16),
          _buildThemeOptionDesktop(
              ThemeMode.system, Icons.brightness_auto_rounded, "Auto"),
        ],
      ),
    );
  }

  Widget _buildThemeOptionDesktop(ThemeMode mode, IconData icon, String label) {
    final isSelected = FlutterFlowTheme.themeMode == mode;
    final theme = FlutterFlowTheme.of(context);
    final kPrimaryColor = theme.primary;
    return GestureDetector(
      onTap: () async {
        FlutterFlowTheme.saveThemeMode(mode);
        if (mounted) {
          MyApp.of(context).setThemeMode(mode);
          setState(() {});
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimaryColor.withValues(alpha: 0.1)
              : theme.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? kPrimaryColor : theme.alternate,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? theme.primaryText : theme.secondaryText,
                size: 28),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected ? theme.primaryText : theme.secondaryText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
