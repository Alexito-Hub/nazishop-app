import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_snackbar.dart';
import '/backend/api_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/smart_back_button.dart';
import 'currency_management_model.dart';
import 'components/currency_card.dart';
import 'components/currency_header.dart';

export 'currency_management_model.dart';

class CurrencyManagementWidget extends StatefulWidget {
  const CurrencyManagementWidget({super.key});

  static String routeName = 'currency_management';
  static String routePath = '/currencyManagement';

  @override
  State<CurrencyManagementWidget> createState() =>
      _CurrencyManagementWidgetState();
}

class _CurrencyManagementWidgetState extends State<CurrencyManagementWidget> {
  late CurrencyManagementModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CurrencyManagementModel());

    _initControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRates());
  }

  void _initControllers() {
    _model.copController ??= TextEditingController(text: '4200');
    _model.copFocusNode ??= FocusNode();

    _model.mxnController ??= TextEditingController(text: '17.50');
    _model.mxnFocusNode ??= FocusNode();

    _model.penController ??= TextEditingController(text: '3.75');
    _model.penFocusNode ??= FocusNode();

    _model.arsController ??= TextEditingController(text: '850');
    _model.arsFocusNode ??= FocusNode();

    _model.clpController ??= TextEditingController(text: '920');
    _model.clpFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadRates() async {
    try {
      final res = await ApiClient.post('/api/admin/currencies',
          body: {'action': 'get_all'});
      if (res['status'] == true) {
        final List<dynamic> currencies = res['data'];
        for (var c in currencies) {
          final code = c['code'];
          final rate = c['exchangeRate']?.toString() ?? '0';
          if (code == 'COP') _model.copController?.text = rate;
          if (code == 'MXN') _model.mxnController?.text = rate;
          if (code == 'PEN') _model.penController?.text = rate;
          if (code == 'ARS') _model.arsController?.text = rate;
          if (code == 'CLP') _model.clpController?.text = rate;
        }
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) CustomSnackBar.error(context, 'Error cargando tasas: $e');
    }
  }

  Future<void> _saveRates() async {
    try {
      final rates = {
        'COP':
            double.tryParse(_model.copController!.text.replaceAll(',', '')) ??
                0,
        'MXN':
            double.tryParse(_model.mxnController!.text.replaceAll(',', '')) ??
                0,
        'PEN':
            double.tryParse(_model.penController!.text.replaceAll(',', '')) ??
                0,
        'ARS':
            double.tryParse(_model.arsController!.text.replaceAll(',', '')) ??
                0,
        'CLP':
            double.tryParse(_model.clpController!.text.replaceAll(',', '')) ??
                0,
      };

      final res = await ApiClient.post('/api/admin/currencies',
          body: {'action': 'update_rates', 'rates': rates});

      if (res['status'] == true && mounted) {
        CustomSnackBar.success(
          context,
          'Las tasas de cambio se han actualizado correctamente',
          title: 'Guardado',
        );
      } else if (mounted) {
        CustomSnackBar.error(context, res['msg'] ?? 'Error al guardar');
      }
    } catch (e) {
      if (mounted) CustomSnackBar.error(context, 'Error de conexión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (_isDesktop) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  // ===========================================================================
  // 💻 DESKTOP LAYOUT (>= 900px)
  // ===========================================================================
  Widget _buildDesktopLayout() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            CurrencyHeader(onSave: _saveRates),

            // Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
              sliver: SliverGrid.count(
                crossAxisCount: 3, // 3 Cards per row on desktop
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.5,
                children: [
                  CurrencyCard(
                    code: 'COP',
                    name: 'Peso Colombiano',
                    flag: '🇨🇴',
                    controller: _model.copController!,
                    focusNode: _model.copFocusNode!,
                    isDesktop: true,
                  ),
                  CurrencyCard(
                    code: 'MXN',
                    name: 'Peso Mexicano',
                    flag: '🇲🇽',
                    controller: _model.mxnController!,
                    focusNode: _model.mxnFocusNode!,
                    isDesktop: true,
                  ),
                  CurrencyCard(
                    code: 'PEN',
                    name: 'Sol Peruano',
                    flag: '🇵🇪',
                    controller: _model.penController!,
                    focusNode: _model.penFocusNode!,
                    isDesktop: true,
                  ),
                  CurrencyCard(
                    code: 'ARS',
                    name: 'Peso Argentino',
                    flag: '🇦🇷',
                    controller: _model.arsController!,
                    focusNode: _model.arsFocusNode!,
                    isDesktop: true,
                  ),
                  CurrencyCard(
                    code: 'CLP',
                    name: 'Peso Chileno',
                    flag: '🇨🇱',
                    controller: _model.clpController!,
                    focusNode: _model.clpFocusNode!,
                    isDesktop: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 📱 MOBILE/TABLET LAYOUT (< 900px)
  // ===========================================================================
  Widget _buildMobileLayout() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          pinned: true,
          floating: true,
          elevation: 0,
          expandedHeight: 80,
          leadingWidth: 70,
          leading:
              SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
          centerTitle: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Divisas',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
          ),
        ),

        // Info Card Mobile
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: FlutterFlowTheme.of(context).primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Actualiza las tasas para asegurar conversiones correctas en pasarelas locales.',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              CurrencyCard(
                code: 'COP',
                name: 'Peso Colombiano',
                flag: '🇨🇴',
                controller: _model.copController!,
                focusNode: _model.copFocusNode!,
                isDesktop: false,
              ),
              const SizedBox(height: 12),
              CurrencyCard(
                code: 'MXN',
                name: 'Peso Mexicano',
                flag: '🇲🇽',
                controller: _model.mxnController!,
                focusNode: _model.mxnFocusNode!,
                isDesktop: false,
              ),
              const SizedBox(height: 12),
              CurrencyCard(
                code: 'PEN',
                name: 'Sol Peruano',
                flag: '🇵🇪',
                controller: _model.penController!,
                focusNode: _model.penFocusNode!,
                isDesktop: false,
              ),
              const SizedBox(height: 12),
              CurrencyCard(
                code: 'ARS',
                name: 'Peso Argentino',
                flag: '🇦🇷',
                controller: _model.arsController!,
                focusNode: _model.arsFocusNode!,
                isDesktop: false,
              ),
              const SizedBox(height: 12),
              CurrencyCard(
                code: 'CLP',
                name: 'Peso Chileno',
                flag: '🇨🇱',
                controller: _model.clpController!,
                focusNode: _model.clpFocusNode!,
                isDesktop: false,
              ),
              const SizedBox(height: 100), // Space for FAB or Button
            ]),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).secondary
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _saveRates,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.save_rounded, color: Colors.white),
                label: Text(
                  'Guardar Todo',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
