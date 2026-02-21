import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/components/safe_image.dart';
import '/components/app_card.dart';

enum AppProductCardVariant { standard, purchase, listing }

class AppProductCard extends StatelessWidget {
  final AppProductCardVariant variant;
  final String title;
  final String? description;
  final String? imageUrl;
  final double price;
  final Color primaryColor;
  final VoidCallback? onTap;
  final VoidCallback? onActionPressed;
  final String? actionLabel;
  final bool isHoverEffect;
  final bool isSelected;

  // Specific properties
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final bool isInStock;
  final double? rating;
  final int? totalReviews;
  final String? statusText;
  final Color? statusColor;
  final IconData? statusIcon;
  final String? subtitle; // e.g. Order ID
  final String? dateText;
  final String? footerSecondaryText; // e.g. Duration

  const AppProductCard({
    super.key,
    this.variant = AppProductCardVariant.standard,
    required this.title,
    this.description,
    this.imageUrl,
    required this.price,
    required this.primaryColor,
    this.onTap,
    this.onActionPressed,
    this.actionLabel,
    this.isHoverEffect = true,
    this.isSelected = false,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.isInStock = true,
    this.rating,
    this.totalReviews,
    this.statusText,
    this.statusColor,
    this.statusIcon,
    this.subtitle,
    this.dateText,
    this.footerSecondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      hoverEffect: isHoverEffect,
      hoverOffset: -6.0,
      backgroundColor: isSelected ? primaryColor.withValues(alpha: 0.04) : null,
      hoverBorderColor: primaryColor.withValues(alpha: 0.5),
      hoverShadowColor: primaryColor.withValues(alpha: 0.25),
      onTap: onTap,
      padding: EdgeInsets.zero,
      builder: (context, isHovered, child) {
        final content = variant == AppProductCardVariant.listing
            ? _buildListingLayout(context, isHovered)
            : _buildVerticalLayout(context, isHovered);

        if (!isSelected) return content;

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: content,
        );
      },
    );
  }

  Widget _buildVerticalLayout(BuildContext context, bool isHovered) {
    final theme = FlutterFlowTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. IMAGE HEADER (60% of card height)
        Expanded(
          flex: 6,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image / Placeholder
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? SafeImage(
                        imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: primaryColor.withValues(alpha: 0.12),
                        child: Center(
                          child: Icon(
                            variant == AppProductCardVariant.purchase
                                ? Icons.shopping_bag_outlined
                                : Icons.rocket_launch_rounded,
                            size: 36,
                            color: primaryColor.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
              ),

              // Gradient overlay at bottom of image for smooth transition
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.secondaryBackground.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ),

              // Status Badge (top-left for purchase, top-right for standard)
              if (statusText != null || !isInStock)
                Positioned(
                  top: 10,
                  left: variant == AppProductCardVariant.purchase ? 10 : null,
                  right: variant == AppProductCardVariant.standard ? 10 : null,
                  child: _buildStatusBadge(context),
                ),

              // Date Badge (Purchase only, top-right)
              if (dateText != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: _buildDateBadge(context),
                ),
            ],
          ),
        ),

        // 2. INFO CONTENT (40% of card height)
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top section: title + favorite icon
                Expanded(
                  child: SingleChildScrollView(
                    physics:
                        const NeverScrollableScrollPhysics(), // Card is too small to scroll comfortably, but this prevents overflow crash
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  color: theme.primaryText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            if (onFavoriteToggle != null)
                              GestureDetector(
                                onTap: onFavoriteToggle,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: isFavorite
                                        ? theme.error
                                        : theme.secondaryText,
                                    size: 18,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (description != null && description!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: theme.secondaryText,
                              fontSize: 11,
                              height: 1.3,
                            ),
                          ),
                        ],
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: theme.secondaryText,
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                        ],
                        if (rating != null) ...[
                          const SizedBox(height: 3),
                          _buildRating(context),
                        ],
                      ],
                    ),
                  ),
                ),

                // Bottom: price + action button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _formatPrice(price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: isInStock ? primaryColor : theme.secondaryText,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          decoration:
                              isInStock ? null : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _buildActionButton(context, isHovered),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListingLayout(BuildContext context, bool isHovered) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.primaryText,
            ),
          ),
          if (description != null && description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                color: theme.secondaryText,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatPrice(price),
                style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              if (onActionPressed != null)
                ElevatedButton(
                  onPressed: onActionPressed,
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
                    actionLabel ?? "Comprar",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          if (footerSecondaryText != null &&
              footerSecondaryText!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer_outlined,
                    size: 14, color: theme.secondaryText),
                const SizedBox(width: 4),
                Text(
                  footerSecondaryText!,
                  style: GoogleFonts.outfit(
                    color: theme.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final color = statusColor ?? (isInStock ? theme.accent3 : theme.error);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (statusIcon != null) ...[
            Icon(statusIcon, color: Colors.white, size: 10),
            const SizedBox(width: 3),
          ],
          Text(
            statusText?.toUpperCase() ?? (isInStock ? 'DISPONIBLE' : 'AGOTADO'),
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Text(
        dateText!,
        style: GoogleFonts.outfit(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget _buildRating(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      children: [
        Icon(
          Icons.star_rounded,
          color: (rating ?? 0) > 0 ? theme.warning : theme.alternate,
          size: 13,
        ),
        const SizedBox(width: 3),
        Text(
          (rating ?? 0) > 0
              ? '${rating!.toStringAsFixed(1)}${totalReviews != null ? ' ($totalReviews)' : ''}'
              : 'Sin calificaciones',
          style: GoogleFonts.outfit(
            color: theme.secondaryText,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, bool isHovered) {
    final theme = FlutterFlowTheme.of(context);

    if (variant == AppProductCardVariant.purchase &&
        statusText != 'COMPLETADO') {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isHovered
              ? [primaryColor, primaryColor.withValues(alpha: 0.75)]
              : [
                  theme.alternate.withValues(alpha: 0.8),
                  theme.alternate.withValues(alpha: 0.8)
                ],
        ),
        shape: BoxShape.circle,
        boxShadow: isHovered
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
            : [],
      ),
      child: Icon(
        Icons.arrow_forward_rounded,
        color: isHovered ? Colors.white : theme.secondaryText,
        size: 17,
      ),
    );
  }

  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(price == price.toInt() ? 0 : 2)}';
  }
}
