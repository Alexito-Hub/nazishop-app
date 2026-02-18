import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/safe_image.dart';
import '../../../components/smart_back_button.dart';

// Imports del proyecto
import '/backend/favorites_service.dart';
import '/models/service_model.dart';
import '/components/service_card.dart';

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

  // --- COLORES (Coherentes con HomePage) ---
  Color get _primaryColor => FlutterFlowTheme.of(context).primary;

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

  // --- HELPERS ---
  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return null;
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
    final theme = FlutterFlowTheme.of(context);
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Header Standard Transparente & Centrado
        SliverAppBar(
          backgroundColor: theme.transparent,
          surfaceTintColor: theme.transparent,
          pinned: true,
          floating: true,
          elevation: 0,
          leadingWidth: 70,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(
              color: theme.primaryText,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Mis Favoritos',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
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
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => ServiceCard(
                          service: _favoriteServices[i],
                          primaryColor: _parseColor(
                                  _favoriteServices[i].branding.primaryColor) ??
                              _primaryColor,
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
                              maxCrossAxisExtent: 280,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => ServiceCard(
                                service: _favoriteServices[i],
                                primaryColor: _parseColor(_favoriteServices[i]
                                        .branding
                                        .primaryColor) ??
                                    _primaryColor,
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

// ===========================================================================
// 📦 NEW FAVORITE CARD (Matches OrderCardGridItem)
// ===========================================================================
class FavoriteCardGridItem extends StatefulWidget {
  final Service service;
  const FavoriteCardGridItem({super.key, required this.service});

  @override
  State<FavoriteCardGridItem> createState() => _FavoriteCardGridItemState();
}

class _FavoriteCardGridItemState extends State<FavoriteCardGridItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Theme variables
    final theme = FlutterFlowTheme.of(context);

    // Parsing Data
    final serviceName = widget.service.name;
    final logoUrl = widget.service.branding.logoUrl;
    final price = widget.service.price;
    final inStock = widget.service.isInStock;

    // Status Conf
    final statusColor =
        inStock ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    final statusText = inStock ? 'STOCK' : 'AGOTADO';

    final borderColor =
        _isHovered ? theme.primary.withValues(alpha: 0.5) : theme.alternate;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/service/${widget.service.id}',
            extra: widget.service),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. IMAGE AREA (55%)
                Expanded(
                  flex: 55,
                  child: Stack(
                    children: [
                      // Image or Gradient Placeholder
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color(0xFF0A0A0A),
                        child: logoUrl != null
                            ? SafeImage(
                                logoUrl,
                                fit: BoxFit.cover,
                                allowRemoteDownload: false,
                                placeholder: _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                      // Gradient Overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context).transparent,
                                Colors.black.withValues(alpha: 0.8)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Status Badge (Top Right)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: statusColor, width: 1),
                          ),
                          child: Text(
                            statusText,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. INFO AREA (45%)
                Expanded(
                  flex: 45,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serviceName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : FlutterFlowTheme.of(context).primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.service.categoryName ?? 'Servicio',
                              style: GoogleFonts.outfit(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white38
                                    : FlutterFlowTheme.of(context)
                                        .secondaryText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),

                        // Price & Action
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: GoogleFonts.outfit(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : FlutterFlowTheme.of(context).primaryText,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : FlutterFlowTheme.of(context)
                                          .primaryText,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                    )
                                  ]),
                              child: Icon(Icons.arrow_forward_rounded,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                  size: 18),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          image: DecorationImage(
              image: const NetworkImage(
                  "https://www.transparenttextures.com/patterns/cubes.png"),
              colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.8), BlendMode.dstATop),
              fit: BoxFit.cover)),
      child: Center(
        child: Icon(Icons.shopping_bag_outlined,
            color: Colors.white.withValues(alpha: 0.1), size: 32),
      ),
    );
  }
}
