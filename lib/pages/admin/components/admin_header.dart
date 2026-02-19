import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Panel Admin',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Centro de control para operadores y administradores',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color:
                    FlutterFlowTheme.of(context).primaryText.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(Icons.flash_on_rounded,
                  color: FlutterFlowTheme.of(context).primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'Live Sync Active',
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
