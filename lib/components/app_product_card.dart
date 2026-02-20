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
      hoverOffset: -8.0,
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
            borderRadius: BorderRadius.circular(16),
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
        // 1. IMAGE HEADER (約 55%)
        Expanded(
          flex: 11,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: theme.secondaryBackground,
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? SafeImage(
                        imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : _buildPlaceholder(context),
              ),

              // Status Badge
              if (statusText != null || !isInStock)
                Positioned(
                  top: 12,
                  left: variant == AppProductCardVariant.purchase ? 12 : null,
                  right: variant == AppProductCardVariant.standard ? 12 : null,
                  child: _buildStatusBadge(context),
                ),

              // Date Badge (Purchase only)
              if (dateText != null)
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildDateBadge(context),
                ),
            ],
          ),
        ),

        // 2. INFO CONTENT (約 45%)
        Expanded(
          flex: 9,
          child: Container(
            padding: const EdgeInsets.all(14),
            color: theme.secondaryBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
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
                                  fontSize: 16,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            if (onFavoriteToggle != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: GestureDetector(
                                  onTap: onFavoriteToggle,
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: isFavorite
                                        ? theme.error
                                        : theme.secondaryText,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (description != null && description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            description!,
                            maxLines: 2,
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
                              fontSize: 11,
                              height: 1.2,
                            ),
                          ),
                        ],
                        if (rating != null) ...[
                          const SizedBox(height: 4),
                          _buildRating(context),
                        ],
                      ],
                    ),
                  ),
                ),

                // Footer
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          _formatPrice(price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            color:
                                isInStock ? primaryColor : theme.secondaryText,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            decoration:
                                isInStock ? null : TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(context, isHovered),
                    ],
                  ),
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
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (statusIcon != null) ...[
            Icon(statusIcon, color: Colors.white, size: 10),
            const SizedBox(width: 4),
          ],
          Text(
            statusText?.toUpperCase() ?? (isInStock ? 'DISPONIBLE' : 'AGOTADO'),
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 10,
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
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          (rating ?? 0) > 0
              ? '${rating!.toStringAsFixed(1)}${totalReviews != null ? ' ($totalReviews)' : ''}'
              : 'Sin calificaciones',
          style: GoogleFonts.outfit(
            color: theme.secondaryText,
            fontSize: 12,
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

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isHovered
              ? [primaryColor, primaryColor.withValues(alpha: 0.8)]
              : [theme.alternate, theme.alternate],
        ),
        shape: BoxShape.circle,
        boxShadow: isHovered
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Icon(
        Icons.arrow_forward_rounded,
        color: isHovered ? Colors.white : theme.secondaryText,
        size: 20,
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        variant == AppProductCardVariant.purchase
            ? Icons.shopping_bag_outlined
            : Icons.rocket_launch,
        size: 32,
        color: primaryColor.withValues(alpha: 0.3),
      ),
    );
  }

  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(price == price.toInt() ? 0 : 2)}';
  }
}
