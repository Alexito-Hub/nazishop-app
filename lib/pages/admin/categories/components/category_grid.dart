import 'package:flutter/material.dart';
import '/models/category_model.dart';
import '/components/app_empty_state.dart';
import 'category_card.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;
  final Function(String) onDelete;
  final VoidCallback onRefresh;
  final bool isDesktop;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onDelete,
    required this.onRefresh,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: AppEmptyState(
            icon: Icons.category_outlined,
            message: 'No hay categorías creadas',
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        mainAxisExtent: 240,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final category = categories[index];
          return CategoryCard(
            category: category,
            onDelete: () => onDelete(category.id),
            onRefresh: onRefresh,
          );
        },
        childCount: categories.length,
      ),
    );
  }
}
