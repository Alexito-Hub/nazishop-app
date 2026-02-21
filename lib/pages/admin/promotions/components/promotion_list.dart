import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/models/promotion_model.dart';
import '/components/app_empty_state.dart';
import 'promotion_card.dart';

class PromotionList extends StatelessWidget {
  final List<Promotion> promotions;
  final Function(Promotion) onEdit;
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
      return const Center(
        child: AppEmptyState(
          icon: Icons.campaign_outlined,
          message: 'No hay promociones activas',
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
