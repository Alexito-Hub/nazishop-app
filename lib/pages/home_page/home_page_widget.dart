import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_theme.dart';

// Asegúrate de que estas rutas sean correctas en tu proyecto
import '/backend/catalog_service.dart';
import '/models/category_model.dart';
import '/models/service_model.dart';
import '../../components/service_card.dart';
import '../../components/modern_search_bar.dart';
import '../../components/category_selector.dart';
import '../../components/desktop_banner.dart';
import '/components/app_responsive_layout.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  // --- ESTADO ---
  List<Category> _categories = [];
  List<Service> _services = [];
  bool _isLoading = true;
  String? _selectedCategory;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final categories = await CatalogService.getFullCatalog();
      List<Service> allServices = [];
      for (final cat in categories) {
        if (cat.services != null) {
          for (final service in cat.services!) {
            if (service.isActive) allServices.add(service);
          }
        }
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _services = allServices;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Service> get _filteredServices {
    // 1. Filtro por Categoría
    var list = _selectedCategory == null
        ? _services
        : _services.where((s) => s.categoryId == _selectedCategory).toList();

    // 2. Filtro por Búsqueda (opcional, si se desea reactivo local)
    // 2. Filtro por Búsqueda
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      list = list.where((s) => s.name.toLowerCase().contains(query)).toList();
    }

    return list;
  }

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
    return AppResponsiveLayout(
      mobileBody: _buildMobileLayout(),
      desktopBody: _buildDesktopLayout(),
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
        // 1. Header Heroico Móvil Moderno
        SliverAppBar(
          backgroundColor: FlutterFlowTheme.of(context).transparent,
          surfaceTintColor: FlutterFlowTheme.of(context).transparent,
          elevation: 0,
          pinned: true,
          floating: true,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'NAZISHOP',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.w900,
              fontSize: 24 * FlutterFlowTheme.fontSizeFactor,
              letterSpacing: 1.0,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_bag_outlined,
                  color: FlutterFlowTheme.of(context).primaryText),
              onPressed: () => context.pushNamed('my_purchases'),
              tooltip: 'Mis Compras',
            ),
            IconButton(
              icon: Icon(Icons.person_outline,
                  color: FlutterFlowTheme.of(context).primaryText),
              onPressed: () => context.pushNamed('profile'),
              tooltip: 'Perfil',
            ),
            const SizedBox(width: 8),
          ],
        ),

        // 2. Buscador Móvil
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: ModernSearchBar(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),

        // 3. Filtros Móvil
        SliverToBoxAdapter(
          child: CategorySelector(
            categories: _categories,
            selectedId: _selectedCategory,
            onSelect: (id) => setState(() => _selectedCategory = id),
            isLoading: _isLoading,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // 4. Grid Móvil
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: _isLoading
              ? _buildShimmerGrid(isMobile: true)
              : _filteredServices.isEmpty
                  ? SliverToBoxAdapter(child: _buildEmptyState())
                  : SliverGrid(
                      key: ValueKey(
                          "${_selectedCategory ?? 'all'}_${_searchController.text}"),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final service = _filteredServices[i];
                          return ServiceCard(
                            service: service,
                            primaryColor:
                                _parseColor(service.branding.primaryColor) ??
                                    FlutterFlowTheme.of(context).primary,
                          )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: (50 * i).ms)
                              .slideY(begin: 0.1, curve: Curves.easeOutQuad);
                        },
                        childCount: _filteredServices.length,
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
                  // 1. Banner Principal Desktop
                  const DesktopBanner(),

                  const SizedBox(height: 40),

                  // 2. Barra de Herramientas (Filtros + Búsqueda)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Explorar Catálogo",
                              style: GoogleFonts.outfit(
                                  fontSize:
                                      24 * FlutterFlowTheme.fontSizeFactor,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText),
                            ),
                            const SizedBox(height: 16),
                            CategorySelector(
                              categories: _categories,
                              selectedId: _selectedCategory,
                              onSelect: (id) =>
                                  setState(() => _selectedCategory = id),
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Buscador Desktop
                      SizedBox(
                        width: 350,
                        child: ModernSearchBar(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),

            // 3. Grid Desktop
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 80),
              sliver: _isLoading
                  ? _buildShimmerGrid(isMobile: false)
                  : _filteredServices.isEmpty
                      ? SliverToBoxAdapter(child: _buildEmptyState())
                      : SliverGrid(
                          key: ValueKey(
                              "${_selectedCategory ?? 'all'}_${_searchController.text}"),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 280,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final service = _filteredServices[i];
                              return ServiceCard(
                                service: service,
                                primaryColor: _parseColor(
                                        service.branding.primaryColor) ??
                                    FlutterFlowTheme.of(context).primary,
                              )
                                  .animate()
                                  .fadeIn(duration: 300.ms)
                                  .scale(begin: const Offset(0.95, 0.95));
                            },
                            childCount: _filteredServices.length,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS Y UI GENÉRICA ---

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Icon(Icons.search_off_rounded,
                size: 40, color: FlutterFlowTheme.of(context).secondaryText),
          ),
          const SizedBox(height: 16),
          Text(
            'No encontramos servicios aquí',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 16 * FlutterFlowTheme.fontSizeFactor),
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
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75)
          : const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 280,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.75),
      delegate: SliverChildBuilderDelegate(
        (_, __) => Container(
          decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context)
                  .secondaryText
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: FlutterFlowTheme.of(context)
                      .alternate
                      .withValues(alpha: 0.2))),
        ).animate(onPlay: (c) => c.repeat()).shimmer(
            duration: 2.seconds,
            color: FlutterFlowTheme.of(context).accent1.withValues(alpha: 0.3)),
        childCount: 6,
      ),
    );
  }
}
