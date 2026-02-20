import 'package:flutter/material.dart';
import '/components/app_product_card.dart';
import '/models/listing_model.dart';

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
    final title = listing.commercial?.plan ?? listing.description ?? 'Standard';

    return AppProductCard(
      variant: AppProductCardVariant.listing,
      title: title,
      description: listing.description,
      price: listing.price.toDouble(),
      primaryColor: primaryColor,
      isSelected: isSelected,
      onTap: onTap,
      onActionPressed: onPurchase,
      footerSecondaryText: durationText,
    );
  }
}
