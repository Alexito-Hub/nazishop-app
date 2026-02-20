import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orders_stats_model.dart';
import '/components/design_system.dart';
import 'components/orders_summary_grid.dart';
import 'components/revenue_card.dart';
import 'components/top_products_list.dart';
import 'components/weekly_performance.dart';
export 'orders_stats_model.dart';

class OrdersStatsWidget extends StatefulWidget {
  const OrdersStatsWidget({super.key});

  @override
  State<OrdersStatsWidget> createState() => _OrdersStatsWidgetState();
}

class _OrdersStatsWidgetState extends State<OrdersStatsWidget> {
  late OrdersStatsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrdersStatsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const DSMobileAppBar(title: 'Estadísticas de Pedidos'),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Período selector
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildPeriodButton('Hoy', true),
                          _buildPeriodButton('Semana', false),
                          _buildPeriodButton('Mes', false),
                          _buildPeriodButton('Año', false),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  Text(
                    'Resumen de Ventas',
                    style: GoogleFonts.outfit(
                      color: theme.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  const OrdersSummaryGrid(),
                  const SizedBox(height: 24.0),
                  const RevenueCard(),
                  const SizedBox(height: 24.0),
                  const TopProductsList(),
                  const SizedBox(height: 24.0),
                  const WeeklyPerformance(),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String label, bool isSelected) {
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: () {
        // Cambiar período
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : theme.primaryBackground,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? theme.tertiary : theme.primaryText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
