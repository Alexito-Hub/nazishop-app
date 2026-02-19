import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class TopUserItem extends StatelessWidget {
  final int position;
  final String name;
  final String stats;
  final Color medalColor;

  const TopUserItem({
    super.key,
    required this.position,
    required this.name,
    required this.stats,
    required this.medalColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context)
            .secondaryBackground
            .withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: medalColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$position',
                style: GoogleFonts.outfit(
                  color: medalColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Text(
                  stats,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12,
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
