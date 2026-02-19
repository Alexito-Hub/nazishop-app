import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AnalyticsStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const AnalyticsStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.primary, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.outfit(
              color: theme.secondaryText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }
}
