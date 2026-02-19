import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../models/listing_model.dart';
import '../../../../components/listing_card.dart';

class ServicePricing extends StatelessWidget {
  final List<Listing> listings;
  final int selectedIndex;
  final Color primaryColor;
  final Function(int) onSelect;
  final Function(Listing) onPurchase;

  const ServicePricing({
    super.key,
    required this.listings,
    required this.selectedIndex,
    required this.primaryColor,
    required this.onSelect,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return _NoStockWidget();
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, index) {
        final listing = listings[index];
        return ListingCard(
          listing: listing,
          isSelected: selectedIndex == index,
          primaryColor: primaryColor,
          onTap: () => onSelect(index),
          onPurchase: () => onPurchase(listing),
          durationText: _getListingDuration(listing),
        );
      },
    );
  }

  String _getListingDuration(Listing listing) {
    final commercial = listing.commercial;
    if (commercial == null || commercial.duration == null) return '';
    final unit = commercial.timeUnit ?? 'mes';
    // Handle simplified plural logic if needed or keep existing
    return '${commercial.duration} $unit${commercial.duration! > 1 ? 'es' : ''}';
  }
}

class _NoStockWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 40, color: FlutterFlowTheme.of(context).secondaryText),
          const SizedBox(height: 8),
          Text(
            "Sin stock disponible por el momento",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
