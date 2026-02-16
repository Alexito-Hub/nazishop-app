import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/models/service_model.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/safe_image.dart';

class MobileCarouselCard extends StatelessWidget {
  final Service service;
  final Color categoryColor;
  final VoidCallback onTap;

  const MobileCarouselCard({
    super.key,
    required this.service,
    required this.categoryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: categoryColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with image or gradient
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: service.branding.logoUrl != null &&
                            service.branding.logoUrl!.isNotEmpty
                        ? [
                            categoryColor.withValues(alpha: 0.1),
                            categoryColor.withValues(alpha: 0.1),
                          ]
                        : [
                            categoryColor.withValues(alpha: 0.1),
                            categoryColor,
                          ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: service.branding.logoUrl != null &&
                        service.branding.logoUrl!.isNotEmpty
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child:
                                (service.branding.logoUrl?.startsWith('http') ??
                                        false)
                                    ? SafeImage(
                                        service.branding.logoUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        allowRemoteDownload: false,
                                        placeholder: _buildServiceIcon(context),
                                      )
                                    : _buildServiceIcon(context),
                          ),
                          // Overlay with price
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'S/ ${service.price.toStringAsFixed(0)}',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : _buildServiceIcon(context),
              ),
            ),
            // Service Information
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        service.name,
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.outfit(),
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        if (service.branding.logoUrl != null &&
                            service.branding.logoUrl!.isNotEmpty)
                          Expanded(
                            child: Text(
                              'S/ ${service.price.toStringAsFixed(0)}',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    color: categoryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 10,
                                color: Colors.green.shade600,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Activo',
                                style: TextStyle(
                                  color: Colors.green.shade600,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withValues(alpha: 0.1),
            categoryColor,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  service.name.isNotEmpty ? service.name[0].toUpperCase() : 'S',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  service.name,
                  style: GoogleFonts.outfit(
                    color: Colors.white.withValues(alpha: 0.1),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Price in overlay
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'S/ ${service.price.toStringAsFixed(0)}',
                style: GoogleFonts.outfit(
                  color: categoryColor,
                  fontSize: 12,
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
