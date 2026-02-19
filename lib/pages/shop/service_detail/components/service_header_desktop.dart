import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/safe_image.dart';
import '../../../../models/service_model.dart';
import '../../../../models/offer_model.dart';

class ServiceHeaderDesktop extends StatelessWidget {
  final Service service;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final Color primaryColor;
  final List<DisplayTag> tags;

  const ServiceHeaderDesktop({
    super.key,
    required this.service,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.primaryColor,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: FlutterFlowTheme.of(context).alternate),
              ),
              child: service.branding.logoUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SafeImage(service.branding.logoUrl!,
                          fit: BoxFit.cover),
                    )
                  : Icon(Icons.rocket_launch, color: primaryColor, size: 40),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(service.name,
                          style: GoogleFonts.outfit(
                              fontSize: 42 * FlutterFlowTheme.fontSizeFactor,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText)),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .alternate
                              .withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isFavorite
                                ? FlutterFlowTheme.of(context)
                                    .error
                                    .withValues(alpha: 0.5)
                                : FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? FlutterFlowTheme.of(context).error
                                : FlutterFlowTheme.of(context).secondaryText,
                            size: 28,
                          ),
                          onPressed: onToggleFavorite,
                          tooltip: isFavorite
                              ? "Quitar de favoritos"
                              : "Añadir a favoritos",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatusBadge(isOpen: service.isInStock),
                      const SizedBox(width: 12),
                      if (service.categoryName != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .alternate
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate),
                          ),
                          child: Text(service.categoryName!,
                              style: GoogleFonts.outfit(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize:
                                      14 * FlutterFlowTheme.fontSizeFactor)),
                        ),
                    ],
                  ),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: tags.map((t) => _buildTag(context, t)).toList(),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),

        // Banner Image
        if (service.branding.bannerUrl != null)
          Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: primaryColor.withValues(alpha: 0.15),
                    blurRadius: 40,
                    offset: const Offset(0, 10)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SafeImage(service.branding.bannerUrl, fit: BoxFit.cover),
            ),
          ),
      ],
    );
  }

  Widget _buildTag(BuildContext context, DisplayTag tag) {
    final color =
        _parseColor(tag.color) ?? FlutterFlowTheme.of(context).primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        tag.text ?? '',
        style: GoogleFonts.outfit(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return null;
    }
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
