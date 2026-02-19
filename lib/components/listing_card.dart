import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../models/listing_model.dart';
import '../../backend/currency_service.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;
  final VoidCallback onPurchase;
  final String durationText;

  const ListingCard({
    super.key,
    required this.listing,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
    required this.onPurchase,
    required this.durationText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    // Listings don't have discount logic for now

    final title = listing.commercial?.plan ?? listing.description ?? 'Standard';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.04)
              : theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.25)
                : theme.alternate,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: primaryColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16 * FlutterFlowTheme.fontSizeFactor,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (listing.description != null &&
                listing.description!.isNotEmpty) ...[
              Text(
                listing.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  color: theme.secondaryText,
                  fontSize: 13 * FlutterFlowTheme.fontSizeFactor,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CurrencyService.formatFromUSD(listing.price),
                      style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontWeight: FontWeight.w900,
                        fontSize: 20 * FlutterFlowTheme.fontSizeFactor,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onPurchase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  child: Text(
                    "Comprar",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (durationText.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.timer_outlined,
                      size: 14, color: theme.secondaryText),
                  const SizedBox(width: 4),
                  Text(
                    durationText,
                    style: GoogleFonts.outfit(
                      color: theme.secondaryText,
                      fontSize: 12 * FlutterFlowTheme.fontSizeFactor,
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
