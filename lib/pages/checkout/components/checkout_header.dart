import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class CheckoutHeader extends StatelessWidget {
  const CheckoutHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back,
                    color: FlutterFlowTheme.of(context).secondaryText),
                const SizedBox(width: 8),
                Text('Volver al servicio',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_rounded,
                      color: FlutterFlowTheme.of(context).success, size: 14),
                  const SizedBox(width: 6),
                  Text('Pago seguro',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).success,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Finalizar compra',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 36,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Revisa los detalles antes de confirmar',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 15)),
      ],
    );
  }
}
