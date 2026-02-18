import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nazi_shop/backend/order_service.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '../../../components/smart_back_button.dart';
import '../../../components/purchase_card.dart';

class MyPurchasesWidget extends StatefulWidget {
  const MyPurchasesWidget({super.key});

  @override
  State<MyPurchasesWidget> createState() => _MyPurchasesWidgetState();
}

class _MyPurchasesWidgetState extends State<MyPurchasesWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // --- PALETA DE COLORES (COHERENCIA CON HOME) ---
  Color get _primaryColor => FlutterFlowTheme.of(context).primary;

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (_isDesktop) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  // ===========================================================================
  // 💻 DESKTOP LAYOUT (ESTILO HOME DASHBOARD)
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
            // 1. Header Dashboard (Sin botón de atrás, alineado a la izquierda)
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

            // 2. Grid de Compras
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 80),
              sliver: FutureBuilder<List<dynamic>>(
                future: OrderService.getMyOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerGrid(isMobile: false);
                  }

                  final orders = snapshot.data ?? [];
                  if (orders.isEmpty) {
                    return SliverToBoxAdapter(child: _buildEmptyState());
                  }

                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 280,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return PurchaseCard(order: orders[index])
                            .animate()
                            .fadeIn(delay: (30 * index).ms)
                            .slideY(begin: 0.1);
                      },
                      childCount: orders.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 📱 MOBILE LAYOUT (ESTILO HOME/SERVICE DETAIL)
  // ===========================================================================
  Widget _buildMobileLayout() {
    final theme = FlutterFlowTheme.of(context);
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
          automaticallyImplyLeading: false,
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
            'Mis Compras',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: FutureBuilder<List<dynamic>>(
            future: OrderService.getMyOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerGrid(isMobile: true);
              }

              final orders = snapshot.data ?? [];
              if (orders.isEmpty) {
                return SliverFillRemaining(child: _buildEmptyState());
              }

              return SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return PurchaseCard(order: orders[index])
                        .animate()
                        .fadeIn(delay: (50 * index).ms);
                  },
                  childCount: orders.length,
                ),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
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
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
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
