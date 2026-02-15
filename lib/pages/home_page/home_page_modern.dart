import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_theme.dart';

// Asegúrate de que estas rutas sean correctas en tu proyecto
import '/backend/catalog_service.dart';
import '/models/category_model.dart';
import '/models/service_model.dart';
import '../../components/service_card_modern.dart';

class HomePageModernWidget extends StatefulWidget {
  const HomePageModernWidget({super.key});

  @override
  State<HomePageModernWidget> createState() => _HomePageModernWidgetState();
}

class _HomePageModernWidgetState extends State<HomePageModernWidget> {
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
          for (final svc in cat.services!) {
            if (svc is Map<String, dynamic>) {
              final service = Service.fromJson(svc);
              if (service.isActive) allServices.add(service);
            }
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

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

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
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Stack(
        children: [
          // 1. Fondo Base (Sólido o Gradiente sutil del tema)
          Positioned.fill(
            child: Container(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
          ),

          RefreshIndicator(
            color: FlutterFlowTheme.of(context).primary,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            onRefresh: _loadData,
            child: _isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
          ),
        ],
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
        // 1. Header Heroico Móvil Moderno
        SliverAppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
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
            child: _ModernSearchBar(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),

        // 3. Filtros Móvil
        SliverToBoxAdapter(
          child: _CategorySelector(
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
                          return ServiceCardModern(
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
                  _buildDesktopBanner(),

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
                            _CategorySelector(
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
                        child: _ModernSearchBar(
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
                              return ServiceCardModern(
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

  // --- COMPONENTE BANNER DESKTOP ---
  Widget _buildDesktopBanner() {
    final primaryColor = FlutterFlowTheme.of(context).primary;

    return Container(
      constraints: const BoxConstraints(minHeight: 280),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).secondaryBackground,
            FlutterFlowTheme.of(context).primaryBackground
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate.withOpacity(0.2),
        ),
      ),
      child: Stack(
        children: [
          // Elementos decorativos de fondo
          Positioned(
            right: -50,
            bottom: -50,
            child: Icon(
              Icons.stars_rounded,
              size: 400,
              color: primaryColor.withOpacity(0.03),
            ),
          ),
          Positioned(
            top: 20,
            left: 200,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.05),
              ),
            ),
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, const Color(0xFF800000)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: primaryColor.withOpacity(0.4),
                                  blurRadius: 10)
                            ]),
                        child: Text(
                          'PREMIUM ACCESS',
                          style: GoogleFonts.outfit(
                            color: Colors.white, // White on gradient background
                            fontSize: 10 * FlutterFlowTheme.fontSizeFactor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Descubre servicios\nde alto nivel.',
                        style: GoogleFonts.outfit(
                          fontSize: 42 * FlutterFlowTheme.fontSizeFactor,
                          fontWeight: FontWeight.w800,
                          color: FlutterFlowTheme.of(context).primaryText,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Calidad garantizada y entrega inmediata en todos nuestros productos digitales.',
                        style: GoogleFonts.outfit(
                          fontSize: 16 * FlutterFlowTheme.fontSizeFactor,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                // Imagen ilustrativa
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  child: Icon(Icons.rocket_launch_rounded,
                      size: 120,
                      color: FlutterFlowTheme.of(context)
                          .primaryText
                          .withOpacity(0.8)),
                )
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
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
              color:
                  FlutterFlowTheme.of(context).secondaryText.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color:
                      FlutterFlowTheme.of(context).alternate.withOpacity(0.2))),
        ).animate(onPlay: (c) => c.repeat()).shimmer(
            duration: 2.seconds,
            color: FlutterFlowTheme.of(context).accent1.withOpacity(0.3)),
        childCount: 6,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🔍 BARRA DE BÚSQUEDA MODERNA
// -----------------------------------------------------------------------------
class _ModernSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const _ModernSearchBar({
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: FlutterFlowTheme.of(context).alternate.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 14 * FlutterFlowTheme.fontSizeFactor),
        decoration: InputDecoration(
          hintText: 'Buscar servicios...',
          hintStyle: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14 * FlutterFlowTheme.fontSizeFactor),
          prefixIcon: Icon(Icons.search,
              color: FlutterFlowTheme.of(context).secondaryText),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🏷️ SELECTOR DE CATEGORÍAS (Pill Style)
// -----------------------------------------------------------------------------
class _CategorySelector extends StatelessWidget {
  final List<Category> categories;
  final String? selectedId;
  final Function(String?) onSelect;
  final bool isLoading;

  const _CategorySelector({
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
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ))
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                  color: FlutterFlowTheme.of(context).accent1.withOpacity(0.3)),
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
                    ? LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.8)])
                    : null,
                color: isSelected
                    ? null
                    : FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : FlutterFlowTheme.of(context)
                            .alternate
                            .withOpacity(0.2),
                    width: 1.5),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: primaryColor.withOpacity(0.4),
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
