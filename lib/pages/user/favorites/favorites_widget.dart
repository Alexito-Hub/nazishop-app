import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/components/design_system.dart';

import '/backend/favorites_service.dart';
import '/models/service_model.dart';
import '/components/service_card.dart';
import '/utils/color_utils.dart';

class FavoritesWidget extends StatefulWidget {
  const FavoritesWidget({super.key});

  @override
  State<FavoritesWidget> createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  // --- ESTADO ---
  List<Service> _favoriteServices = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  // --- RESPONSIVE ---
  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final favorites = await FavoritesService.getFavorites();

      if (mounted) {
        setState(() {
          _favoriteServices = favorites;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: RefreshIndicator(
        color: theme.primary,
        backgroundColor: theme.secondaryBackground,
        onRefresh: _loadFavorites,
        child: _isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  // ===========================================================================
  // 📱 MOBILE LAYOUT
  // ===========================================================================
  Widget _buildMobileLayout() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Header Standard Transparente & Centrado
        DSMobileAppBar(
          title: 'Mis Favoritos',
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.filter_list_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText),
            ),
          ],
        ),

        // 2. Contenido (Grid)
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: _isLoading
              ? _buildShimmerGrid(isMobile: true)
              : _favoriteServices.isEmpty
                  ? SliverToBoxAdapter(child: _buildEmptyState())
                  : SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => ServiceCard(
                          service: _favoriteServices[i],
                          primaryColor: ColorUtils.parseColor(context,
                              _favoriteServices[i].branding.primaryColor),
                        )
                            .animate()
                            .fadeIn(delay: (50 * i).ms)
                            .slideY(begin: 0.1),
                        childCount: _favoriteServices.length,
                      ),
                    ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  // ===========================================================================
  // 💻 DESKTOP LAYOUT
  // ===========================================================================
  Widget _buildDesktopLayout() {
    return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mis Favoritos',
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gestiona tus servicios guardados',
                          style: GoogleFonts.outfit(
                              fontSize: 16,
                              color:
                                  FlutterFlowTheme.of(context).secondaryText),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
              // 2. Grid Desktop
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 80),
                sliver: _isLoading
                    ? _buildShimmerGrid(isMobile: false)
                    : _favoriteServices.isEmpty
                        ? SliverToBoxAdapter(child: _buildEmptyState())
                        : SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => ServiceCard(
                                service: _favoriteServices[i],
                                primaryColor: ColorUtils.parseColor(context,
                                    _favoriteServices[i].branding.primaryColor),
                              )
                                  .animate()
                                  .fadeIn(delay: (50 * i).ms)
                                  .scale(begin: const Offset(0.9, 0.9)),
                              childCount: _favoriteServices.length,
                            ),
                          ),
              ),
            ],
          ),
        ));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border_rounded,
              size: 64, color: FlutterFlowTheme.of(context).secondaryText),
          const SizedBox(height: 16),
          Text(
            'No tienes favoritos aún',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            'Explora el catálogo y guarda lo que te guste',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid({required bool isMobile}) {
    return SliverGrid(
      gridDelegate: isMobile
          ? const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            )
          : const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 280,
              childAspectRatio: 0.75,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final theme = FlutterFlowTheme.of(context);
          return Container(
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(20), // More rounded
              border: Border.all(color: theme.alternate),
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(
              duration: 1200.ms,
              color: theme.primaryText.withValues(alpha: 0.1));
        },
        childCount: 6,
      ),
    );
  }
}
