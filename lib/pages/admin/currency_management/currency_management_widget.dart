import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_snackbar.dart';
import '/backend/api_client.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../components/smart_back_button.dart';
import 'currency_management_model.dart';
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

  // --- PALETA DE COLORES (COHERENCIA CON HOME/ADMIN) ---
  // --- PALETA DE COLORES (COHERENCIA CON HOME/ADMIN) ---
  // Replaced with FlutterFlowTheme in build method

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
      debugPrint('Error loading rates: $e');
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
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gestión de Divisas',
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Define el valor de 1 USD en moneda local para pasarelas regionales',
                            style: GoogleFonts.outfit(
                                fontSize: 16,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText),
                          ),
                        ],
                      ),
                      FFButtonWidget(
                        onPressed: _saveRates,
                        text: 'Guardar Cambios',
                        icon: const Icon(Icons.save_rounded, size: 20),
                        options: FFButtonOptions(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).info,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),

            // Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
              sliver: SliverGrid.count(
                crossAxisCount: 3, // 3 Cards per row on desktop
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.5,
                children: [
                  _CurrencyCard(
                    code: 'COP',
                    name: 'Peso Colombiano',
                    flag: '🇨🇴',
                    controller: _model.copController!,
                    focusNode: _model.copFocusNode!,
                    isDesktop: true,
                  ),
                  _CurrencyCard(
                    code: 'MXN',
                    name: 'Peso Mexicano',
                    flag: '🇲🇽',
                    controller: _model.mxnController!,
                    focusNode: _model.mxnFocusNode!,
                    isDesktop: true,
                  ),
                  _CurrencyCard(
                    code: 'PEN',
                    name: 'Sol Peruano',
                    flag: '🇵🇪',
                    controller: _model.penController!,
                    focusNode: _model.penFocusNode!,
                    isDesktop: true,
                  ),
                  _CurrencyCard(
                    code: 'ARS',
                    name: 'Peso Argentino',
                    flag: '🇦🇷',
                    controller: _model.arsController!,
                    focusNode: _model.arsFocusNode!,
                    isDesktop: true,
                  ),
                  _CurrencyCard(
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
          pinned: true, // Pinned for mobile feel
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
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.3)),
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
              _CurrencyCard(
                code: 'COP',
                name: 'Peso Colombiano',
                flag: '🇨🇴',
                controller: _model.copController!,
                focusNode: _model.copFocusNode!,
                isDesktop: false,
              ),
              const SizedBox(height: 12),
              _CurrencyCard(
                code: 'MXN',
                name: 'Peso Mexicano',
                flag: '🇲🇽',
                controller: _model.mxnController!,
                focusNode: _model.mxnFocusNode!,
                isDesktop: false,
              ),
              const SizedBox(height: 12),
              _CurrencyCard(
                code: 'PEN',
                name: 'Sol Peruano',
                flag: '🇵🇪',
                controller: _model.penController!,
                focusNode: _model.penFocusNode!,
                isDesktop: false,
              ),
              const SizedBox(height: 12),
              _CurrencyCard(
                code: 'ARS',
                name: 'Peso Argentino',
                flag: '🇦🇷',
                controller: _model.arsController!,
                focusNode: _model.arsFocusNode!,
                isDesktop: false,
              ),
              const SizedBox(height: 12),
              _CurrencyCard(
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
            child: FFButtonWidget(
              onPressed: _saveRates,
              text: 'Guardar Todo',
              icon: const Icon(Icons.save_rounded),
              options: FFButtonOptions(
                width: double.infinity,
                height: 56,
                color: FlutterFlowTheme.of(context).primary,
                textStyle: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).info,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                borderRadius: BorderRadius.circular(16),
                elevation: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  final String code;
  final String name;
  final String flag;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDesktop;

  const _CurrencyCard({
    required this.code,
    required this.name,
    required this.flag,
    required this.controller,
    required this.focusNode,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            FlutterFlowTheme.of(context).secondaryBackground, // Surface color
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            code,
                            style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            name,
                            style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isDesktop ? 24 : 16),
                Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .primaryBackground
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        '\$',
                        style: GoogleFonts.outfit(
                          color: Colors.greenAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.00',
                            hintStyle: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'x 1 USD',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().moveY(begin: 10, end: 0, duration: 400.ms);
  }
}
