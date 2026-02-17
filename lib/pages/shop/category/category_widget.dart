import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:nazi_shop/models/category_model.dart';
import 'package:nazi_shop/models/service_model.dart';
import '../../../components/smart_back_button.dart';
import '../../../components/service_card_modern.dart';
import 'package:nazi_shop/utils/icon_utils.dart';
import 'package:nazi_shop/utils/color_utils.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
// import '../../pages/service_detail/service_detail_widget.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<Service>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  void _loadServices() {
    if (widget.category.services != null &&
        widget.category.services!.isNotEmpty) {
      _servicesFuture = Future.value(widget.category.services!
          .map((json) => Service.fromJson(json))
          .where((s) => s.isActive) // Removed && s.isInStock
          .toList());
    } else {
      _servicesFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isTablet = MediaQuery.of(context).size.width > 600;
    final categoryColor =
        ColorUtils.parseColor(context, widget.category.ui.color);

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: FlutterFlowTheme.of(context).transparent,
              expandedHeight: 180,
              pinned: true,
              stretch: true,
              leadingWidth: 70,
              leading: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1,
                  ),
                ),
                child: SmartBackButton(
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.category.name,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            categoryColor,
                            categoryColor.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            FlutterFlowTheme.of(context).transparent,
                            FlutterFlowTheme.of(context)
                                .primaryBackground
                                .withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -20,
                      top: 40,
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(
                          IconUtils.parseIcon(widget.category.ui.icon),
                          size: 180,
                          color: FlutterFlowTheme.of(context)
                              .primaryText
                              .withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CATÁLOGO EXCLUSIVO',
                      style: GoogleFonts.outfit(
                        color: categoryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ).animate().fadeIn().slideX(begin: -0.2),
                    const SizedBox(height: 8),
                    Text(
                      'Explora los mejores servicios de ${widget.category.name}',
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14,
                      ),
                    ).animate().fadeIn(delay: 100.ms),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 48 : 24,
                vertical: 16,
              ),
              sliver: FutureBuilder<List<Service>>(
                future: _servicesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 80,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText),
                            const SizedBox(height: 16),
                            Text(
                              "SIN STOCK",
                              style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final services = snapshot.data!;
                  final crossAxisCount = isDesktop
                      ? 5
                      : isTablet
                          ? 3
                          : 2;

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final service = services[index];
                        return ServiceCardModern(
                          service: service,
                          primaryColor: ColorUtils.parseColor(
                              context, service.branding.primaryColor),
                        ).animate(delay: (50 * index).ms).fadeIn().scale();
                      },
                      childCount: services.length,
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
