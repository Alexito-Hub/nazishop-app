import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class TopProductsList extends StatelessWidget {
  const TopProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Productos Más Vendidos',
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
                _buildTopProductItem(
                    context, 'Netflix Premium', '89 ventas', 1),
                const Divider(height: 24.0),
                _buildTopProductItem(
                    context, 'Spotify Familiar', '67 ventas', 2),
                const Divider(height: 24.0),
                _buildTopProductItem(
                    context, 'Disney+ Premium', '54 ventas', 3),
                const Divider(height: 24.0),
                _buildTopProductItem(context, 'HBO Max', '42 ventas', 4),
                const Divider(height: 24.0),
                _buildTopProductItem(
                    context, 'YouTube Premium', '38 ventas', 5),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopProductItem(
      BuildContext context, String name, String sales, int position) {
    Color positionColor;
    switch (position) {
      case 1:
        positionColor = const Color(0xFFFFB951);
        break;
      case 2:
        positionColor = const Color(0xFFC0C0C0);
        break;
      case 3:
        positionColor = const Color(0xFFCD7F32);
        break;
      default:
        positionColor = FlutterFlowTheme.of(context).secondaryText;
    }

    return Row(
      children: [
        Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            color: positionColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '#$position',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.inter(),
                    color: positionColor,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            name,
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.inter(),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Text(
          sales,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(),
                color: FlutterFlowTheme.of(context).primary,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
