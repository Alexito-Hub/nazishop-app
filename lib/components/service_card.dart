import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/components/app_product_card.dart';
import '/models/service_model.dart';
import '/utils/color_utils.dart';
import '/backend/favorites_service.dart';

class ServiceCard extends StatefulWidget {
  final Service service;
  final bool isDesktop;
  final Color? primaryColor;

  const ServiceCard({
    super.key,
    required this.service,
    this.isDesktop = false,
    this.primaryColor,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    // Use passed color or parse from service
    final cardColor = widget.primaryColor ??
        ColorUtils.parseColor(context, widget.service.branding.primaryColor);

    // Description logic: Service description OR First Listing description
    String descriptionToShow = widget.service.description;
    if (descriptionToShow.isEmpty &&
        widget.service.listings != null &&
        widget.service.listings!.isNotEmpty) {
      for (var l in widget.service.listings!) {
        if (l.description != null && l.description!.isNotEmpty) {
          descriptionToShow = l.description!;
          break;
        }
      }
    }

    return AppProductCard(
      variant: AppProductCardVariant.standard,
      title: widget.service.name,
      description: descriptionToShow,
      imageUrl: widget.service.branding.logoUrl,
      price: widget.service.price,
      primaryColor: cardColor,
      isFavorite: widget.service.isFavorite,
      onFavoriteToggle: () async {
        setState(() => widget.service.isFavorite = !widget.service.isFavorite);
        final success =
            await FavoritesService.toggleFavorite(widget.service.id);
        if (!success && mounted) {
          setState(
              () => widget.service.isFavorite = !widget.service.isFavorite);
        }
      },
      isInStock: widget.service.isInStock,
      rating: widget.service.stats.averageRating,
      totalReviews: widget.service.stats.totalReviews,
      onTap: () {
        context.pushNamed(
          'service_detail',
          extra: widget.service,
          pathParameters: {'serviceId': widget.service.id},
        );
      },
    );
  }
}
