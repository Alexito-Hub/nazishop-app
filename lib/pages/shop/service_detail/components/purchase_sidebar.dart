import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:nazi_shop/models/listing_model.dart';
import 'service_pricing.dart';

class PurchaseSidebar extends StatelessWidget {
  final List<Listing> listings;
  final int selectedIndex;
  final Color primaryColor;
  final Function(int) onSelect;
  final Function(Listing) onPurchase;

  const PurchaseSidebar({
    super.key,
    required this.listings,
    required this.selectedIndex,
    required this.primaryColor,
    required this.onSelect,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? FlutterFlowTheme.of(context).alternate
                    : FlutterFlowTheme.of(context)
                        .alternate
                        .withValues(alpha: 0.4),
              ),
              boxShadow: [
                if (Theme.of(context).brightness == Brightness.light)
                  BoxShadow(
                    color: FlutterFlowTheme.of(context)
                        .primaryText
                        .withValues(alpha: 0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.verified_outlined,
                          color: primaryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text("Elige una opción",
                        style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: FlutterFlowTheme.of(context).primaryText)),
                  ],
                ),
                const SizedBox(height: 24),
                ServicePricing(
                  listings: listings,
                  selectedIndex: selectedIndex,
                  primaryColor: primaryColor,
                  onSelect: onSelect,
                  onPurchase: onPurchase,
                ),
                const SizedBox(height: 16),
                Divider(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? FlutterFlowTheme.of(context).alternate
                        : FlutterFlowTheme.of(context)
                            .alternate
                            .withValues(alpha: 0.4)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_outlined,
                        size: 16,
                        color: FlutterFlowTheme.of(context).secondaryText),
                    const SizedBox(width: 8),
                    Text("Garantía de reembolso de 7 días",
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12)),
                  ],
                )
              ],
            ),
          ).animate().slideX(begin: 0.1, duration: 400.ms).fadeIn(),
        ],
      ),
    );
  }
}
