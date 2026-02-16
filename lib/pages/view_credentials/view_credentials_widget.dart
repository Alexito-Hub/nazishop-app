import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../backend/order_service.dart';
import '../../components/smart_back_button.dart';

import 'view_credentials_model.dart';
export 'view_credentials_model.dart';

class ViewCredentialsWidget extends StatefulWidget {
  const ViewCredentialsWidget({
    super.key,
    this.serviceName,
    this.plan,
    this.email,
    this.password,
    this.pin,
    this.isStreaming,
    this.orderId,
  });

  final String? serviceName;
  final String? plan;
  final String? email;
  final String? password;
  final String? pin;
  final bool? isStreaming;
  final String? orderId;

  static String routeName = 'view_credentials';
  static String routePath = '/view-credentials';

  @override
  State<ViewCredentialsWidget> createState() => _ViewCredentialsWidgetState();
}

class _ViewCredentialsWidgetState extends State<ViewCredentialsWidget> {
  late ViewCredentialsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  Map<String, dynamic>? _orderData;
  Map<String, dynamic>? _credentials;

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewCredentialsModel());
    if (widget.orderId != null) {
      _fetchOrderDetails();
    }
  }

  Future<void> _fetchOrderDetails() async {
    setState(() => _isLoading = true);
    try {
      final order = await OrderService.getOrder(widget.orderId!);
      if (order != null) {
        _orderData = order;
        if (order['items'] != null && (order['items'] as List).isNotEmpty) {
          final item = order['items'][0];
          if (item['inventory'] != null) {
            _credentials = item['inventory']['credentials'];
          } else if (item['inventoryId'] != null) {
            _credentials = item['inventoryId']['credentials'];
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching order: $e');
    } finally {
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
    final theme = FlutterFlowTheme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.primaryBackground,
        body: Center(child: CircularProgressIndicator(color: theme.primary)),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: _isDesktop ? null : _buildMobileAppBar(theme),
        body:
            _isDesktop ? _buildDesktopLayout(theme) : _buildMobileLayout(theme),
      ),
    );
  }

  // ===========================================================================
  // 📱 MOBILE LAYOUT
  // ===========================================================================
  PreferredSizeWidget _buildMobileAppBar(FlutterFlowTheme theme) {
    return AppBar(
      backgroundColor: theme.primaryBackground,
      automaticallyImplyLeading: false,
      leading: SmartBackButton(color: theme.primaryText),
      title: Text(
        'Credenciales',
        style: GoogleFonts.outfit(
          color: theme.primaryText,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildMobileLayout(FlutterFlowTheme theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceInfoCard(theme: theme),
          const SizedBox(height: 24),
          Text(
            'Tus Credenciales',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.primaryText,
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 8),
          Text(
            'Copia y guarda estos datos en un lugar seguro.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: theme.secondaryText,
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 24),
          _buildCredentialsContent(theme),
          const SizedBox(height: 24),
          _buildWarningCard(theme),
          const SizedBox(height: 32),
          _buildSupportButton(theme),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ===========================================================================
  // 💻 DESKTOP LAYOUT
  // ===========================================================================
  Widget _buildDesktopLayout(FlutterFlowTheme theme) {
    return Stack(
      children: [
        // Back Button
        Positioned(
          top: 40,
          left: 40,
          child: FlutterFlowIconButton(
            borderColor: theme.alternate,
            borderRadius: 12,
            borderWidth: 1,
            buttonSize: 50,
            fillColor: theme.secondaryBackground,
            icon: Icon(Icons.arrow_back_rounded,
                color: theme.primaryText, size: 24),
            onPressed: () => context.pop(),
          ),
        ),

        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
              child: Column(
                children: [
                  Text(
                    'Detalles de Acceso',
                    style: GoogleFonts.outfit(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Visualiza y gestiona las credenciales de tu servicio',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: theme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Service Info & Warning
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _buildServiceInfoCard(theme: theme),
                            const SizedBox(height: 24),
                            _buildWarningCard(theme),
                            const SizedBox(height: 24),
                            _buildSupportButton(theme),
                          ],
                        ).animate().slideX(begin: -0.1).fadeIn(),
                      ),
                      const SizedBox(width: 40),

                      // Right Column: Credentials
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: theme.alternate.withValues(alpha: 0.3)),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    theme.primaryText.withValues(alpha: 0.06),
                                blurRadius: 32,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          theme.primary.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.vpn_key_rounded,
                                        color: theme.primary),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Credenciales',
                                    style: GoogleFonts.outfit(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              _buildCredentialsContent(theme),
                            ],
                          ),
                        ).animate().slideX(begin: 0.1).fadeIn(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 🧩 WIDGET COMPONENTS
  // ===========================================================================

  Widget _buildServiceInfoCard({required FlutterFlowTheme theme}) {
    final serviceName = widget.serviceName ??
        _orderData?['items']?[0]?['offerSnapshot']?['title'] ??
        'Servicio Digital';

    // Try to get plan from offerSnapshot if not provided
    final offerSnapshot = _orderData?['items']?[0]?['offerSnapshot'];
    final plan = widget.plan ??
        (offerSnapshot?['commercial'] == 'family'
            ? 'Plan Familiar'
            : 'Plan Personal');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.alternate.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.verified_user_outlined,
                    color: theme.primary, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        plan,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: theme.primaryText.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: theme.alternate.withValues(alpha: 0.2)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem('Estado', 'Activo', theme.success, theme: theme),
              _buildInfoItem('Garantía', '30 Días', theme.primary,
                  theme: theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color,
      {required FlutterFlowTheme theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
              fontSize: 12, color: theme.secondaryText.withValues(alpha: 0.8)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCredentialsContent(FlutterFlowTheme theme) {
    final displayEmail = (widget.email != null && widget.email!.isNotEmpty)
        ? widget.email!
        : (_credentials?['email'] ?? 'No disponible');
    final displayPass = (widget.password != null && widget.password!.isNotEmpty)
        ? widget.password!
        : (_credentials?['password'] ?? '********');
    final displayPin = widget.pin ?? _credentials?['pin']?.toString();

    return Column(
      children: [
        _buildCredentialField(
            label: 'Correo / Usuario',
            value: displayEmail,
            icon: Icons.email_rounded,
            theme: theme,
            prefixColor: theme.primary.withValues(alpha: 0.1)),
        const SizedBox(height: 20),
        _buildCredentialField(
            label: 'Contraseña',
            value: displayPass,
            icon: Icons.lock_rounded,
            theme: theme,
            prefixColor: theme.warning.withValues(alpha: 0.08)),
        if (displayPin != null &&
            displayPin.isNotEmpty &&
            displayPin != 'null') ...[
          const SizedBox(height: 20),
          _buildCredentialField(
              label: 'PIN de Perfil',
              value: displayPin,
              icon: Icons.pin_rounded,
              theme: theme,
              prefixColor: theme.tertiary.withValues(alpha: 0.08)),
        ],
        const SizedBox(height: 20),
        _buildCredentialField(
            label: 'Entrega',
            value:
                widget.isStreaming == true ? 'Streaming' : 'Cuenta / Licencia',
            icon: Icons.send_outlined,
            theme: theme,
            prefixColor: theme.secondary.withValues(alpha: 0.08)),
      ],
    );
  }

  Widget _buildCredentialField(
      {required String label,
      required String value,
      required IconData icon,
      required FlutterFlowTheme theme,
      Color? prefixColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: theme.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.alternate.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: prefixColor ?? theme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: theme.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SelectableText(
                  value,
                  style: GoogleFonts.spaceMono(
                    fontSize: 15,
                    color: theme.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy_rounded, color: theme.primary, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Copiado: $label',
                        style: GoogleFonts.outfit(color: theme.primaryText)),
                    duration: const Duration(seconds: 1),
                    backgroundColor: theme.secondaryBackground,
                  ));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWarningCard(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: theme.warning, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Importante',
                  style: GoogleFonts.outfit(
                    color: theme.warning,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'No cambies los datos de acceso ni compartas esta cuenta, o perderás la garantía.',
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSupportButton(FlutterFlowTheme theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FFButtonWidget(
        onPressed: () => context.pushNamed('support'),
        text: 'Contactar Soporte',
        icon: const Icon(Icons.support_agent_outlined, size: 18),
        options: FFButtonOptions(
          width: 220,
          height: 48,
          color: theme.primary,
          textStyle: GoogleFonts.outfit(
            color: theme.tertiary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
