import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Reusable widget displaying a centered "empty" message with an icon.
///
/// [icon]: the icon to show (default is [Icons.info_outline]).
/// [message]: primary text shown below the icon.
/// [subtitle]: optional secondary text.
/// [iconSize]: size of the icon.
/// [iconColor]: color of the icon (defaults to theme.secondaryText).
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subtitle;
  final double iconSize;
  final Color? iconColor;

  const AppEmptyState({
    super.key,
    this.icon = Icons.info_outline,
    required this.message,
    this.subtitle,
    this.iconSize = 64,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: iconColor ?? theme.secondaryText),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.outfit(
              color: theme.secondaryText,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: GoogleFonts.outfit(
                color: theme.secondaryText,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ]
        ],
      ),
    );
  }
}
