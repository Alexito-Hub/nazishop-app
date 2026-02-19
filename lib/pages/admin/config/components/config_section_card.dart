import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ConfigSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final double? width;
  final double? maxWidth;

  const ConfigSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.width,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: width,
      constraints:
          maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}
