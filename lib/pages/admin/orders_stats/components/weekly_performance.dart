import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class WeeklyPerformance extends StatelessWidget {
  const WeeklyPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rendimiento Semanal',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                font: GoogleFonts.inter(),
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildDayStats(context, 'Lunes', 156, 0.65),
                const SizedBox(height: 12.0),
                _buildDayStats(context, 'Martes', 189, 0.79),
                const SizedBox(height: 12.0),
                _buildDayStats(context, 'Miércoles', 142, 0.59),
                const SizedBox(height: 12.0),
                _buildDayStats(context, 'Jueves', 203, 0.85),
                const SizedBox(height: 12.0),
                _buildDayStats(context, 'Viernes', 234, 0.98),
                const SizedBox(height: 12.0),
                _buildDayStats(context, 'Sábado', 240, 1.0),
                const SizedBox(height: 12.0),
                _buildDayStats(context, 'Domingo', 198, 0.83),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayStats(
      BuildContext context, String day, int orders, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              day,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '$orders pedidos',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.inter(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8.0,
            backgroundColor: FlutterFlowTheme.of(context).alternate,
            valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary),
          ),
        ),
      ],
    );
  }
}
