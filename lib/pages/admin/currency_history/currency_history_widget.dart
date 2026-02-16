import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'currency_history_model.dart';
import '../../../components/smart_back_button.dart';
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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B35),
        automaticallyImplyLeading: false,
        leading:
            SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
        title: Row(
          children: [
            Icon(Icons.history,
                color: FlutterFlowTheme.of(context).primaryText, size: 28.0),
            const SizedBox(width: 12.0),
            Text('Historial de Cambios',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.inter(),
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFFB951)]),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.trending_up,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 48.0),
                      const SizedBox(height: 16.0),
                      Text('Historial de Divisas',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                  font: GoogleFonts.inter(),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      Text('Cambios recientes en tasas de cambio',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                  font: GoogleFonts.inter(),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0)),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Text('Cambios Recientes',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.inter(),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16.0),
                _buildHistoryItem('ARS', '1.100 → 1.150', 'Hoy 10:30 AM', true),
                _buildHistoryItem(
                    'COP', '4.200 → 4.180', 'Ayer 3:15 PM', false),
                _buildHistoryItem('MXN', '17.50 → 17.65', '2 días atrás', true),
                _buildHistoryItem('CLP', '920 → 915', '3 días atrás', false),
                _buildHistoryItem('PEN', '3.75 → 3.78', '4 días atrás', true),
                _buildHistoryItem('BRL', '5.20 → 5.15', '5 días atrás', false),
                _buildHistoryItem('UYU', '42.5 → 43.0', '6 días atrás', true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
      String currency, String change, String time, bool isIncrease) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Row(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
                child: Text(currency,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B35),
                        fontSize: 16.0))),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(change,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.inter(),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600)),
                Text(time,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0)),
              ],
            ),
          ),
          Icon(isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
              color: isIncrease
                  ? FlutterFlowTheme.of(context).success
                  : FlutterFlowTheme.of(context).error,
              size: 24.0),
        ],
      ),
    );
  }
}
