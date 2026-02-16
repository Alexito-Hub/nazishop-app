import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/order_model.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../../components/smart_back_button.dart';
import 'package:nazi_shop/backend/currency_service.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  List<Order> _orders = [];
  bool _isLoading = false;
  String _filter = 'all';

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final res = await AdminService.getOrders();
      if (mounted) {
        setState(() {
          _orders = res.map((e) => Order.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String orderId, String status) async {
    try {
      await AdminService.updateOrderStatus(orderId: orderId, status: status);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Estado actualizado a $status',
                style: const TextStyle(color: Colors.white)),
            backgroundColor: FlutterFlowTheme.of(context).primary,
          ),
        );
      }
      _loadOrders(); // Refresh
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  List<Order> get _filteredOrders {
    if (_filter == 'all') return _orders;
    return _orders
        .where((o) => o.status.toLowerCase() == _filter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    // isDark check removed to rely on theme properties
    return Scaffold(
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
            // 1. Header Dashboard
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gestión de Pedidos',
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Supervisa y administra las órdenes de compra',
                            style: GoogleFonts.outfit(
                                fontSize: 16,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText),
                          ),
                        ],
                      ),
                      const Spacer(),
                      _buildFiltersDesktop(),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: _loadOrders,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Recargar',
                      )
                    ],
                  ),
                ]),
              ),
            ),

            // 2. Grid de Pedidos
            if (_isLoading)
              SliverFillRemaining(
                  child: Center(
                      child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary)))
            else if (_filteredOrders.isEmpty)
              SliverFillRemaining(child: _buildEmptyState())
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 80),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    childAspectRatio: 0.70,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return AdminOrderCard(
                        order: _filteredOrders[index],
                        onUpdateStatus: _updateStatus,
                      )
                          .animate()
                          .fadeIn(delay: (30 * index).ms)
                          .slideY(begin: 0.1);
                    },
                    childCount: _filteredOrders.length,
                  ),
                ),
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
    final theme = FlutterFlowTheme.of(context);
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
              color: theme.primaryText.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(
              color: theme.primaryText,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Pedidos',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: theme.secondaryText),
              onPressed: _loadOrders,
            )
          ],
        ),
        SliverToBoxAdapter(child: _buildFiltersMobile()),
        if (_isLoading)
          SliverFillRemaining(
              child: Center(
                  child: CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary)))
        else if (_filteredOrders.isEmpty)
          SliverFillRemaining(child: _buildEmptyState())
        else
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AdminOrderCard(
                    order: _filteredOrders[index],
                    onUpdateStatus: _updateStatus,
                  ).animate().fadeIn(delay: (50 * index).ms);
                },
                childCount: _filteredOrders.length,
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildFiltersDesktop() {
    return Row(
      children: [
        _chip('Todos', 'all'),
        _chip('Pendientes', 'pending'),
        _chip('Pagados', 'paid'), // likely processing
        _chip('Completados', 'delivered'),
        _chip('Cancelados', 'cancelled'),
      ],
    );
  }

  Widget _buildFiltersMobile() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _chip('Todos', 'all'),
          _chip('Pendientes', 'pending'),
          _chip('Pagados', 'paid'),
          _chip('Completados', 'delivered'),
          _chip('Cancelados', 'cancelled'),
        ],
      ),
    );
  }

  Widget _chip(String label, String val) {
    final sel = _filter == val;
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _filter = val),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: sel ? theme.primary : theme.secondaryBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: sel ? theme.primary : theme.alternate),
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(
                color: sel ? Colors.white : theme.secondaryText,
                fontWeight: sel ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_rounded,
              size: 64, color: FlutterFlowTheme.of(context).secondaryText),
          const SizedBox(height: 16),
          Text(
            'No hay pedidos',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
    final snapshot = item?.offerSnapshot;
    final offerDetails = item?.offerDetails;

    final status = widget.order.status.toLowerCase();

    // Service Name: Try populated offer first (if service populated), then snapshot
    // Note: offerDetails['serviceId'] is the populated Service object
    final serviceObj =
        (offerDetails != null && offerDetails['serviceId'] is Map)
            ? offerDetails['serviceId']
            : null;

    final serviceName =
        serviceObj?['name'] ?? snapshot?['title'] ?? 'Unknown Service';

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
        statusColor = FlutterFlowTheme.of(context).error;
        statusText = 'CANCELADO';
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
