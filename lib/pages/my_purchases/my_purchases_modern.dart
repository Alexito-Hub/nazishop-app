import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nazi_shop/backend/order_service.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/safe_image.dart';
import '../../components/smart_back_button.dart';

class MyPurchasesModernWidget extends StatefulWidget {
  const MyPurchasesModernWidget({super.key});

  @override
  State<MyPurchasesModernWidget> createState() =>
      _MyPurchasesModernWidgetState();
}

class _MyPurchasesModernWidgetState extends State<MyPurchasesModernWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // --- PALETA DE COLORES (COHERENCIA CON HOME) ---
  static const Color kPrimaryColor = Color(0xFFE50914);

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gestiona tus pedidos y visualiza tus credenciales activas',
                        style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.white54
                                : FlutterFlowTheme.of(context).secondaryText),
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
                        return OrderCardGridItem(order: orders[index])
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = FlutterFlowTheme.of(context);
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
          automaticallyImplyLeading: false,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(
              color: isDark ? Colors.white : theme.primaryText,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Mis Compras',
            style: GoogleFonts.outfit(
              color: isDark ? Colors.white : theme.primaryText,
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
                    return OrderCardGridItem(order: orders[index])
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
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color:
                      FlutterFlowTheme.of(context).alternate.withOpacity(0.2))),
        ).animate(onPlay: (c) => c.repeat()).shimmer(
            duration: 2.seconds, color: FlutterFlowTheme.of(context).accent1),
        childCount: 6,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF141414)
                  : FlutterFlowTheme.of(context).secondaryBackground,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(Icons.receipt_long_rounded,
                size: 40,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white24
                    : FlutterFlowTheme.of(context).secondaryText),
          ),
          const SizedBox(height: 24),
          Text(
            'Aún no has realizado compras',
            style: GoogleFonts.outfit(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : FlutterFlowTheme.of(context).primaryText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus pedidos aparecerán aquí',
            style: GoogleFonts.outfit(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white38
                    : FlutterFlowTheme.of(context).secondaryText,
                fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.goNamed('home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
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

// ===========================================================================
// 📦 NEW GRID CARD (Matches ServiceCardModern)
// ===========================================================================
class OrderCardGridItem extends StatefulWidget {
  final Map<String, dynamic> order;
  const OrderCardGridItem({super.key, required this.order});

  @override
  State<OrderCardGridItem> createState() => _OrderCardGridItemState();
}

class _OrderCardGridItemState extends State<OrderCardGridItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final status = widget.order['status']?.toLowerCase() ?? '';
    final serviceName = widget.order['serviceName'] ?? 'Servicio';
    final price = (widget.order['totalAmount'] ?? 0.0).toDouble();
    final rawOrderId = widget.order['_id']?.toString() ?? '';
    final dateStr = widget.order['createdAt'];
    final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
    final formattedDate = date != null ? DateFormat('dd MMM').format(date) : '';

    // Extract logo from order items
    final items = widget.order['items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty ? items[0] : null;
    final offerSnapshot = firstItem?['offerSnapshot'];
    final branding = offerSnapshot?['branding'];
    final logoUrl = branding?['logoUrl'];
    // Try to get primary color from branding
    final String? colorString = branding?['primaryColor'];
    Color primaryColor = FlutterFlowTheme.of(context).primary;
    if (colorString != null) {
      try {
        String hex = colorString.replaceAll('#', '');
        if (hex.length == 6) hex = 'FF$hex';
        primaryColor = Color(int.parse(hex, radix: 16));
      } catch (_) {}
    }

    // Status Conf
    Color statusColor;
    String statusText;
    IconData statusIcon;
    switch (status) {
      case 'paid':
      case 'completed':
        statusColor = const Color(0xFF22C55E);
        statusText = 'COMPLETADO';
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = const Color(0xFFF59E0B);
        statusText = 'PENDIENTE';
        statusIcon = Icons.access_time_filled;
        break;
      default:
        statusColor = const Color(0xFFEF4444);
        statusText = 'CANCELADO';
        statusIcon = Icons.cancel;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = _isHovered
        ? primaryColor.withOpacity(0.5)
        : (isDark
            ? Colors.white.withOpacity(0.08)
            : FlutterFlowTheme.of(context).alternate.withOpacity(0.15));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (status == 'paid' || status == 'completed') {
            context.pushNamed(
              'view_credentials',
              queryParameters: {'orderId': rawOrderId},
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -8.0 : 0.0),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF141414)
                : FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.25),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. HEADER IMAGEN (55%)
                Expanded(
                  flex: 11,
                  child: Stack(
                    children: [
                      // Fondo Imagen
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: isDark
                            ? const Color(0xFF0A0A0A)
                            : FlutterFlowTheme.of(context).secondaryBackground,
                        child: logoUrl != null
                            ? SafeImage(
                                logoUrl,
                                fit: BoxFit.cover,
                                allowRemoteDownload: false,
                                placeholder: _buildPlaceholder(primaryColor),
                              )
                            : _buildPlaceholder(primaryColor),
                      ),

                      // Gradiente Overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Status Badge (Top Left)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                color: Colors.white,
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: GoogleFonts.outfit(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Date Badge (Top Right)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Text(
                            formattedDate,
                            style: GoogleFonts.outfit(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. INFO CONTENT (45%)
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    color: isDark
                        ? const Color(0xFF141414)
                        : FlutterFlowTheme.of(context).secondaryBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serviceName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 15 * FlutterFlowTheme.fontSizeFactor,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Star Rating
                            _buildRatingStars(rawOrderId),
                            const SizedBox(height: 4),
                            Text(
                              'ID: $rawOrderId',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize:
                                      12 * FlutterFlowTheme.fontSizeFactor,
                                  height: 1.3),
                            ),
                          ],
                        ),
                        const Expanded(child: SizedBox()),

                        // Footer: Precio y Botón
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                '\$${price.toStringAsFixed(2)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.w900,
                                  fontSize:
                                      18 * FlutterFlowTheme.fontSizeFactor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (status == 'paid' || status == 'completed')
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _isHovered
                                        ? [
                                            primaryColor,
                                            primaryColor.withOpacity(0.8)
                                          ]
                                        : [
                                            isDark
                                                ? Colors.white10
                                                : FlutterFlowTheme.of(context)
                                                    .alternate,
                                            isDark
                                                ? Colors.white10
                                                : FlutterFlowTheme.of(context)
                                                    .alternate
                                          ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: _isHovered
                                      ? Colors.white
                                      : FlutterFlowTheme.of(context)
                                          .secondaryText,
                                  size: 20,
                                ),
                              ),
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

  Widget _buildRatingStars(String orderId) {
    // Generate mock rating based on order ID hash for consistency
    final hash = orderId.hashCode.abs();
    final rating = 4.5 + ((hash % 5) / 10); // Generates 4.5-4.9

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            if (index < rating.floor()) {
              // Full star
              return const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFC107),
                size: 14,
              );
            } else if (index < rating) {
              // Half star
              return const Icon(
                Icons.star_half_rounded,
                color: Color(0xFFFFC107),
                size: 14,
              );
            } else {
              // Empty star
              return Icon(
                Icons.star_outline_rounded,
                color:
                    FlutterFlowTheme.of(context).secondaryText.withOpacity(0.3),
                size: 14,
              );
            }
          }),
        ),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 12 * FlutterFlowTheme.fontSizeFactor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E1E1E)
              : FlutterFlowTheme.of(context).secondaryBackground,
          image: DecorationImage(
              image: const NetworkImage(
                  "https://www.transparenttextures.com/patterns/cubes.png"),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.dstATop),
              fit: BoxFit.cover)),
      child: Center(
        child: Icon(Icons.shopping_bag_outlined,
            size: 40, color: color.withOpacity(0.3)),
      ),
    );
  }
}
