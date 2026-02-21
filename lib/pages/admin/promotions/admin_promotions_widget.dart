import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/admin_service.dart';
import 'package:go_router/go_router.dart';
import '/models/promotion_model.dart';
import '/components/design_system.dart';
import '/components/loading_indicator.dart';
import '/components/app_empty_state.dart';
import 'components/promotion_card.dart';

class AdminPromotionsWidget extends StatefulWidget {
  const AdminPromotionsWidget({super.key});

  @override
  State<AdminPromotionsWidget> createState() => _AdminPromotionsWidgetState();
}

class _AdminPromotionsWidgetState extends State<AdminPromotionsWidget> {
  // Styles
  // Removed hardcoded colors in favor of theme

  bool _isLoading = false;
  List<Promotion> _promotions = [];
  String _filterStatus = 'all'; // all, active, inactive

  @override
  void initState() {
    super.initState();
    _loadPromotions();
  }

  Future<void> _loadPromotions() async {
    setState(() => _isLoading = true);
    try {
      final data = await AdminService.getPromotions();
      if (mounted) {
        setState(() {
          _promotions = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar: $e'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  List<Promotion> get _filteredPromotions {
    final now = DateTime.now();
    return _promotions.where((p) {
      bool matchesFilter = true;
      if (_filterStatus == 'active') {
        matchesFilter =
            p.isActive && (p.validUntil == null || p.validUntil!.isAfter(now));
      } else if (_filterStatus == 'inactive') {
        matchesFilter = !p.isActive ||
            (p.validUntil != null && p.validUntil!.isBefore(now));
      }
      return matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    // Adaptive Colors
    final bgColor = theme.primaryBackground;

    return Scaffold(
      backgroundColor: bgColor,
      body: isDesktop ? _buildDesktopLayout(theme) : _buildMobileLayout(theme),
      floatingActionButton: isDesktop
          ? null
          : DSGradientFab(
              label: 'Nueva Promo',
              icon: Icons.campaign,
              onPressed: _showCreatePage,
            ),
    );
  }

  Future<void> _showCreatePage() async {
    await context.pushNamed('create_promotion');
    _loadPromotions();
  }

  Future<void> _editPromotion(Promotion item) async {
    await context.pushNamed('create_promotion', extra: item.toJson());
    _loadPromotions();
  }

  // --- MOBILE LAYOUT ---
  Widget _buildMobileLayout(FlutterFlowTheme theme) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const DSMobileAppBar(title: 'Promociones'),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Todas', 'all', theme),
                const SizedBox(width: 8),
                _buildFilterChip('Activas', 'active', theme),
                const SizedBox(width: 8),
                _buildFilterChip('Inactivas', 'inactive', theme),
              ],
            ),
          ),
        ),
        if (_isLoading)
          SliverFillRemaining(
            child: Center(
              child: LoadingIndicator(color: theme.primary),
            ),
          )
        else if (_filteredPromotions.isEmpty)
          SliverFillRemaining(child: _buildEmptyState(theme))
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = _filteredPromotions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PromotionCard(
                    item: item,
                    onTap: () => _editPromotion(item),
                  ),
                );
              }, childCount: _filteredPromotions.length),
            ),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }

  // --- DESKTOP LAYOUT ---
  Widget _buildDesktopLayout(FlutterFlowTheme theme) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Promociones y Ofertas',
                          style: GoogleFonts.outfit(
                            color: theme.primaryText,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gestiona descuentos y campañas especiales',
                          style: GoogleFonts.outfit(
                            color: theme.secondaryText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Filters
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFilterChip('Todas', 'all', theme),
                        const SizedBox(width: 12),
                        _buildFilterChip('Activas', 'active', theme),
                        const SizedBox(width: 12),
                        _buildFilterChip('Inactivas', 'inactive', theme),
                        const SizedBox(width: 24),
                        // Action Button
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [theme.primary, theme.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _showCreatePage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  FlutterFlowTheme.of(context).transparent,
                              shadowColor:
                                  FlutterFlowTheme.of(context).transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: FlutterFlowTheme.of(context).tertiary,
                              size: 20,
                            ),
                            label: Text(
                              'Nueva Promo',
                              style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              SliverFillRemaining(
                child: Center(
                  child: LoadingIndicator(color: theme.primary),
                ),
              )
            else if (_filteredPromotions.isEmpty)
              SliverFillRemaining(child: _buildEmptyState(theme))
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 80),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 180, // Allow card height
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return PromotionCard(
                      item: _filteredPromotions[index],
                      onTap: () => _editPromotion(_filteredPromotions[index]),
                    );
                  }, childCount: _filteredPromotions.length),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(FlutterFlowTheme theme) {
    return const AppEmptyState(
      icon: Icons.campaign_outlined,
      message: 'No hay promociones activas',
    );
  }

  Widget _buildFilterChip(String label, String value, FlutterFlowTheme theme) {
    final isSelected = _filterStatus == value;
    return InkWell(
      onTap: () => setState(() => _filterStatus = value),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : theme.secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.primary : theme.alternate,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? theme.primaryText : theme.secondaryText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
