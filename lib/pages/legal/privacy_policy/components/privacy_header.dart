import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class PrivacyHeader extends StatelessWidget {
  const PrivacyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.privacy_tip_outlined, color: theme.primary, size: 48),
        const SizedBox(height: 16),
        Text(
          'Su privacidad es nuestra prioridad',
          style: GoogleFonts.outfit(
            color: theme.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'En NaziShop, nos comprometemos a proteger sus datos personales y ser transparentes sobre cómo los utilizamos.',
          style: GoogleFonts.outfit(
            color: theme.secondaryText,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
