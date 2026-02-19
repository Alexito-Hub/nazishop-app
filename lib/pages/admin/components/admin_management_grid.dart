import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'admin_action_card.dart';

class AdminManagementGrid extends StatelessWidget {
  final bool isDesktop;

  const AdminManagementGrid({
    super.key,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
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
