import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class TermsHeader extends StatelessWidget {
  const TermsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.gavel_outlined, color: theme.primary, size: 48),
        const SizedBox(height: 16),
        Text(
          'Acuerdo de Uso',
          style: GoogleFonts.outfit(
            color: theme.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Por favor lea estos términos cuidadosamente antes de utilizar nuestros servicios de streaming y productos digitales.',
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
