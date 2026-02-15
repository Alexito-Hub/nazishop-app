import 'package:nazi_shop/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../components/smart_back_button.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:go_router/go_router.dart';
import 'package:nazi_shop/models/promotion_model.dart';
import 'package:intl/intl.dart';

class AdminPromotionsPage extends StatefulWidget {
  const AdminPromotionsPage({super.key});

  @override
  State<AdminPromotionsPage> createState() => _AdminPromotionsPageState();
}

class _AdminPromotionsPageState extends State<AdminPromotionsPage> {
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
          _promotions = data.map((d) => Promotion.fromJson(d)).toList();
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
    final cardColor = theme.secondaryBackground;
    final borderColor = theme.alternate;

    return Scaffold(
      backgroundColor: bgColor,
      body: isDesktop
          ? _buildDesktopLayout(theme, cardColor, borderColor)
          : _buildMobileLayout(theme, cardColor, borderColor),
      floatingActionButton: isDesktop
          ? null
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primary,
                    theme.secondary
                  ], // Using theme colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: _showCreatePage,
                backgroundColor: Colors.transparent,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                icon: const Icon(Icons.campaign, color: Colors.white),
                label: Text(
                  'Nueva Promo',
                  style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
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
  Widget _buildMobileLayout(
      FlutterFlowTheme theme, Color cardColor, Color borderColor) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          pinned: true,
          floating: true,
          elevation: 0,
          leadingWidth: 70,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryBackground.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(color: theme.primaryText),
          ),
          centerTitle: true,
          title: Text(
            'Promociones',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
          actions: [], // Removed refresh button as per design
        ),
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
              child: CircularProgressIndicator(color: theme.primary),
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
                  child: PromotionRowItem(
                    item: item,
                    onTap: () => _editPromotion(item),
                    theme: theme,
                    cardColor: cardColor,
                    borderColor: borderColor,
                  ).animate().fadeIn(delay: (30 * index).ms).slideX(begin: 0.1),
                );
              }, childCount: _filteredPromotions.length),
            ),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }

  // --- DESKTOP LAYOUT ---
  Widget _buildDesktopLayout(
      FlutterFlowTheme theme, Color cardColor, Color borderColor) {
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
                                color: theme.primary.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _showCreatePage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text(
                              'Nueva Promo',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
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
                  child: CircularProgressIndicator(color: theme.primary),
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
                    return PromotionRowItem(
                      item: _filteredPromotions[index],
                      onTap: () => _editPromotion(_filteredPromotions[index]),
                      theme: theme,
                      cardColor: cardColor,
                      borderColor: borderColor,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              shape: BoxShape.circle,
              border: Border.all(color: theme.alternate),
            ),
            child: Icon(
              Icons.campaign_outlined,
              size: 40,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay promociones activas',
            style: GoogleFonts.outfit(color: theme.secondaryText),
          ),
        ],
      ),
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
            color: isSelected ? Colors.white : theme.secondaryText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class PromotionRowItem extends StatelessWidget {
  final Promotion item;
  final VoidCallback? onTap;
  final FlutterFlowTheme theme;
  final Color cardColor;
  final Color borderColor;

  const PromotionRowItem({
    super.key,
    required this.item,
    this.onTap,
    required this.theme,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isExpired =
        item.validUntil != null && item.validUntil!.isBefore(DateTime.now());
    final bool isActive = item.isActive && !isExpired;
    final color = isActive ? Colors.greenAccent : Colors.redAccent;
    final statusText =
        isActive ? 'Activa' : (isExpired ? 'Expirada' : 'Inactiva');

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withOpacity(0.2)),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.outfit(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (item.isFeatured)
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.description ?? 'Sin descripción',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: theme.secondaryText,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                const Divider(color: Colors.white10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.finalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.validUntil != null)
                      Text(
                        'Hasta: ${DateFormat('dd MMM').format(item.validUntil!)}',
                        style: GoogleFonts.outfit(
                          color: theme.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
