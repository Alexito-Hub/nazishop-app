import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/order_service.dart';

import 'purchase_success_model.dart';
export 'purchase_success_model.dart';

class PurchaseSuccessWidget extends StatefulWidget {
  const PurchaseSuccessWidget({
    super.key,
    this.serviceName,
    this.orderId,
  });

  final String? serviceName;
  final String? orderId;

  static String routeName = 'purchase_success';
  static String routePath = '/purchaseSuccess';

  @override
  State<PurchaseSuccessWidget> createState() => _PurchaseSuccessWidgetState();
}

class _PurchaseSuccessWidgetState extends State<PurchaseSuccessWidget> {
  late PurchaseSuccessModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  bool _isLoading = true;
  Map<String, dynamic>? _credentials;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PurchaseSuccessModel());
    _fetchOrder();
  }

  Future<void> _fetchOrder() async {
    if (widget.orderId == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final order = await OrderService.getOrder(widget.orderId!);

      Map<String, dynamic>? creds;
      if (order != null &&
          order['items'] != null &&
          (order['items'] as List).isNotEmpty) {
        final item = order['items'][0];
        // Check both 'inventory' (populated) and 'inventoryId' (sometimes populated depending on backend)
        if (item['inventory'] != null) {
          creds = item['inventory']['credentials'];
        } else if (item['inventoryId'] != null) {
          creds = item['inventoryId']['credentials'];
        }
      }

      if (mounted) {
        setState(() {
          _credentials = creds;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading order success: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary))
            : (_isDesktop ? _buildDesktopLayout() : _buildMobileLayout()),
      ),
    );
  }

  // ===========================================================================
  // 📱 MOBILE LAYOUT
  // ===========================================================================
  Widget _buildMobileLayout() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSuccessHeader(),
            const SizedBox(height: 32),
            if (_credentials != null) _buildCredentialsCard(),
            const SizedBox(height: 24),
            _buildRulesCard(),
            const SizedBox(height: 32),
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 💻 DESKTOP LAYOUT
  // ===========================================================================
  Widget _buildDesktopLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Header & Buttons
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSuccessHeader(),
                    const SizedBox(height: 48),
                    _buildActionButtons(),
                  ],
                ),
              ),
              const SizedBox(width: 80),

              // Right Column: Credentials & Rules
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    if (_credentials != null)
                      _buildCredentialsCard()
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideX(begin: 0.1),
                    const SizedBox(height: 24),
                    _buildRulesCard()
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideX(begin: 0.1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 🧩 WIDGET COMPONENTS
  // ===========================================================================

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
                color:
                    FlutterFlowTheme.of(context).success.withValues(alpha: 0.2),
                width: 2),
            boxShadow: [
              BoxShadow(
                color:
                    FlutterFlowTheme.of(context).success.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            Icons.check_rounded,
            color: FlutterFlowTheme.of(context).success,
            size: 64,
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 32),
        Text(
          '¡Compra Exitosa!',
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 12),
        Text(
          'Gracias por tu compra. Aquí tienes los datos de acceso para tu servicio.',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: FlutterFlowTheme.of(context).secondaryText,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 300.ms),
        if (widget.orderId != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color:
                  FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: FlutterFlowTheme.of(context).alternate),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SelectableText(
                  'ID: ${widget.orderId!.toUpperCase()}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 13,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.orderId!));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('ID copiado', style: GoogleFonts.outfit()),
                      duration: const Duration(seconds: 1),
                    ));
                  },
                  icon: Icon(Icons.copy,
                      size: 14,
                      color: FlutterFlowTheme.of(context).secondaryText),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                )
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ],
    );
  }

  Widget _buildCredentialsCard() {
    final email = _credentials?['email'] ?? 'No disponible';
    final password = _credentials?['password'] ?? '********';
    final pin = _credentials?['pin'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        boxShadow: [
          BoxShadow(
            color:
                FlutterFlowTheme.of(context).primaryText.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.key_rounded,
                  color: FlutterFlowTheme.of(context).primary),
              const SizedBox(width: 12),
              Text(
                'Tus Credenciales',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCredentialRow('Usuario / Email', email),
          Divider(height: 32, color: FlutterFlowTheme.of(context).alternate),
          _buildCredentialRow('Contraseña', password, obscureText: true),
          if (pin != null && pin.toString().isNotEmpty) ...[
            Divider(height: 32, color: FlutterFlowTheme.of(context).alternate),
            _buildCredentialRow('PIN de Perfil', pin.toString()),
          ],
        ],
      ),
    );
  }

  Widget _buildCredentialRow(String label, String value,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: FlutterFlowTheme.of(context).secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SelectableText(
                value,
                style: GoogleFonts.spaceMono(
                  fontSize: 16,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.w600,
                ),
                // obscurity logic can be handled by manually masking if needed,
                // but since user wants to SEE credentials, we show them.
                // If obscureText is true, we could show dots, but typical 'success' page shows them or has a toggle.
                // For now, let's show plain text as per request "mostrar las credenciales"
              ),
            ),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copiado: $label',
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText)),
                    backgroundColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(Icons.copy_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText, size: 20),
              tooltip: 'Copiar',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRulesCard() {
    final rules = [
      'NO cambies el correo ni la contraseña de la cuenta.',
      'NO agregues, edites ni borres perfiles.',
      'Usa solo 1 dispositivo simultáneo.',
      'Cualquier cambio en la cuenta anula la garantía.',
      'Si tienes problemas, contacta a soporte inmediatamente.'
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel_rounded,
                  color: FlutterFlowTheme.of(context).warning, size: 20),
              const SizedBox(width: 12),
              Text(
                'Reglas de Uso',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...rules.map((rule) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Icon(Icons.circle,
                          size: 4,
                          color: FlutterFlowTheme.of(context).secondaryText),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rule,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: FFButtonWidget(
            onPressed: () {
              context.goNamed(
                'my_purchases',
                extra: <String, dynamic>{
                  kTransitionInfoKey: const TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.fade,
                  ),
                },
              );
            },
            text: 'Ir a Mis Compras',
            icon: const Icon(Icons.shopping_bag_outlined, size: 20),
            options: FFButtonOptions(
              width: double.infinity,
              height: 56,
              color: FlutterFlowTheme.of(context).primary,
              textStyle: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).tertiary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(14),
              elevation: 4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: FFButtonWidget(
            onPressed: () {
              context.goNamed('home');
            },
            text: 'Volver al Inicio',
            options: FFButtonOptions(
              width: double.infinity,
              height: 56,
              color: FlutterFlowTheme.of(context).transparent,
              textStyle: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
