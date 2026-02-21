import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/components/loading_indicator.dart';
import 'admin_stat_card.dart';

class AdminStatsGrid extends StatelessWidget {
  final Map<String, dynamic> stats;
  final bool isLoading;
  final bool isDesktop;

  const AdminStatsGrid({
    super.key,
    required this.stats,
    this.isLoading = false,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: LoadingIndicator(color: FlutterFlowTheme.of(context).primary),
      );
    }

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
}
