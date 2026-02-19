import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/safe_image.dart';

class PurchaseCard extends StatefulWidget {
  final Map<String, dynamic> order;
  const PurchaseCard({super.key, required this.order});

  @override
  State<PurchaseCard> createState() => _PurchaseCardState();
}

class _PurchaseCardState extends State<PurchaseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final status = widget.order['status']?.toLowerCase() ?? '';
    final serviceName = widget.order['serviceName'] ?? 'Servicio';
    final price = (widget.order['totalAmount'] ?? 0.0).toDouble();
    final rawOrderId = widget.order['_id']?.toString() ?? '';
    final dateStr = widget.order['createdAt'];
    final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
    final formattedDate = date != null ? DateFormat('dd MMM').format(date) : '';

    // Extract logo from order items
    final items = widget.order['items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty ? items[0] : null;
    final listingSnapshot = firstItem?['listingSnapshot'];
    final branding = listingSnapshot?['branding'];
    final logoUrl = branding?['logoUrl'];
    // Try to get primary color from branding
    final String? colorString = branding?['primaryColor'];
    Color primaryColor = FlutterFlowTheme.of(context).primary;
    if (colorString != null) {
      try {
        String hex = colorString.replaceAll('#', '');
        if (hex.length == 6) hex = 'FF$hex';
        primaryColor = Color(int.parse(hex, radix: 16));
      } catch (_) {}
    }

    // Status Conf
    Color statusColor;
    final theme = FlutterFlowTheme.of(context);
    String statusText;
    IconData statusIcon;
    switch (status) {
      case 'paid':
      case 'completed':
        statusColor = theme.success;
        statusText = 'COMPLETADO';
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = theme.warning;
        statusText = 'PENDIENTE';
        statusIcon = Icons.access_time_filled;
        break;
      default:
        statusColor = theme.error;
        statusText = 'CANCELADO';
        statusIcon = Icons.cancel;
    }

    final borderColor =
        _isHovered ? primaryColor.withValues(alpha: 0.5) : theme.alternate;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (status == 'paid' || status == 'completed') {
            context.pushNamed(
              'view_credentials',
              queryParameters: {'orderId': rawOrderId},
            );
          }
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
                      color: primaryColor.withValues(alpha: 0.25),
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
                // 1. HEADER IMAGEN (55%)
                Expanded(
                  flex: 11,
                  child: Stack(
                    children: [
                      // Fondo Imagen
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: theme.secondaryBackground,
                        child: logoUrl != null
                            ? SafeImage(
                                logoUrl,
                                fit: BoxFit.cover,
                                allowRemoteDownload: false,
                                placeholder: _buildPlaceholder(primaryColor),
                              )
                            : _buildPlaceholder(primaryColor),
                      ),

                      // Gradiente Overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.transparent,
                                Colors.black.withValues(alpha: 0.6)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Status Badge (Top Left)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                color: Colors.white,
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: GoogleFonts.outfit(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Date Badge (Top Right)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Text(
                            formattedDate,
                            style: GoogleFonts.outfit(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. INFO CONTENT (45%)
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    color: theme.secondaryBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serviceName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                color: theme.primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 15 * FlutterFlowTheme.fontSizeFactor,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Star Rating
                            _buildRatingStars(rawOrderId),
                            const SizedBox(height: 4),
                            Text(
                              'ID: $rawOrderId',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                  color: theme.secondaryText,
                                  fontSize:
                                      12 * FlutterFlowTheme.fontSizeFactor,
                                  height: 1.3),
                            ),
                          ],
                        ),
                        const Expanded(child: SizedBox()),

                        // Footer: Precio y Botón
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                '\$${price.toStringAsFixed(2)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  color: theme.primaryText,
                                  fontWeight: FontWeight.w900,
                                  fontSize:
                                      18 * FlutterFlowTheme.fontSizeFactor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (status == 'paid' || status == 'completed')
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _isHovered
                                        ? [
                                            primaryColor,
                                            primaryColor.withValues(alpha: 0.8)
                                          ]
                                        : [theme.alternate, theme.alternate],
                                  ),
                                  shape: BoxShape.circle,
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

  Widget _buildRatingStars(String orderId) {
    final theme = FlutterFlowTheme.of(context);
    // Generate mock rating based on order ID hash for consistency
    final hash = orderId.hashCode.abs();
    final rating = 4.5 + ((hash % 5) / 10); // Generates 4.5-4.9

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            if (index < rating.floor()) {
              // Full star
              return Icon(
                Icons.star_rounded,
                color: theme.warning,
                size: 14,
              );
            } else if (index < rating) {
              // Half star
              return Icon(
                Icons.star_half_rounded,
                color: theme.warning,
                size: 14,
              );
            } else {
              // Empty star
              return Icon(
                Icons.star_outline_rounded,
                color: theme.secondaryText.withValues(alpha: 0.3),
                size: 14,
              );
            }
          }),
        ),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: GoogleFonts.outfit(
            color: theme.secondaryText,
            fontSize: 12 * FlutterFlowTheme.fontSizeFactor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
        child: Icon(Icons.shopping_bag_outlined,
            size: 40, color: color.withValues(alpha: 0.3)),
      ),
    );
  }
}
