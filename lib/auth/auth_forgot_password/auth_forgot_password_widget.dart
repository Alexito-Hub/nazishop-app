import '/auth/nazishop_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_forgot_password_model.dart';
export 'auth_forgot_password_model.dart';

class AuthForgotPasswordWidget extends StatefulWidget {
  const AuthForgotPasswordWidget({super.key});

  static String routeName = 'auth_forgot_password';
  static String routePath = '/authForgotPassword';

  @override
  State<AuthForgotPasswordWidget> createState() =>
      _AuthForgotPasswordWidgetState();
}

class _AuthForgotPasswordWidgetState extends State<AuthForgotPasswordWidget>
    with TickerProviderStateMixin {
  late AuthForgotPasswordModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthForgotPasswordModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: FlutterFlowTheme.of(context).primaryText),
        title: Text(
          'Recuperar Contraseña',
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(child: _buildForgotPasswordForm()),
    );
  }

  // ===========================================================================
  // 🔓 MODE 2: GUEST FORGOT PASSWORD
  // ===========================================================================
  Widget _buildForgotPasswordForm() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recuperar Contraseña',
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ingresa el correo electrónico asociado a tu cuenta y te enviaremos un enlace para restablecerla.',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 16),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: _cardDecoration,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _model.emailAddressTextController,
                      focusNode: _model.emailAddressFocusNode,
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primaryText),
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        labelStyle: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        prefixIcon: Icon(Icons.email_outlined,
                            color: FlutterFlowTheme.of(context).secondaryText),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_model.emailAddressTextController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Ingresa tu correo')));
                            return;
                          }
                          await getAuthManager(context).resetPassword(
                            email: _model.emailAddressTextController.text,
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Correo enviado. Revisa tu bandeja.')));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Enviar Enlace',
                          style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).tertiary),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- Helpers ---
  BoxDecoration get _cardDecoration => BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      );
}
