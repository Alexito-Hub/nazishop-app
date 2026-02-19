import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class PrivacySection extends StatelessWidget {
  final String title;
  final String content;

  const PrivacySection({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: theme.primary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.justify,
            style: GoogleFonts.outfit(
              color: theme.secondaryText,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
