import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:nazi_shop/backend/api_client.dart';
import 'package:nazi_shop/backend/currency_service.dart';
import 'package:nazi_shop/models/order.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/auth/nazishop_auth/auth_util.dart';
import '../../../components/smart_back_button.dart';

class OrdersHistoryWidget extends StatefulWidget {
  const OrdersHistoryWidget({super.key});

  static String routeName = 'orders_history';
  static String routePath = '/orders-history';

  @override
  State<OrdersHistoryWidget> createState() => _OrdersHistoryWidgetState();
}

class _OrdersHistoryWidgetState extends State<OrdersHistoryWidget> {
  List<Order> _orders = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    if (!loggedIn) {
      setState(() {
        _error = 'Debes iniciar sesión para ver tus compras';
        _loading = false;
      });
      return;
    }

    try {
      setState(() => _loading = true);

      final response = await ApiClient.post('/api/orders', body: {
        'action': 'list',
        'userId': currentUserUid,
      });

      if (response['status'] == true) {
        final ordersData = response['data'] as List;
        final orders = ordersData.map((o) => Order.fromJson(o)).toList();

        // Sort by creation date (newest first)
        orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        setState(() {
          _orders = orders;
          _error = null;
          _loading = false;
        });
      } else {
        setState(() {
          _error = response['message'] ?? 'Error al cargar las órdenes';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error de conexión: ${e.toString()}';
        _loading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'paid':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'refunded':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'paid':
        return Icons.payment;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'refunded':
        return Icons.undo;
      default:
        return Icons.help;
    }
  }

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  // Paleta de colores consistente con home
  Color get _primaryColor => FlutterFlowTheme.of(context).primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: _isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
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
          expandedHeight: 160,
          backgroundColor: theme.primaryBackground.withValues(alpha: 0.95),
          pinned: true,
          stretch: true,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(color: theme.primaryText),
          ),
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.fadeTitle,
            ],
            titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            centerTitle: false,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.shopping_bag_rounded,
                    color: _primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Mis Compras',
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.secondaryBackground,
                    theme.primaryBackground,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        _buildMobileContent(),
      ],
    );
  }

  Widget _buildMobileContent() {
    if (_loading) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Cargando tus compras...',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.red[400],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _error!,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loadOrders,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Reintentar',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_orders.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate),
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 72,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'No tienes compras aún',
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Explora nuestro catálogo y realiza\\ntu primera compra',
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/homePage', (route) => false),
                  icon: const Icon(Icons.explore_rounded),
                  label: Text(
                    'Explorar Catálogo',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildModernOrderCard(_orders[index], index);
          },
          childCount: _orders.length,
        ),
      ),
    );
  }

  // ===========================================================================
  // 💻 DESKTOP LAYOUT
  // ===========================================================================
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDesktopHeader(),
              const SizedBox(height: 40),
              if (_loading)
                _buildDesktopLoading()
              else if (_error != null)
                _buildDesktopError()
              else if (_orders.isEmpty)
                _buildDesktopEmpty()
              else
                _buildDesktopOrdersGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _primaryColor.withValues(alpha: 0.2),
                _primaryColor.withValues(alpha: 0.05)
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.shopping_bag_rounded,
            color: _primaryColor,
            size: 32,
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historial de Compras',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 38,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _orders.isEmpty
                  ? 'No hay compras registradas'
                  : '${_orders.length} compras realizadas',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const Spacer(),
        if (!_loading && _orders.isNotEmpty)
          ElevatedButton.icon(
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: Text(
              'Actualizar',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: FlutterFlowTheme.of(context).alternate),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDesktopLoading() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(80),
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              'Cargando tus compras...',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopError() {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Container(
        margin: const EdgeInsets.all(80),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.red[400],
            ),
            const SizedBox(height: 24),
            Text(
              _error!,
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _loadOrders,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                'Reintentar',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopEmpty() {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Container(
        margin: const EdgeInsets.all(80),
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: theme.alternate),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                shape: BoxShape.circle,
                border: Border.all(color: theme.alternate),
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: theme.secondaryText,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No tienes compras aún',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Explora nuestro catálogo y descubre\\nlos mejores servicios disponibles',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 16,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/homePage', (route) => false),
              icon: const Icon(Icons.explore_rounded, size: 22),
              label: Text(
                'Explorar Catálogo',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopOrdersGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        return _buildDesktopOrderCard(_orders[index], index);
      },
    );
  }

  Widget _buildModernOrderCard(Order order, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).secondaryBackground,
            FlutterFlowTheme.of(context)
                .secondaryBackground
                .withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: FlutterFlowTheme.of(context).transparent,
          child: InkWell(
            onTap: () {
              // Future: Navigate to order details
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getStatusIcon(order.status),
                          color: _getStatusColor(order.status),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${order.id.substring(order.id.length - 8).toUpperCase()}',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              _formatDate(order.createdAt),
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(order.status)
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          order.statusDisplayName,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(order.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Items
                  ...order.items.take(2).map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.receipt_long_rounded,
                                color: _primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.listingSnapshot.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (item.listingSnapshot.dataDeliveryType !=
                                      null)
                                    Text(
                                      item.listingSnapshot.dataDeliveryType!,
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              CurrencyService.formatFromUSD(item.price),
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor,
                              ),
                            ),
                          ],
                        ),
                      )),
                  if (order.items.length > 2)
                    Padding(
                      padding: const EdgeInsets.only(left: 52),
                      child: Text(
                        '+${order.items.length - 2} más',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).transparent,
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.1)
                              : FlutterFlowTheme.of(context).alternate,
                          FlutterFlowTheme.of(context).transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Footer
                  Row(
                    children: [
                      Icon(
                        Icons.payment_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order.paymentMethodDisplayName,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Total: ',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                      Text(
                        CurrencyService.formatFromUSD(order.totalAmount),
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopOrderCard(Order order, int index) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).secondaryBackground,
            FlutterFlowTheme.of(context)
                .secondaryBackground
                .withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: FlutterFlowTheme.of(context).transparent,
          child: InkWell(
            onTap: () {
              // Future: Navigate to order details
            },
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getStatusColor(order.status)
                                  .withValues(alpha: 0.2),
                              _getStatusColor(order.status)
                                  .withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _getStatusIcon(order.status),
                          color: _getStatusColor(order.status),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${order.id.substring(order.id.length - 8).toUpperCase()}',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(order.createdAt),
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _getStatusColor(order.status).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(order.status)
                            .withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          order.statusDisplayName,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(order.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Items count
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${order.items.length} ${order.items.length == 1 ? 'artículo' : 'artículos'}',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).transparent,
                          FlutterFlowTheme.of(context).alternate,
                          FlutterFlowTheme.of(context).transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Total
                  Row(
                    children: [
                      Icon(
                        Icons.payment_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.paymentMethodDisplayName,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          Text(
                            CurrencyService.formatFromUSD(order.totalAmount),
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
