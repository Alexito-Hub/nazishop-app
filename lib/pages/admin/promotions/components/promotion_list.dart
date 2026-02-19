import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:nazi_shop/models/offer_model.dart';
import 'promotion_card.dart';

class PromotionList extends StatelessWidget {
  final List<Offer> promotions;
  final Function(Offer) onEdit;
  final bool isDesktop;

  const PromotionList({
    super.key,
    required this.promotions,
    required this.onEdit,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    if (promotions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.circle,
                border:
                    Border.all(color: FlutterFlowTheme.of(context).alternate),
              ),
              child: Icon(
                Icons.campaign_outlined,
                size: 40,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay promociones activas',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText),
            ),
          ],
        ),
      );
    }

    if (isDesktop) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          mainAxisExtent: 180, // Allow card height
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return PromotionCard(
            item: promotions[index],
            onTap: () => onEdit(promotions[index]),
          );
        }, childCount: promotions.length),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = promotions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PromotionCard(
            item: item,
            onTap: () => onEdit(item),
          ).animate().fadeIn(delay: (30 * index).ms).slideX(begin: 0.1),
        );
      }, childCount: promotions.length),
    );
  }
}
