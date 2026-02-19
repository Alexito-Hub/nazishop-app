import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/models/service_model.dart';
import '/models/listing_model.dart';
import '/utils/color_utils.dart';

class CheckoutProductCard extends StatelessWidget {
  final Service service;
  final Listing selectedListing;
  final bool isDesktop;

  const CheckoutProductCard({
    super.key,
    required this.service,
    required this.selectedListing,
    this.isDesktop = false,
  });

  String _getListingDuration() {
    final commercial = selectedListing.commercial;
    if (commercial == null || commercial.duration == null) return '';
    final unit = commercial.timeUnit ?? 'mes';
    return '${commercial.duration} $unit${commercial.duration! > 1 ? 'es' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return _buildDesktopLayout(context);
    }
    return _buildMobileLayout(context);
  }

  Widget _buildMobileLayout(BuildContext context) {
    final primaryColor =
        ColorUtils.parseColor(context, service.branding.primaryColor);
    final duration = _getListingDuration();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: service.branding.logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(service.branding.logoUrl!,
                        fit: BoxFit.contain),
                  )
                : Icon(Icons.subscriptions, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name,
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 15 * FlutterFlowTheme.fontSizeFactor,
                        fontWeight: FontWeight.w600)),
                Text(selectedListing.commercial?.plan ?? 'Standard',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12 * FlutterFlowTheme.fontSizeFactor)),
                if (duration.isNotEmpty)
                  Text(duration,
                      style: GoogleFonts.outfit(
                          color: primaryColor,
                          fontSize: 11 * FlutterFlowTheme.fontSizeFactor,
                          fontWeight: FontWeight.w600)),
                if (selectedListing.delivery?.type != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .alternate
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getDeliveryLabel(selectedListing.delivery?.type),
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 10 * FlutterFlowTheme.fontSizeFactor),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // No discount logic for now
              Text('\$${selectedListing.price.toStringAsFixed(2)}',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final primaryColor =
        ColorUtils.parseColor(context, service.branding.primaryColor);
    final duration = _getListingDuration();
    // final hasDiscount = false; // logic removed for now

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color:
                  FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: service.branding.logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(service.branding.logoUrl!,
                        fit: BoxFit.contain),
                  )
                : Icon(Icons.subscriptions, color: primaryColor, size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name,
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(selectedListing.commercial?.plan ?? 'Standard',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14)),
                if (duration.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .alternate
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate),
                        ),
                        child: Text(duration,
                            style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                      if (selectedListing.delivery?.type != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .info
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .info
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Text(
                              _getDeliveryLabel(selectedListing.delivery?.type),
                              style: GoogleFonts.outfit(
                                  color: FlutterFlowTheme.of(context).info,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // No discount logic
              Text('\$${selectedListing.price.toStringAsFixed(2)}',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  String _getDeliveryLabel(String? type) {
    switch (type) {
      case 'full_account':
        return 'Cuenta Completa';
      case 'profile_access':
        return 'Perfil Individual';
      case 'domain':
        return 'Dominio Propio';
      default:
        return 'Licencia Digital';
    }
  }
}
