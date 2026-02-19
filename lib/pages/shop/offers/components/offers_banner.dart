import 'package:flutter/material.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';

class OffersBanner extends StatelessWidget {
  final bool isDesktop;

  const OffersBanner({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: isDesktop ? 200.0 : 160.0,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B39EF), Color(0xFFEE8B60)],
          stops: [0.0, 1.0],
          begin: AlignmentDirectional(-1.0, -1.0),
          end: AlignmentDirectional(1.0, 1.0),
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B39EF).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 24,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔥 OFERTAS ESPECIALES',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: isDesktop ? 24.0 : 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Descuentos exclusivos por tiempo limitado',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: isDesktop ? 16.0 : 14.0,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).alternate,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Hasta 50% OFF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isDesktop ? 16.0 : 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
