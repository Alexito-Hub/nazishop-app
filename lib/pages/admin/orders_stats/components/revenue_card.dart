import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary,
            FlutterFlowTheme.of(context).tertiary
          ],
          stops: const [0.0, 1.0],
          begin: const AlignmentDirectional(-1.0, 0.0),
          end: const AlignmentDirectional(1.0, 0.0),
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: FlutterFlowTheme.of(context).tertiary,
                  size: 32.0,
                ),
                const SizedBox(width: 12.0),
                Text(
                  'Ingresos del Mes',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).tertiary,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              '\$4,500.000',
              style: FlutterFlowTheme.of(context).displaySmall.override(
                    font: GoogleFonts.inter(),
                    color: FlutterFlowTheme.of(context).tertiary,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: FlutterFlowTheme.of(context)
                      .tertiary
                      .withValues(alpha: 0.7),
                  size: 20.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  '+12% vs mes anterior',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context)
                            .tertiary
                            .withValues(alpha: 0.7),
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
