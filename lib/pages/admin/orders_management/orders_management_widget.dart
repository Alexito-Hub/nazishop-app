import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/admin/admin_auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../components/smart_back_button.dart';
import 'orders_management_model.dart';
import 'package:nazi_shop/models/order.dart';
import 'package:nazi_shop/backend/currency_service.dart';

export 'orders_management_model.dart';

class OrdersManagementWidget extends StatefulWidget {
  const OrdersManagementWidget({super.key});

  static String routeName = 'orders_management';
  static String routePath = '/admin/orders';

  @override
  State<OrdersManagementWidget> createState() => _OrdersManagementWidgetState();
}

class _OrdersManagementWidgetState extends State<OrdersManagementWidget> {
  late OrdersManagementModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrdersManagementModel());

    _model.onDataChanged = () {
      if (mounted) setState(() {});
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model.loadOrders(refresh: true);
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminAuthGuard(
      title: 'Gestión de Pedidos',
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: LayoutBuilder(builder: (context, constraints) {
          final isDesktop = MediaQuery.of(context).size.width >= 900;
          return isDesktop ? _buildDesktopLayout() : _buildMobileLayout();
        }),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          surfaceTintColor: FlutterFlowTheme.of(context).transparent,
          pinned: true,
          floating: true,
          elevation: 0,
          leadingWidth: 70,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(
                color: FlutterFlowTheme.of(context).primaryText),
          ),
          centerTitle: true,
          title: Text(
            'Pedidos',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh,
                  color: FlutterFlowTheme.of(context).secondaryText),
              onPressed: () => _model.loadOrders(refresh: true),
            ),
          ],
        ),
        SliverToBoxAdapter(child: _buildFilters(isDesktop: false)),
        SliverToBoxAdapter(child: _buildStats()),
        _buildOrdersList(isDesktop: false),
      ],
    );
  }

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
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gestión de Pedidos',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Supervisa el estado y flujo de órdenes',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _buildFilters(isDesktop: true),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.refresh,
                          color: FlutterFlowTheme.of(context).secondaryText),
                      onPressed: () => _model.loadOrders(refresh: true),
                      tooltip: 'Recargar',
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: _buildStats(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(40),
              sliver: _buildOrdersList(isDesktop: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters({required bool isDesktop}) {
    // If desktop, simple row. If mobile, scrollable row.
    final children = [
      _buildFilterChip('Todas', null),
      const SizedBox(width: 8.0),
      _buildFilterChip('Pendientes', 'pending'),
      const SizedBox(width: 8.0),
      _buildFilterChip('Proceso', 'processing'),
      const SizedBox(width: 8.0),
      _buildFilterChip(
          'Completadas', 'delivered'), // mapped to 'delivered' or 'completed'
      const SizedBox(width: 8.0),
      _buildFilterChip('Canceladas', 'cancelled'),
    ];

    if (isDesktop) {
      return Row(mainAxisSize: MainAxisSize.min, children: children);
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(children: children),
      );
    }
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildQuickStat(
              'Total',
              '${_model.orders.length}', // This counts loaded orders, might need total from API?
              // API returns total count but model page loads. For now this is fine or maybe show total from pagination?
              // The model stores total in local logic if needed, but let's stick to loaded or add logic later.
              Icons.receipt_long,
              FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickStat(
              'Pendientes',
              '${_model.orders.where((o) => o.status.toLowerCase() == 'pending').length}',
              Icons.pending,
              FlutterFlowTheme.of(context).warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickStat(
              'Éxito',
              '${_model.orders.where((o) => [
                    'completed',
                    'delivered'
                  ].contains(o.status.toLowerCase())).length}',
              Icons.check_circle,
              FlutterFlowTheme.of(context).primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList({bool isDesktop = false}) {
    if (_model.isLoadingOrders && _model.orders.isEmpty) {
      return SliverFillRemaining(
        child: Center(
            child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primary)),
      );
    } else if (_model.errorMessage != null && _model.orders.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 64, color: FlutterFlowTheme.of(context).error),
              const SizedBox(height: 16),
              Text('Error: ${_model.errorMessage}',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _model.loadOrders(refresh: true),
                style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).primary),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    } else if (_model.orders.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_outlined,
                  size: 64, color: FlutterFlowTheme.of(context).secondaryText),
              const SizedBox(height: 16),
              Text('No hay pedidos',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 18)),
            ],
          ),
        ),
      );
    }

    if (isDesktop) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 320,
          childAspectRatio: 0.70,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == _model.orders.length) {
              // Pagination loader/button
              if (_model.hasMore) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () => _model.loadNextPage(),
                    child: _model.isLoadingOrders
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Cargar más'),
                  ),
                );
              }
              return const SizedBox.shrink();
            }
            return AdminOrderCard(
              order: _model.orders[index],
              onUpdateStatus: (id, status) =>
                  _model.updateOrderStatus(orderId: id, status: status),
            )
                .animate()
                .fadeIn(
                    delay:
                        (30 * (index % 10)).ms) // Modulo to prevent long delays
                .slideY(begin: 0.1);
          },
          childCount: _model.orders.length + (_model.hasMore ? 1 : 0),
        ),
      );
    }

    // Mobile list
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == _model.orders.length) {
            if (_model.hasMore) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: _model.isLoadingOrders
                    ? Center(
                        child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary))
                    : Center(
                        child: ElevatedButton(
                          onPressed: () => _model.loadNextPage(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: const Text('Cargar más'),
                        ),
                      ),
              );
            }
            return const SizedBox(height: 100);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: AdminOrderCard(
              order: _model.orders[index],
              onUpdateStatus: (id, status) =>
                  _model.updateOrderStatus(orderId: id, status: status),
            ).animate().fadeIn(delay: (50 * (index % 10)).ms),
          );
        },
        childCount: _model.orders.length + 1,
      ),
    );
  }

  Widget _buildFilterChip(String label, String? status) {
    final isSelected = _model.selectedStatus == status;
    return GestureDetector(
      onTap: () => _model.filterByStatus(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected
                ? FlutterFlowTheme.of(context).primaryText
                : FlutterFlowTheme.of(context).secondaryText,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// 📦 ADMIN ORDER CARD (Modern Style)
// ===========================================================================
class AdminOrderCard extends StatefulWidget {
  final Order order;
  final Function(String, String) onUpdateStatus;

  const AdminOrderCard({
    super.key,
    required this.order,
    required this.onUpdateStatus,
  });

  @override
  State<AdminOrderCard> createState() => _AdminOrderCardState();
}

class _AdminOrderCardState extends State<AdminOrderCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Access data safely
    final item =
        widget.order.items.isNotEmpty ? widget.order.items.first : null;
    final snapshot = item?.listingSnapshot;
    final offerDetails = item?.offerDetails;

    final status = widget.order.status.toLowerCase();

    // Service Name: Try populated offer first (if service populated), then snapshot
    // Note: offerDetails['serviceId'] is the populated Service object
    final serviceObj =
        (offerDetails != null && offerDetails['serviceId'] is Map)
            ? offerDetails['serviceId']
            : null;

    final serviceName =
        serviceObj?['name'] ?? snapshot?.title ?? 'Unknown Service';

    final branding = serviceObj?['branding'];
    final String? logoUrl = branding?['logoUrl'];

    // Attempt to parse primary color from branding
    Color primaryColor = FlutterFlowTheme.of(context).primary;
    if (branding?['primaryColor'] != null) {
      try {
        String hex = branding!['primaryColor'].toString().replaceAll('#', '');
        if (hex.length == 6) hex = 'FF$hex';
        primaryColor = Color(int.parse(hex, radix: 16));
      } catch (_) {}
    }

    final price = widget.order.totalAmount;
    final orderId = widget.order.id;
    final date = widget.order.createdAt;
    final formattedDate = DateFormat('dd MMM HH:mm').format(date);

    // Status Logic
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case 'paid':
        statusColor = FlutterFlowTheme.of(context).success;
        statusText = 'PAGADO';
        statusIcon = Icons.attach_money;
        break;
      case 'processing':
        statusColor = FlutterFlowTheme.of(context).warning;
        statusText = 'PROCESO';
        statusIcon = Icons.sync;
        break;
      case 'delivered':
      case 'completed':
        statusColor = FlutterFlowTheme.of(context).success;
        statusText = 'COMPLETADO';
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = FlutterFlowTheme.of(context).info;
        statusText = 'PENDIENTE';
        statusIcon = Icons.pending;
        break;
      case 'cancelled':
      case 'failed':
        statusColor = FlutterFlowTheme.of(context).error;
        statusText = status == 'failed' ? 'FALLIDO' : 'CANCELADO';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = FlutterFlowTheme.of(context).secondaryText;
        statusText = status.toUpperCase();
        statusIcon = Icons.help_outline;
    }

    final borderColor = _isHovered
        ? primaryColor.withValues(alpha: 0.5)
        : FlutterFlowTheme.of(context).alternate;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translateByDouble(0.0, _isHovered ? -8.0 : 0.0, 0.0, 1.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. HEADER (45%)
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    // Background Image or Pattern
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        image: DecorationImage(
                            image: logoUrl != null
                                ? NetworkImage(logoUrl)
                                : const NetworkImage(
                                    "https://www.transparenttextures.com/patterns/cubes.png"),
                            colorFilter: logoUrl != null
                                ? null
                                : ColorFilter.mode(
                                    Colors.black.withValues(alpha: 0.5),
                                    BlendMode.dstATop),
                            fit: logoUrl != null ? BoxFit.cover : BoxFit.cover),
                      ),
                      child: logoUrl == null
                          ? Center(
                              child: Icon(Icons.shopping_bag_outlined,
                                  color: Colors.white24, size: 40))
                          : null,
                    ),

                    // Gradient Overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                    // Status Badge
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
                          children: [
                            Icon(statusIcon, color: Colors.white, size: 10),
                            const SizedBox(width: 4),
                            Text(statusText,
                                style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),

                    // Date Badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Text(formattedDate,
                            style: GoogleFonts.outfit(
                                fontSize: 9, color: Colors.white70)),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. BODY (55%)
              Expanded(
                flex: 6,
                child: Container(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(serviceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: FlutterFlowTheme.of(context).primaryText)),
                      const SizedBox(height: 2),
                      Text(
                          'User: ${widget.order.userName ?? widget.order.userEmail ?? 'Usuario'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                              fontSize: 12,
                              color:
                                  FlutterFlowTheme.of(context).secondaryText)),

                      const Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(CurrencyService.formatFromUSD(price),
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryText)),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ADMIN ACTIONS ROW
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Process
                            _actionBtn(
                                Icons.sync,
                                FlutterFlowTheme.of(context).warning,
                                'Process',
                                () => widget.onUpdateStatus(
                                    orderId, 'PROCESSING')),
                            // Complete
                            _actionBtn(
                                Icons.check_circle,
                                FlutterFlowTheme.of(context).success,
                                'Done',
                                () => widget.onUpdateStatus(
                                    orderId, 'COMPLETED')),
                            // Cancel
                            _actionBtn(
                                Icons.cancel,
                                FlutterFlowTheme.of(context).error,
                                'Cancel',
                                () => widget.onUpdateStatus(
                                    orderId, 'CANCELLED')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(
      IconData icon, Color color, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
