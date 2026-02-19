import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:nazi_shop/models/promotion_model.dart';

class PromotionCard extends StatelessWidget {
  final Promotion item;
  final VoidCallback? onTap;

  const PromotionCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bool isExpired =
        item.validUntil != null && item.validUntil!.isBefore(DateTime.now());
    final bool isActive = item.isActive && !isExpired;
    final color = isActive ? theme.success : theme.error;
    final statusText =
        isActive ? 'Activa' : (isExpired ? 'Expirada' : 'Inactiva');

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Material(
        color: theme.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.outfit(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (item.isFeatured)
                      Icon(Icons.star, color: theme.warning, size: 16),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.description ?? 'Sin descripción',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: theme.secondaryText,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Divider(color: theme.alternate),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.finalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.validUntil != null)
                      Text(
                        'Hasta: ${DateFormat('dd MMM').format(item.validUntil!)}',
                        style: GoogleFonts.outfit(
                          color: theme.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
