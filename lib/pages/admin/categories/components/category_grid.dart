import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/models/category_model.dart';
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
      return SliverToBoxAdapter(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Icon(Icons.category_outlined,
                  size: 64,
                  color: FlutterFlowTheme.of(context)
                      .primaryText
                      .withValues(alpha: 0.2)),
              const SizedBox(height: 16),
              Text(
                'No hay categorías creadas',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 18),
              ),
            ],
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
