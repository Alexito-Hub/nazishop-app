import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/admin/admin_auth_guard.dart';
import '/auth/nazishop_auth/auth_util.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'admin_model.dart';
export 'admin_model.dart';
import 'components/admin_stat_card.dart';
import 'components/admin_action_card.dart';

class AdminWidget extends StatefulWidget {
  const AdminWidget({super.key});

  static String routeName = 'admin';
  static String routePath = '/admin';

  @override
  State<AdminWidget> createState() => _AdminWidgetState();
}

class _AdminWidgetState extends State<AdminWidget> {
  late AdminModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminModel());

    _model.onDataChanged = () {
      if (mounted) setState(() {});
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loggedIn && (currentUser?.isAdmin ?? false)) {
        _model.loadDashboardStats();
      }
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
      title: 'Panel de Administrador',
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = MediaQuery.of(context).size.width >= 900;
            if (isDesktop) {
              return _buildDesktopLayout();
            } else {
              return _buildMobileLayout();
            }
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MOBILE LAYOUT
  // ---------------------------------------------------------------------------
  Widget _buildMobileLayout() {
    return RefreshIndicator(
      color: FlutterFlowTheme.of(context).primary,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      onRefresh: () async {
        _model.loadDashboardStats();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            floating: true,
            centerTitle: true,
            title: Text(
              'Panel Admin',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader('Resumen General'),
                const SizedBox(height: 16),
                _buildStatsGrid(isDesktop: false),
                const SizedBox(height: 32),
                _buildSectionHeader('Gestión del Sistema'),
                const SizedBox(height: 16),
                _buildManagementGrid(isDesktop: false),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DESKTOP LAYOUT
  // ---------------------------------------------------------------------------
  Widget _buildDesktopLayout() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: RefreshIndicator(
          color: FlutterFlowTheme.of(context).primary,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          onRefresh: () async {
            _model.loadDashboardStats();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(32.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildDesktopHeader(),
                    const SizedBox(height: 48),
                    _buildSectionHeader('Resumen General'),
                    const SizedBox(height: 24),
                    _buildStatsGrid(isDesktop: true),
                    const SizedBox(height: 48),
                    // "Acceso Rápido" eliminado en Desktop según requerimiento
                    // El sidebar lateral ya cubre esta función
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Panel Admin',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Centro de control para operadores y administradores',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context)
                .primaryText
                .withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: FlutterFlowTheme.of(context)
                    .primaryText
                    .withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Icon(Icons.flash_on_rounded,
                  color: FlutterFlowTheme.of(context).primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'Live Sync Active',
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        color: FlutterFlowTheme.of(context).primaryText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ).animate().fadeIn(duration: 400.ms).slideX();
  }

  Widget _buildStatsGrid({required bool isDesktop}) {
    if (_model.isLoadingStats) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary),
      );
    }

    final stats = _model.getStatsMap();

    // Responsive grid
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 210, // Height for Stat Cards
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        AdminStatCard(
          title: 'Ingresos',
          value: '\$${(stats['totalRevenue'] ?? 0).toStringAsFixed(0)}',
          icon: Icons.payments_rounded,
          color: FlutterFlowTheme.of(context).primary,
          subtitle: '+${stats['completedOrders'] ?? 0} ventas',
        ),
        AdminStatCard(
          title: 'Pedidos',
          value: '${stats['totalOrders'] ?? 0}',
          icon: Icons.confirmation_number_rounded,
          color: FlutterFlowTheme.of(context).tertiary,
          subtitle: '${stats['pendingOrders'] ?? 0} pendientes',
        ),
        AdminStatCard(
          title: 'Usuarios',
          value: '${stats['totalUsers'] ?? 0}',
          icon: Icons.people_alt_rounded,
          color: FlutterFlowTheme.of(context).secondary,
          subtitle: '${stats['activeUsers'] ?? 0} activos',
        ),
        AdminStatCard(
          title: 'Servicios',
          value: '${stats['totalServices'] ?? 0}',
          icon: Icons.hub_rounded,
          color: FlutterFlowTheme.of(context).alternate,
          subtitle: '${stats['activeServices'] ?? 0} online',
        ),
      ],
    );
  }

  Widget _buildManagementGrid({required bool isDesktop}) {
    final actions = [
      _AdminAction(
          'Categorías',
          'Gestionar agrupaciones',
          Icons.grid_view_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('admin_categories')),
      _AdminAction(
          'Servicios',
          'Marcas y Plataformas',
          Icons.layers_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('admin_services')),
      _AdminAction(
          'Listings',
          'Cuentas, perfiles y más',
          Icons.inventory_2_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('admin_listings')),
      _AdminAction(
          'Inventario',
          'Stock y Credenciales',
          Icons.warehouse_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('admin_inventory')),
      _AdminAction(
          'Pedidos',
          'Ventas y facturación',
          Icons.receipt_long_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('orders_management')),
      _AdminAction(
          'Promociones',
          'Banners y Anuncios',
          Icons.campaign_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('admin_promotions')),
      _AdminAction(
          'Cupones',
          'Descuentos y Ofertas',
          Icons.local_offer_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('admin_coupons')),
      _AdminAction(
          'Notificaciones',
          'Push y Mensajes',
          Icons.notifications_active_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('admin_notifications')),
      _AdminAction(
          'Analíticas',
          'Estadísticas y Reportes',
          Icons.bar_chart_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('admin_analytics')),
      _AdminAction(
          'Usuarios',
          'Clientes y permisos',
          Icons.people_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('users_management')),
      _AdminAction(
          'Configuración',
          'Ajustes del sistema',
          Icons.tune_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('admin_config')),
      _AdminAction(
          'Divisas',
          'Tipos de cambio',
          Icons.currency_exchange_rounded,
          FlutterFlowTheme.of(context).primary,
          () => context.goNamed('currency_management')),
    ];

    return GridView.builder(
      itemCount: actions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisExtent: 120,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return AdminActionCard(
          title: action.title,
          subtitle: action.subtitle,
          icon: action.icon,
          color: action.color,
          onTap: action.onTap,
        ).animate().fadeIn(delay: (200 + (index * 50)).ms).slideX();
      },
    );
  }
}

class _AdminAction {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _AdminAction(this.title, this.subtitle, this.icon, this.color, this.onTap);
}
