import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'currency_history_model.dart';
import '/components/design_system.dart';
export 'currency_history_model.dart';

class CurrencyHistoryWidget extends StatefulWidget {
  const CurrencyHistoryWidget({super.key});

  @override
  State<CurrencyHistoryWidget> createState() => _CurrencyHistoryWidgetState();
}

class _CurrencyHistoryWidgetState extends State<CurrencyHistoryWidget> {
  late CurrencyHistoryModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CurrencyHistoryModel());
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
          const DSMobileAppBar(title: 'Historial de Cambios'),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.primary, theme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.trending_up,
                            color: theme.tertiary, size: 48.0),
                        const SizedBox(height: 16.0),
                        Text(
                          'Historial de Divisas',
                          style: GoogleFonts.outfit(
                            color: theme.tertiary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Cambios recientes en tasas de cambio',
                          style: GoogleFonts.outfit(
                            color: theme.tertiary.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'Cambios Recientes',
                    style: GoogleFonts.outfit(
                      color: theme.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildHistoryItem(
                      'ARS', '1.100 → 1.150', 'Hoy 10:30 AM', true),
                  _buildHistoryItem(
                      'COP', '4.200 → 4.180', 'Ayer 3:15 PM', false),
                  _buildHistoryItem(
                      'MXN', '17.50 → 17.65', '2 días atrás', true),
                  _buildHistoryItem('CLP', '920 → 915', '3 días atrás', false),
                  _buildHistoryItem('PEN', '3.75 → 3.78', '4 días atrás', true),
                  _buildHistoryItem(
                      'BRL', '5.20 → 5.15', '5 días atrás', false),
                  _buildHistoryItem('UYU', '42.5 → 43.0', '6 días atrás', true),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
      String currency, String change, String time, bool isIncrease) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Text(
                currency,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  change,
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.outfit(
                    color: theme.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
            color: isIncrease ? theme.success : theme.error,
            size: 24.0,
          ),
        ],
      ),
    );
  }
}
