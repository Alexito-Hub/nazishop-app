import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ActivityStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const ActivityStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context)
            .secondaryBackground
            .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FlutterFlowTheme.of(context)
                .secondaryBackground
                .withValues(alpha: 0.08),
            FlutterFlowTheme.of(context)
                .secondaryBackground
                .withValues(alpha: 0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
