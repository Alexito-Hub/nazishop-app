import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/models/category_model.dart';
import '/utils/icon_utils.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = FlutterFlowTheme.of(context).primary;

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context)
            .secondaryBackground
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background icon flair
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              IconUtils.parseIcon(category.ui.icon),
              size: 120,
              color: primaryColor.withValues(alpha: 0.1),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await context.pushNamed(
                  'create_category',
                  extra: category,
                );
                onRefresh();
              },
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: primaryColor.withValues(alpha: 0.1)),
                          ),
                          child: Icon(
                            IconUtils.parseIcon(category.ui.icon),
                            color: primaryColor,
                            size: 24,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: category.isActive
                                ? FlutterFlowTheme.of(context)
                                    .success
                                    .withValues(alpha: 0.1)
                                : FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: category.isActive
                                  ? FlutterFlowTheme.of(context)
                                      .success
                                      .withValues(alpha: 0.1)
                                  : FlutterFlowTheme.of(context).alternate,
                            ),
                          ),
                          child: Text(
                            category.isActive ? 'ACTIVO' : 'INACTIVO',
                            style: GoogleFonts.outfit(
                              color: category.isActive
                                  ? FlutterFlowTheme.of(context).success
                                  : FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      category.name,
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.description,
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'ID: ...${category.id.substring(category.id.length - 6)}',
                          style: GoogleFonts.robotoMono(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 11,
                          ),
                        ),
                        const Spacer(),
                        _buildIconButton(
                          context,
                          Icons.edit_outlined,
                          FlutterFlowTheme.of(context).secondaryText,
                          () async {
                            await context.pushNamed(
                              'create_category',
                              extra: category,
                            );
                            onRefresh();
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildIconButton(
                          context,
                          Icons.delete_outline_rounded,
                          primaryColor,
                          onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
