import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/backend/order_service.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/components/design_system.dart';
import '../../../components/purchase_card.dart';

class MyPurchasesWidget extends StatefulWidget {
  const MyPurchasesWidget({super.key});

  @override
  State<MyPurchasesWidget> createState() => _MyPurchasesWidgetState();
}

class _MyPurchasesWidgetState extends State<MyPurchasesWidget> {
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String? _error;

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await OrderService.getMyOrders();
      if (mounted) {
        setState(() {
          _orders = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: _isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  // ===========================================================================
  // 💻 DESKTOP LAYOUT
  // ===========================================================================
  Widget _buildDesktopLayout() {
    final theme = FlutterFlowTheme.of(context);
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
                        'Historial de Compras',
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gestiona tus pedidos y visualiza tus credenciales activas',
                        style: GoogleFonts.outfit(
                            fontSize: 16, color: theme.secondaryText),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 80),
              sliver: _buildOrdersSliver(isMobile: false),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 📱 MOBILE LAYOUT
  // ===========================================================================
  Widget _buildMobileLayout() {
    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: FlutterFlowTheme.of(context).primary,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const DSMobileAppBar(title: 'Mis Compras'),
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: _buildOrdersSliver(isMobile: true),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ===========================================================================
  // 🔄 ORDERS SLIVER (shared between mobile & desktop)
  // ===========================================================================
  Widget _buildOrdersSliver({required bool isMobile}) {
    if (_isLoading) return _buildShimmerGrid(isMobile: isMobile);

    if (_error != null) return _buildErrorState();

    if (_orders.isEmpty) {
      return isMobile
          ? SliverFillRemaining(child: _buildEmptyState())
          : SliverToBoxAdapter(child: _buildEmptyState());
    }

    final delegate = isMobile
        ? const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          )
        : const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 280,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          );

    return SliverGrid(
      gridDelegate: delegate,
      delegate: SliverChildBuilderDelegate(
        (context, index) => PurchaseCard(order: _orders[index])
            .animate()
            .fadeIn(delay: ((isMobile ? 50 : 30) * index).ms)
            .slideY(begin: 0.1),
        childCount: _orders.length,
      ),
    );
  }

  Widget _buildShimmerGrid({required bool isMobile}) {
    final theme = FlutterFlowTheme.of(context);
    return SliverGrid(
      gridDelegate: isMobile
          ? const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 24,
              mainAxisSpacing: 12)
          : const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 280,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
      delegate: SliverChildBuilderDelegate(
        (_, __) => Container(
          decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(color: theme.alternate.withValues(alpha: 0.2))),
        )
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 2.seconds, color: theme.accent1),
        childCount: 6,
      ),
    );
  }

  Widget _buildErrorState() {
    final theme = FlutterFlowTheme.of(context);
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: theme.error.withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.wifi_off_rounded, size: 40, color: theme.error),
            ),
            const SizedBox(height: 24),
            Text(
              'Error al cargar compras',
              style: GoogleFonts.outfit(
                color: theme.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Verifica tu conexión e intenta de nuevo',
              style:
                  GoogleFonts.outfit(color: theme.secondaryText, fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _loadOrders,
              icon: const Icon(Icons.refresh_rounded),
              label: Text('Reintentar',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: theme.info,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              shape: BoxShape.circle,
              border: Border.all(color: theme.alternate),
            ),
            child: Icon(Icons.receipt_long_rounded,
                size: 40, color: theme.secondaryText),
          ),
          const SizedBox(height: 24),
          Text(
            'Aún no has realizado compras',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus pedidos aparecerán aquí',
            style: GoogleFonts.outfit(color: theme.secondaryText, fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.goNamed('home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primary,
              foregroundColor: theme.tertiary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Explorar Servicios',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
