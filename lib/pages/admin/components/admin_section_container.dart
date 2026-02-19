import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AdminSectionContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final String? footer;

  const AdminSectionContainer({
    super.key,
    required this.title,
    required this.child,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (footer != null)
                  Text(
                    footer!,
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context)
                          .secondaryText
                          .withValues(alpha: 0.5),
                      fontSize: 12.0,
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: FlutterFlowTheme.of(context).alternate),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: child,
          ),
        ],
      ),
    );
  }
}
