import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'view_streaming_credentials_model.dart';
import '../../components/smart_back_button.dart';
export 'view_streaming_credentials_model.dart';

class ViewStreamingCredentialsWidget extends StatefulWidget {
  const ViewStreamingCredentialsWidget({
    super.key,
    this.orderId,
    this.serviceName,
    this.plan,
    this.email,
    this.password,
    this.pin,
    this.profiles,
    this.expiryDate,
  });

  final String? orderId;
  final String? serviceName;
  final String? plan;
  final String? email;
  final String? password;
  final String? pin;
  final String? profiles;
  final String? expiryDate;

  static String routeName = 'view_streaming_credentials';
  static String routePath = '/viewStreamingCredentials';

  @override
  State<ViewStreamingCredentialsWidget> createState() =>
      _ViewStreamingCredentialsWidgetState();
}

class _ViewStreamingCredentialsWidgetState
    extends State<ViewStreamingCredentialsWidget> {
  late ViewStreamingCredentialsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewStreamingCredentialsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copiado al portapapeles'),
        backgroundColor: FlutterFlowTheme.of(context).success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    final serviceName = widget.serviceName ?? 'Netflix Premium';
    final plan = widget.plan ?? '4 Pantallas - 1 Mes';
    final email = widget.email ?? 'usuario@ejemplo.com';
    final password = widget.password ?? 'Pass123456';
    final pin = widget.pin ?? '1234';
    final profiles = widget.profiles ?? '4 perfiles';
    final expiryDate = widget.expiryDate ?? '15 Nov 2025';

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: isDesktop
            ? null
            : AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                automaticallyImplyLeading: false,
                leading: SmartBackButton(
                    color: FlutterFlowTheme.of(context).primaryText),
                title: Text(
                  'Credenciales Streaming',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 22.0 * FlutterFlowTheme.fontSizeFactor,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                actions: const [],
                centerTitle: true,
                elevation: 0.0,
              ),
        body: SafeArea(
          top: true,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 900 : double.infinity,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 32.0 : 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isDesktop) ...[
                        Container(
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: FlutterFlowTheme.of(context)
                                    .primaryText
                                    .withValues(alpha: 0.05),
                                blurRadius: 20.0,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SmartBackButton(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText),
                              const SizedBox(width: 16.0),
                              Icon(
                                Icons.play_circle_filled,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 36.0,
                              ),
                              const SizedBox(width: 12.0),
                              Text(
                                'Credenciales de Streaming',
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32.0),
                      ],
                      // Info del servicio
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context).primary,
                              FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.8)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 12.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 60.0,
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Icon(
                                      Icons.play_circle_filled,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 36.0,
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          serviceName,
                                          style: FlutterFlowTheme.of(context)
                                              .headlineSmall
                                              .override(
                                                font: GoogleFonts.inter(),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          plan,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText
                                                        .withValues(alpha: 0.1),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Perfiles',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Vence',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.inter(),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText
                                                        .withValues(alpha: 0.1),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          expiryDate,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                font: GoogleFonts.inter(),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24.0),

                      // Credenciales
                      Text(
                        'Credenciales de Acceso',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.inter(),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),

                      const SizedBox(height: 16.0),

                      // Email/Usuario
                      _buildCredentialField(
                        context: context,
                        icon: Icons.email_outlined,
                        label: 'Email / Usuario',
                        value: email,
                        onCopy: () => _copyToClipboard(email, 'Email'),
                      ),

                      const SizedBox(height: 12.0),

                      // Contraseña
                      _buildCredentialField(
                        context: context,
                        icon: Icons.lock_outline,
                        label: 'Contraseña',
                        value: password,
                        isPassword: true,
                        onCopy: () => _copyToClipboard(password, 'Contraseña'),
                      ),

                      const SizedBox(height: 12.0),

                      // PIN
                      _buildCredentialField(
                        context: context,
                        icon: Icons.pin_outlined,
                        label: 'PIN de Seguridad',
                        value: pin,
                        onCopy: () => _copyToClipboard(pin, 'PIN'),
                      ),

                      const SizedBox(height: 24.0),

                      // Instrucciones
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .info
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).info,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 24.0,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    'Instrucciones de Uso',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.inter(),
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                '1. Ingresa al sitio web o aplicación del servicio\n'
                                '2. Usa el email y contraseña proporcionados\n'
                                '3. Si te solicita PIN, usa el PIN de seguridad\n'
                                '4. Puedes crear hasta $profiles diferentes\n'
                                '5. NO cambies la contraseña ni la información de pago',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16.0),

                      // Advertencia
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .warning
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).warning,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: FlutterFlowTheme.of(context).warning,
                                size: 24.0,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  'Estas credenciales son compartidas. NO modifiques la información de la cuenta. El servicio vence el $expiryDate.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.inter(),
                                        color: FlutterFlowTheme.of(context)
                                            .warning,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialField({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    bool isPassword = false,
    required VoidCallback onCopy,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20.0,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                const SizedBox(width: 8.0),
                Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isPassword && !_passwordVisible ? '••••••••' : value,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          font: GoogleFonts.inter(),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                if (isPassword)
                  IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    size: 20.0,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  onPressed: onCopy,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
