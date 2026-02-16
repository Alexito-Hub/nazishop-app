import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/admin/admin_auth_guard.dart';
import 'package:nazi_shop/backend/currency_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import 'orders_management_model.dart';
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
          backgroundColor: FlutterFlowTheme.of(context).transparent,
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
        SliverToBoxAdapter(child: _buildFilters()),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilters(),
                    const SizedBox(height: 24),
                    _buildStats(),
                  ],
                ),
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

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip('Todas', null),
          const SizedBox(width: 8.0),
          _buildFilterChip('Pendientes', 'PENDING'),
          const SizedBox(width: 8.0),
          _buildFilterChip('Proceso', 'PROCESSING'),
          const SizedBox(width: 8.0),
          _buildFilterChip('Completadas', 'COMPLETED'),
          const SizedBox(width: 8.0),
          _buildFilterChip('Fallidas', 'FAILED'),
          const SizedBox(width: 8.0),
          _buildFilterChip('Canceladas', 'CANCELLED'),
        ],
      ),
    );
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
              '${_model.orders.length}',
              Icons.receipt_long,
              FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickStat(
              'Pendientes',
              '${_model.orders.where((o) => o['status'] == 'PENDING').length}',
              Icons.pending,
              FlutterFlowTheme.of(context).warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickStat(
              'Éxito',
              '${_model.orders.where((o) => o['status'] == 'COMPLETED').length}',
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
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOrderCard(_model.orders[index]),
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

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final orderId = order['orderId'] ?? order['id'] ?? 'Sin ID';
    final status = order['status'] ?? 'PENDING';
    final serviceName = order['serviceName'] ?? 'Servicio desconocido';
    final amount = (order['amount'] ?? 0.0).toDouble();
    final userName = order['userName'] ?? 'Usuario desconocido';
    final createdAt = order['createdAt'];

    Color statusColor;
    IconData statusIcon;
    switch (status) {
      case 'COMPLETED':
        statusColor = FlutterFlowTheme.of(context).success;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'PROCESSING':
        statusColor = FlutterFlowTheme.of(context).info;
        statusIcon = Icons.sync_rounded;
        break;
      case 'FAILED':
        statusColor = FlutterFlowTheme.of(context).error;
        statusIcon = Icons.error_rounded;
        break;
      case 'CANCELLED':
        statusColor = FlutterFlowTheme.of(context).secondaryText;
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = FlutterFlowTheme.of(context).secondaryText;
        statusIcon = Icons.pending_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context)
            .copyWith(dividerColor: FlutterFlowTheme.of(context).transparent),
        child: ExpansionTile(
          collapsedIconColor: FlutterFlowTheme.of(context).secondaryText,
          iconColor: FlutterFlowTheme.of(context).primary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Icon(statusIcon, color: statusColor, size: 24),
          ),
          title: Text(
            serviceName,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Usuario: $userName',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 13),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor.withValues(alpha: 0.1)),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    CurrencyService.formatFromUSD(amount),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                border: Border(
                    top: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID DE PEDIDO',
                              style: GoogleFonts.outfit(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          Text(orderId,
                              style: GoogleFonts.outfit(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 12)),
                        ],
                      ),
                      if (createdAt != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('FECHA',
                                style: GoogleFonts.outfit(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                            Text(_formatDate(createdAt),
                                style: GoogleFonts.outfit(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 12)),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Text('ACCIONES DE GESTIÓN',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: [
                      if (status == 'PENDING')
                        _buildActionButton(
                          'Procesar',
                          Icons.sync_rounded,
                          FlutterFlowTheme.of(context).warning,
                          () => _updateStatus(orderId, 'PROCESSING'),
                        ),
                      if (status == 'PROCESSING')
                        _buildActionButton(
                          'Completar',
                          Icons.check_circle_rounded,
                          FlutterFlowTheme.of(context).success,
                          () => _updateStatus(orderId, 'COMPLETED'),
                        ),
                      if (status != 'CANCELLED' && status != 'COMPLETED')
                        _buildActionButton(
                          'Cancelar',
                          Icons.cancel_rounded,
                          FlutterFlowTheme.of(context).secondaryText,
                          () => _updateStatus(orderId, 'CANCELLED'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(String orderId, String status) async {
    try {
      await _model.updateOrderStatus(orderId: orderId, status: status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Estado actualizado a $status',
              style:
                  GoogleFonts.outfit(color: FlutterFlowTheme.of(context).info),
            ),
            backgroundColor: FlutterFlowTheme.of(context).primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
              style:
                  GoogleFonts.outfit(color: FlutterFlowTheme.of(context).info),
            ),
            backgroundColor: FlutterFlowTheme.of(context).primary,
          ),
        );
      }
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      if (date is String) {
        final dt = DateTime.parse(date);
        return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
      }
      return date.toString();
    } catch (e) {
      return date.toString();
    }
  }
}
