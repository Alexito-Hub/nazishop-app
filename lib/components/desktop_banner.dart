import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class DesktopBanner extends StatelessWidget {
  const DesktopBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final primaryColor = theme.primary;

    return Container(
      constraints: const BoxConstraints(minHeight: 280),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).secondaryBackground,
            FlutterFlowTheme.of(context).primaryBackground
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.2),
        ),
      ),
      child: Stack(
        children: [
          // Elementos decorativos de fondo
          Positioned(
            right: -50,
            bottom: -50,
            child: Icon(
              Icons.stars_rounded,
              size: 400,
              color: primaryColor.withValues(alpha: 0.03),
            ),
          ),
          Positioned(
            top: 20,
            left: 200,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [theme.primary, theme.secondary],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.4),
                                  blurRadius: 10)
                            ]),
                        child: Text(
                          'PREMIUM ACCESS',
                          style: GoogleFonts.outfit(
                            color: Colors.white, // White on gradient background
                            fontSize: 10 * FlutterFlowTheme.fontSizeFactor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Descubre servicios\nde alto nivel.',
                        style: GoogleFonts.outfit(
                          fontSize: 42 * FlutterFlowTheme.fontSizeFactor,
                          fontWeight: FontWeight.w800,
                          color: FlutterFlowTheme.of(context).primaryText,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Calidad garantizada y entrega inmediata en todos nuestros productos digitales.',
                        style: GoogleFonts.outfit(
                          fontSize: 16 * FlutterFlowTheme.fontSizeFactor,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                // Imagen ilustrativa
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: Icon(Icons.rocket_launch_rounded,
                      size: 120,
                      color: FlutterFlowTheme.of(context)
                          .primaryText
                          .withValues(alpha: 0.8)),
                )
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
