import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../components/safe_image.dart';
import '../../../../models/service_model.dart';
// Removed unused utils import

class ServiceMobileHeaderBackground extends StatelessWidget {
  final Service service;
  final Color primaryColor;

  const ServiceMobileHeaderBackground({
    super.key,
    required this.service,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (service.branding.bannerUrl != null)
          SafeImage(
            service.branding.bannerUrl,
            fit: BoxFit.cover,
          ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).transparent,
                (FlutterFlowTheme.of(context).primaryBackground)
                    .withValues(alpha: 0.0),
                (FlutterFlowTheme.of(context).primaryBackground)
                    .withValues(alpha: 0.8),
                FlutterFlowTheme.of(context).primaryBackground,
              ],
              stops: const [0.0, 0.3, 0.75, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate),
                    boxShadow: [
                      BoxShadow(
                          color: primaryColor.withValues(alpha: 0.2),
                          blurRadius: 15)
                    ]),
                child: service.branding.logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SafeImage(service.branding.logoUrl!,
                            fit: BoxFit.cover),
                      )
                    : Icon(Icons.layers, color: primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      service.name,
                      style: GoogleFonts.outfit(
                        fontSize: 24 * FlutterFlowTheme.fontSizeFactor,
                        fontWeight: FontWeight.bold,
                        color: FlutterFlowTheme.of(context).primaryText,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _StatusBadge(isOpen: service.isInStock),
                        if (service.categoryName != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            service.categoryName!,
                            style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 13 * FlutterFlowTheme.fontSizeFactor),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isOpen;
  const _StatusBadge({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen
            ? FlutterFlowTheme.of(context).success.withValues(alpha: 0.2)
            : FlutterFlowTheme.of(context).error.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isOpen
              ? FlutterFlowTheme.of(context).success.withValues(alpha: 0.5)
              : FlutterFlowTheme.of(context).error.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        isOpen ? 'DISPONIBLE' : 'AGOTADO',
        style: GoogleFonts.outfit(
          color: isOpen
              ? FlutterFlowTheme.of(context).success
              : FlutterFlowTheme.of(context).error,
          fontSize: 11 * FlutterFlowTheme.fontSizeFactor,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
