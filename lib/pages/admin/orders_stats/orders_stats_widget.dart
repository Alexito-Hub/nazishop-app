import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orders_stats_model.dart';
import '../../../components/smart_back_button.dart';
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
                // Período selector
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

                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisExtent: 140, // Height for Stat Cards
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  children: [
                    _buildStatCard(
                      'Pedidos Hoy',
                      '24',
                      Icons.today,
                      FlutterFlowTheme.of(context).primary,
                      '+18%',
                    ),
                    _buildStatCard(
                      'Completados',
                      '18',
                      Icons.check_circle,
                      FlutterFlowTheme.of(context).success,
                      '75%',
                    ),
                    _buildStatCard(
                      'Pendientes',
                      '5',
                      Icons.pending,
                      FlutterFlowTheme.of(context).warning,
                      '21%',
                    ),
                    _buildStatCard(
                      'Cancelados',
                      '1',
                      Icons.cancel,
                      FlutterFlowTheme.of(context).error,
                      '4%',
                    ),
                  ],
                ),

                const SizedBox(height: 24.0),

                // Ingresos
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).primary,
                        FlutterFlowTheme.of(context).tertiary
                      ],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(-1.0, 0.0),
                      end: AlignmentDirectional(1.0, 0.0),
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              color: FlutterFlowTheme.of(context).tertiary,
                              size: 32.0,
                            ),
                            const SizedBox(width: 12.0),
                            Text(
                              'Ingresos del Mes',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          '\$4,500.000',
                          style: FlutterFlowTheme.of(context)
                              .displaySmall
                              .override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).tertiary,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: FlutterFlowTheme.of(context)
                                  .tertiary
                                  .withValues(alpha: 0.7),
                              size: 20.0,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              '+12% vs mes anterior',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color: FlutterFlowTheme.of(context)
                                        .tertiary
                                        .withValues(alpha: 0.7),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24.0),

                // Productos más vendidos
                Text(
                  'Productos Más Vendidos',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.inter(),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16.0),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildTopProductItem('Netflix Premium', '89 ventas', 1),
                        const Divider(height: 24.0),
                        _buildTopProductItem(
                            'Spotify Familiar', '67 ventas', 2),
                        const Divider(height: 24.0),
                        _buildTopProductItem('Disney+ Premium', '54 ventas', 3),
                        const Divider(height: 24.0),
                        _buildTopProductItem('HBO Max', '42 ventas', 4),
                        const Divider(height: 24.0),
                        _buildTopProductItem('YouTube Premium', '38 ventas', 5),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24.0),

                // Estadísticas por día de la semana
                Text(
                  'Rendimiento Semanal',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.inter(),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16.0),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildDayStats('Lunes', 156, 0.65),
                        const SizedBox(height: 12.0),
                        _buildDayStats('Martes', 189, 0.79),
                        const SizedBox(height: 12.0),
                        _buildDayStats('Miércoles', 142, 0.59),
                        const SizedBox(height: 12.0),
                        _buildDayStats('Jueves', 203, 0.85),
                        const SizedBox(height: 12.0),
                        _buildDayStats('Viernes', 234, 0.98),
                        const SizedBox(height: 12.0),
                        _buildDayStats('Sábado', 240, 1.0),
                        const SizedBox(height: 12.0),
                        _buildDayStats('Domingo', 198, 0.83),
                      ],
                    ),
                  ),
                ),

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

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color, String badge) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    badge,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).tertiary,
                          fontSize: 10.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.inter(),
                        color: color,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProductItem(String name, String sales, int position) {
    Color positionColor;
    switch (position) {
      case 1:
        positionColor = const Color(0xFFFFB951);
        break;
      case 2:
        positionColor = const Color(0xFFC0C0C0);
        break;
      case 3:
        positionColor = const Color(0xFFCD7F32);
        break;
      default:
        positionColor = FlutterFlowTheme.of(context).secondaryText;
    }

    return Row(
      children: [
        Container(
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            color: positionColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '#$position',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.inter(),
                    color: positionColor,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            name,
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.inter(),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Text(
          sales,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(),
                color: FlutterFlowTheme.of(context).primary,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildDayStats(String day, int orders, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              day,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '$orders pedidos',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.inter(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8.0,
            backgroundColor: FlutterFlowTheme.of(context).alternate,
            valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary),
          ),
        ),
      ],
    );
  }
}
