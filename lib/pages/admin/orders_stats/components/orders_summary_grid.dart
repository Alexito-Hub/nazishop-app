import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class OrdersSummaryGrid extends StatelessWidget {
  const OrdersSummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisExtent: 140, // Height for Stat Cards
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
      children: [
        _buildStatCard(
          context,
          'Pedidos Hoy',
          '24',
          Icons.today,
          FlutterFlowTheme.of(context).primary,
          '+18%',
        ),
        _buildStatCard(
          context,
          'Completados',
          '18',
          Icons.check_circle,
          FlutterFlowTheme.of(context).success,
          '75%',
        ),
        _buildStatCard(
          context,
          'Pendientes',
          '5',
          Icons.pending,
          FlutterFlowTheme.of(context).warning,
          '21%',
        ),
        _buildStatCard(
          context,
          'Cancelados',
          '1',
          Icons.cancel,
          FlutterFlowTheme.of(context).error,
          '4%',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    String badge,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    badge,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).tertiary,
                          fontSize: 10.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.inter(),
                        color: color,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
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
