import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/models/category_model.dart';

class CategorySelector extends StatelessWidget {
  final List<Category> categories;
  final String? selectedId;
  final Function(String?) onSelect;
  final bool isLoading;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelect,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, __) => Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .secondaryText
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                  ))
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                  color: FlutterFlowTheme.of(context)
                      .accent1
                      .withValues(alpha: 0.3)),
        ),
      );
    }

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final cat = isAll ? null : categories[index - 1];
          final isSelected = isAll ? selectedId == null : selectedId == cat!.id;
          final primaryColor = FlutterFlowTheme.of(context).primary;

          return GestureDetector(
            onTap: () => onSelect(isAll ? null : cat!.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.8)
                      ])
                    : null,
                color: isSelected
                    ? null
                    : FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: isSelected
                        ? FlutterFlowTheme.of(context).transparent
                        : FlutterFlowTheme.of(context)
                            .alternate
                            .withValues(alpha: 0.2),
                    width: 1.5),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: primaryColor.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4))
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  isAll ? 'Todo' : cat!.name,
                  style: GoogleFonts.outfit(
                    color: isSelected
                        ? Colors.white // White on selected primary-colored chip
                        : FlutterFlowTheme.of(context).secondaryText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14 * FlutterFlowTheme.fontSizeFactor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
