import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ActivityListItem extends StatelessWidget {
  final String name;
  final String action;
  final String time;
  final IconData icon;
  final Color color;

  const ActivityListItem({
    super.key,
    required this.name,
    required this.action,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  action,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context)
                        .secondaryText
                        .withValues(alpha: 0.6),
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context)
                  .secondaryText
                  .withValues(alpha: 0.4),
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
