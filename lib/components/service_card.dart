import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/safe_image.dart';
import '/models/service_model.dart';
import '/utils/color_utils.dart';
import '/backend/currency_service.dart';
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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Use passed color or parse from service
    final cardColor = widget.primaryColor ??
        ColorUtils.parseColor(context, widget.service.branding.primaryColor);

    // Calculate prices
    final currentPrice = widget.service.price;
    final priceStr = CurrencyService.formatFromUSD(currentPrice);

    final borderColor =
        _isHovered ? cardColor.withValues(alpha: 0.5) : theme.alternate;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            'service_detail',
            extra: widget.service,
            pathParameters: {
              'serviceId': widget.service.id,
            },
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translateByDouble(0.0, _isHovered ? -8.0 : 0.0, 0.0, 1.0),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: cardColor.withValues(alpha: 0.25),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. HEADER IMAGEN (约 55% 的高度)
                Expanded(
                  flex: 11,
                  child: Stack(
                    children: [
                      // Fondo Imagen
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: theme.secondaryBackground,
                        child: widget.service.branding.logoUrl != null
                            ? SafeImage(
                                widget.service.branding.logoUrl!,
                                fit: BoxFit.cover,
                                allowRemoteDownload:
                                    true, // Fixed: Allow remote download
                                placeholder: _buildPlaceholder(cardColor),
                              )
                            : _buildPlaceholder(cardColor),
                      ),

                      // Status Badge (Corner)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.service.isInStock
                                ? theme.accent3 // Green for Available
                                : theme.error, // Red for Sold Out
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.service.isInStock ? 'DISPONIBLE' : 'AGOTADO',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. INFO CONTENT (约 45% 的高度)
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    color: theme.secondaryBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Header con Título y Favorito
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(
                                    widget.service.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      color: theme.primaryText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      height: 1.2,
                                    ),
                                  ),
                                  // Description logic: Service description OR First Listing description
                                  Builder(builder: (context) {
                                    String descriptionToShow =
                                        widget.service.description;
                                    if (descriptionToShow.isEmpty &&
                                        widget.service.listings != null &&
                                        widget.service.listings!.isNotEmpty) {
                                      // Try to find a non-empty description in listings
                                      for (var l in widget.service.listings!) {
                                        if (l.description != null &&
                                            l.description!.isNotEmpty) {
                                          descriptionToShow = l.description!;
                                          break;
                                        }
                                      }
                                    }

                                    if (descriptionToShow.isNotEmpty) {
                                      return Column(
                                        children: [
                                          const SizedBox(height: 6),
                                          Text(
                                            descriptionToShow,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.outfit(
                                              color: theme.secondaryText,
                                              fontSize: 12,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }),
                                  const SizedBox(height: 8),
                                  // Rating Stars - Always visible
                                  Row(
                                    children: [
                                      Icon(Icons.star_rounded,
                                          color: widget.service.stats
                                                      .totalReviews >
                                                  0
                                              ? theme.warning
                                              : theme.alternate,
                                          size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.service.stats.totalReviews > 0
                                            ? '${widget.service.stats.averageRating.toStringAsFixed(1)} (${widget.service.stats.totalReviews})'
                                            : 'Sin calificaciones',
                                        style: GoogleFonts.outfit(
                                          color: theme.secondaryText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ])),
                            // Botón de Favoritos
                            InkWell(
                              onTap: () async {
                                // Toggle local state first for responsiveness
                                setState(() {
                                  widget.service.isFavorite =
                                      !widget.service.isFavorite;
                                });

                                // Call backend
                                final success =
                                    await FavoritesService.toggleFavorite(
                                        widget.service.id);

                                // Revert if failed
                                if (!success) {
                                  setState(() {
                                    widget.service.isFavorite =
                                        !widget.service.isFavorite;
                                  });
                                }
                              },
                              child: Icon(
                                widget.service.isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: widget.service.isFavorite
                                    ? theme.error
                                    : theme.secondaryText,
                                size: 20,
                              ),
                            ),
                          ],
                        ),

                        // Footer: Precios y Botón
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 2),
                                  Text(
                                    priceStr,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      color: widget.service.isInStock
                                          ? cardColor
                                          : theme.secondaryText,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      decoration: widget.service.isInStock
                                          ? null
                                          : TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _isHovered
                                      ? [
                                          cardColor,
                                          cardColor.withValues(alpha: 0.8)
                                        ]
                                      : [theme.alternate, theme.alternate],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: _isHovered
                                    ? [
                                        BoxShadow(
                                          color:
                                              cardColor.withValues(alpha: 0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        )
                                      ]
                                    : [],
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: _isHovered
                                    ? Colors.white
                                    : theme.secondaryText,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(Color color) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: theme.secondaryBackground,
          image: DecorationImage(
              image: const NetworkImage(
                  "https://www.transparenttextures.com/patterns/cubes.png"),
              colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.8), BlendMode.dstATop),
              fit: BoxFit.cover)),
      child: Center(
        child: Icon(Icons.rocket_launch,
            size: 32, color: color.withValues(alpha: 0.3)),
      ),
    );
  }
}
