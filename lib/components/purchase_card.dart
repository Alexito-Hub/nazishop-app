import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/components/safe_image.dart';

/// Horizontal purchase card used in the My Purchases page.
/// Shows image on the left, order details on the right.
class PurchaseCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const PurchaseCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final status = order['status']?.toLowerCase() ?? '';
    final serviceName = order['serviceName'] ?? 'Servicio';
    final price = (order['totalAmount'] ?? 0.0).toDouble();
    final rawOrderId = order['_id']?.toString() ?? '';
    final shortId = rawOrderId.length > 8
        ? '#${rawOrderId.substring(rawOrderId.length - 8).toUpperCase()}'
        : '#$rawOrderId';
    final dateStr = order['createdAt'];
    final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
    final formattedDate =
        date != null ? DateFormat('dd MMM yyyy').format(date) : '';

    // Extract logo from order items
    final items = order['items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty ? items[0] : null;
    final listingSnapshot = firstItem?['listingSnapshot'];
    final branding = listingSnapshot?['branding'];
    final logoUrl = branding?['logoUrl'];

    // Primary color from branding
    final String? colorString = branding?['primaryColor'];
    Color primaryColor = theme.primary;
    if (colorString != null) {
      try {
        String hex = colorString.replaceAll('#', '');
        if (hex.length == 6) hex = 'FF$hex';
        primaryColor = Color(int.parse(hex, radix: 16));
      } catch (_) {}
    }

    // Status config
    Color statusColor;
    String statusText;
    IconData statusIcon;
    bool isClickable = false;

    switch (status) {
      case 'paid':
      case 'completed':
        statusColor = theme.success;
        statusText = 'Completado';
        statusIcon = Icons.check_circle_rounded;
        isClickable = true;
        break;
      case 'pending':
        statusColor = theme.warning;
        statusText = 'Pendiente';
        statusIcon = Icons.access_time_filled_rounded;
        break;
      default:
        statusColor = theme.error;
        statusText = 'Cancelado';
        statusIcon = Icons.cancel_rounded;
    }

    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return _HoverableCard(
      primaryColor: primaryColor,
      onTap: isClickable
          ? () => context.pushNamed(
                'view_credentials',
                queryParameters: {'orderId': rawOrderId},
              )
          : null,
      child: Row(
        children: [
          // ── Left: Logo/Image ────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: isDesktop ? 100 : 80,
              height: isDesktop ? 100 : 80,
              child: logoUrl != null && logoUrl.isNotEmpty
                  ? SafeImage(logoUrl, fit: BoxFit.cover)
                  : Container(
                      color: primaryColor.withValues(alpha: 0.15),
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag_rounded,
                          size: isDesktop ? 36 : 28,
                          color: primaryColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 16),

          // ── Center: Details ─────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  serviceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: isDesktop ? 16 : 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.receipt_outlined,
                        size: 12, color: theme.secondaryText),
                    const SizedBox(width: 4),
                    Text(
                      shortId,
                      style: GoogleFonts.outfit(
                        color: theme.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (formattedDate.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 12, color: theme.secondaryText),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: GoogleFonts.outfit(
                          color: theme.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                // Status chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: statusColor.withValues(alpha: 0.4), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 12),
                      const SizedBox(width: 5),
                      Text(
                        statusText,
                        style: GoogleFonts.outfit(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ── Right: Price + Arrow ────────────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${price.toStringAsFixed(price == price.toInt() ? 0 : 2)}',
                style: GoogleFonts.outfit(
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: isDesktop ? 20 : 17,
                ),
              ),
              if (isClickable) ...[
                const SizedBox(height: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3), width: 1),
                  ),
                  child: Icon(Icons.arrow_forward_rounded,
                      color: primaryColor, size: 16),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HoverableCard extends StatefulWidget {
  final Widget child;
  final Color primaryColor;
  final VoidCallback? onTap;

  const _HoverableCard({
    required this.child,
    required this.primaryColor,
    this.onTap,
  });

  @override
  State<_HoverableCard> createState() => _HoverableCardState();
}

class _HoverableCardState extends State<_HoverableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(14),
          transform: Matrix4.identity()
            ..setTranslationRaw(0.0, _isHovered ? -4.0 : 0.0, 0.0),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? widget.primaryColor.withValues(alpha: 0.45)
                  : theme.alternate.withValues(alpha: 0.6),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.primaryColor.withValues(alpha: 0.2),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
