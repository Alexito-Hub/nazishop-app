import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orders_stats_model.dart';
import '../../../components/smart_back_button.dart';
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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading:
            SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
        title: Row(
          children: [
            Icon(
              Icons.analytics,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 28.0,
            ),
            const SizedBox(width: 12.0),
            Text(
              'Estadísticas de Pedidos',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.inter(),
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Período selector (Can be extracted too if it grows)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
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

                // Resumen principal
                Text(
                  'Resumen de Ventas',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.inter(),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16.0),

                const OrdersSummaryGrid(),

                const SizedBox(height: 24.0),

                // Ingresos
                const RevenueCard(),

                const SizedBox(height: 24.0),

                // Productos más vendidos
                const TopProductsList(),

                const SizedBox(height: 24.0),

                // Estadísticas por día de la semana
                const WeeklyPerformance(),

                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String label, bool isSelected) {
    return InkWell(
      onTap: () {
        // Cambiar período
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(),
                color: isSelected
                    ? FlutterFlowTheme.of(context).tertiary
                    : FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }
}
