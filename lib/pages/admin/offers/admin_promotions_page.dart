import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import '../admin_auth_guard.dart';

class AdminPromotionsPage extends StatelessWidget {
  const AdminPromotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminAuthGuard(
      title: 'Gestión de Promociones',
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            // Fondo degradado sutil global
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: FlutterFlowTheme.of(context)
                      .primary
                      .withValues(alpha: 0.05),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Promociones y Ofertas',
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Crea paquetes, descuentos por tiempo limitado y promociones sobre Listings existentes.',
                    style: GoogleFonts.readexPro(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 16,
                    ),
                  ),
                  // TODO: Implement Promotions CRUD
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
