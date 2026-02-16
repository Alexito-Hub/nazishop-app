import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/offer_model.dart';
import '../../../backend/currency_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ServiceOfferCard extends StatelessWidget {
  final Offer offer;
  final Color primaryColor;
  final bool isPackage;
  final VoidCallback onPurchase;

  const ServiceOfferCard({
    super.key,
    required this.offer,
    required this.primaryColor,
    required this.isPackage,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasStock = offer.inStock;
    final int stockCount = offer.availableStock ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).alternate,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: hasStock
              ? primaryColor.withValues(alpha: 0.1)
              : FlutterFlowTheme.of(context).alternate,
          width: 1.5,
        ),
        boxShadow: [
          if (hasStock)
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: FlutterFlowTheme.of(context).transparent,
        child: InkWell(
          onTap: hasStock ? onPurchase : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 20), // Reduced from 24
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isPackage)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'PAQUETE',
                                    style: GoogleFonts.outfit(
                                      color: primaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              if (offer.ui.badge != null &&
                                  offer.ui.badge!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .secondary
                                            .withValues(alpha: 0.1)),
                                  ),
                                  child: Text(
                                    offer.ui.badge!.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              Flexible(
                                child: Text(
                                  offer.title,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: hasStock
                                        ? FlutterFlowTheme.of(context)
                                            .primaryText
                                        : FlutterFlowTheme.of(context)
                                            .alternate,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (offer.description != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              offer.description!,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isPackage && offer.discountPercent > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, primaryColor.withRed(255)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          '-${offer.discountPercent}%',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isPackage &&
                            offer.originalPrice > offer.discountPrice) ...[
                          Text(
                            CurrencyService.formatFromUSD(offer.originalPrice),
                            style: GoogleFonts.outfit(
                              decoration: TextDecoration.lineThrough,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          CurrencyService.formatFromUSD(offer.discountPrice),
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: hasStock
                                ? FlutterFlowTheme.of(context).primaryText
                                : FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                        if (hasStock && stockCount > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: stockCount > 5
                                      ? FlutterFlowTheme.of(context).success
                                      : stockCount > 2
                                          ? FlutterFlowTheme.of(context).warning
                                          : FlutterFlowTheme.of(context).error,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (stockCount > 5
                                              ? FlutterFlowTheme.of(context)
                                                  .success
                                              : stockCount > 2
                                                  ? FlutterFlowTheme.of(context)
                                                      .warning
                                                  : FlutterFlowTheme.of(context)
                                                      .error)
                                          .withValues(alpha: 0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$stockCount disponibles',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(width: 16),
                    _buildBuyButton(context, hasStock),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBuyButton(BuildContext context, bool hasStock) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: hasStock
            ? LinearGradient(
                colors: [primaryColor, primaryColor.withValues(alpha: 0.1)],
              )
            : null,
        color: hasStock ? null : FlutterFlowTheme.of(context).alternate,
        boxShadow: [
          if (hasStock)
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ElevatedButton(
        onPressed: hasStock ? onPurchase : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: FlutterFlowTheme.of(context).transparent,
          foregroundColor: FlutterFlowTheme.of(context).primaryText,
          shadowColor: FlutterFlowTheme.of(context).transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasStock ? Icons.shopping_basket_outlined : Icons.block_flipped,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              hasStock ? 'COMPRAR' : 'SIN STOCK',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
