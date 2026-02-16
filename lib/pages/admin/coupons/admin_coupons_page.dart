import 'package:nazi_shop/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:go_router/go_router.dart';
import 'package:nazi_shop/models/coupon_model.dart';
import 'package:intl/intl.dart';

class AdminCouponsPage extends StatefulWidget {
  const AdminCouponsPage({super.key});

  @override
  State<AdminCouponsPage> createState() => _AdminCouponsPageState();
}

class _AdminCouponsPageState extends State<AdminCouponsPage> {
  bool _isLoading = false;
  List<Coupon> _coupons = [];
  String _filterStatus = 'all'; // all, active, inactive

  @override
  void initState() {
    super.initState();
    _loadCoupons();
  }

  Future<void> _loadCoupons() async {
    setState(() => _isLoading = true);
    try {
      final data = await AdminService.getCoupons();
      if (mounted) {
        setState(() {
          _coupons = data.map((d) => Coupon.fromJson(d)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Silently ignore or show error
      }
    }
  }

  List<Coupon> get _filteredCoupons {
    final now = DateTime.now();
    return _coupons.where((c) {
      bool matchesFilter = true;
      if (_filterStatus == 'active') {
        matchesFilter =
            c.isActive && (c.validUntil == null || c.validUntil!.isAfter(now));
      } else if (_filterStatus == 'inactive') {
        matchesFilter = !c.isActive ||
            (c.validUntil != null && c.validUntil!.isBefore(now));
      }
      return matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final theme = FlutterFlowTheme.of(context);

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
                  colors: [theme.primary, theme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: _showCreatePage,
                backgroundColor: theme.transparent,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                icon: Icon(Icons.confirmation_number_outlined,
                    color: theme.tertiary),
                label: Text(
                  'Nuevo Cupón',
                  style: GoogleFonts.outfit(
                      color: theme.tertiary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
            ),
    );
  }

  Future<void> _showCreatePage() async {
    // Navigate to create page
    final result = await context.pushNamed('create_coupon');
    if (result == true) {
      _loadCoupons();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cupón creado exitosamente'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );
      }
    }
  }

  Future<void> _editCoupon(Coupon item) async {
    final result =
        await context.pushNamed('create_coupon', extra: item.toJson());
    if (result == true) {
      _loadCoupons();
    }
  }

  // --- MOBILE LAYOUT ---
  Widget _buildMobileLayout(
      FlutterFlowTheme theme, Color cardColor, Color borderColor) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
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
              color: theme.primaryBackground.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(color: theme.primaryText),
          ),
          centerTitle: true,
          title: Text(
            'Cupones',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Todos', 'all', theme),
                const SizedBox(width: 8),
                _buildFilterChip('Activos', 'active', theme),
                const SizedBox(width: 8),
                _buildFilterChip('Inactivos', 'inactive', theme),
              ],
            ),
          ),
        ),
        if (_isLoading)
          SliverFillRemaining(
              child: Center(
                  child: CircularProgressIndicator(color: theme.primary)))
        else if (_filteredCoupons.isEmpty)
          SliverFillRemaining(child: _buildEmptyState(theme))
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _filteredCoupons[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CouponRowItem(
                      item: item,
                      onTap: () => _editCoupon(item),
                      theme: theme,
                      cardColor: cardColor,
                      borderColor: borderColor,
                    )
                        .animate()
                        .fadeIn(delay: (30 * index).ms)
                        .slideX(begin: 0.1),
                  );
                },
                childCount: _filteredCoupons.length,
              ),
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
                          'Cupones de Descuento',
                          style: GoogleFonts.outfit(
                            color: theme.primaryText,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gestiona códigos promocionales y descuentos',
                          style: GoogleFonts.outfit(
                              color: theme.secondaryText, fontSize: 16),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Filters
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFilterChip('Todos', 'all', theme),
                        const SizedBox(width: 12),
                        _buildFilterChip('Activos', 'active', theme),
                        const SizedBox(width: 12),
                        _buildFilterChip('Inactivos', 'inactive', theme),
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
                              backgroundColor: theme.transparent,
                              shadowColor: theme.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                            ),
                            icon: Icon(Icons.add_circle_outline,
                                color: theme.tertiary, size: 20),
                            label: Text(
                              'Nuevo Cupón',
                              style: GoogleFonts.outfit(
                                color: theme.tertiary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
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
                      child: CircularProgressIndicator(color: theme.primary)))
            else if (_filteredCoupons.isEmpty)
              SliverFillRemaining(child: _buildEmptyState(theme))
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 180,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = _filteredCoupons[index];
                      return CouponCardItem(
                        item: item,
                        onTap: () => _editCoupon(item),
                        theme: theme,
                        cardColor: cardColor,
                        borderColor: borderColor,
                      )
                          .animate()
                          .fadeIn(delay: (20 * index).ms)
                          .scale(begin: const Offset(0.9, 0.9));
                    },
                    childCount: _filteredCoupons.length,
                  ),
                ),
              ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 50)),
          ],
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            color: isSelected ? theme.tertiary : theme.secondaryText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(FlutterFlowTheme theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.confirmation_number_outlined,
              size: 64, color: theme.secondaryText),
          const SizedBox(height: 16),
          Text(
            'No hay cupones',
            style: GoogleFonts.outfit(color: theme.secondaryText, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS ---

class CouponRowItem extends StatelessWidget {
  final Coupon item;
  final VoidCallback? onTap;
  final FlutterFlowTheme theme;
  final Color cardColor;
  final Color borderColor;

  const CouponRowItem({
    super.key,
    required this.item,
    this.onTap,
    required this.theme,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isExpired =
        item.validUntil != null && item.validUntil!.isBefore(DateTime.now());
    final statusColor =
        (item.isActive && !isExpired) ? theme.success : theme.secondaryText;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: theme.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.local_offer, color: theme.primary),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.code,
                            style: GoogleFonts.robotoMono(
                              color: theme.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.isActive
                                  ? (isExpired ? 'EXPIRADO' : 'ACTIVO')
                                  : 'INACTIVO',
                              style: GoogleFonts.outfit(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.discountType == "percentage" ? "${item.value}% OFF" : "\$${item.value} OFF"} • Usos: ${item.usedCount}/${item.usageLimit}',
                        style: GoogleFonts.outfit(
                            color: theme.secondaryText, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                // Expiry
                if (item.validUntil != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Vence',
                          style: GoogleFonts.outfit(
                              color: theme.secondaryText, fontSize: 10)),
                      Text(
                        DateFormat('dd/MM').format(item.validUntil!),
                        style: GoogleFonts.outfit(
                            color: theme.primaryText, fontSize: 13),
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

class CouponCardItem extends StatelessWidget {
  final Coupon item;
  final VoidCallback? onTap;
  final FlutterFlowTheme theme;
  final Color cardColor;
  final Color borderColor;

  const CouponCardItem({
    super.key,
    required this.item,
    this.onTap,
    required this.theme,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isExpired =
        item.validUntil != null && item.validUntil!.isBefore(DateTime.now());
    final statusColor =
        (item.isActive && !isExpired) ? theme.success : theme.secondaryText;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
              color: theme.primaryText.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: theme.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.discountType == 'percentage'
                                ? '${item.value}%'
                                : '\$${item.value}',
                            style: GoogleFonts.outfit(
                                color: theme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        Icon(Icons.more_horiz, color: theme.secondaryText),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      item.code,
                      style: GoogleFonts.robotoMono(
                        color: theme.primaryText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.people_outline,
                            size: 14, color: theme.secondaryText),
                        const SizedBox(width: 4),
                        Text('${item.usedCount}/${item.usageLimit} canjeos',
                            style: GoogleFonts.outfit(
                                color: theme.secondaryText, fontSize: 12)),
                        const Spacer(),
                        if (item.validUntil != null)
                          Text(
                            'Vence: ${DateFormat('dd MMM').format(item.validUntil!)}',
                            style: GoogleFonts.outfit(
                                color: isExpired
                                    ? theme.error
                                    : theme.secondaryText,
                                fontSize: 12),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: statusColor.withValues(alpha: 0.4),
                          blurRadius: 6),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
