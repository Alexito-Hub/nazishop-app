import '/auth/nazishop_auth/auth_util.dart';
import '/auth/nazishop_auth/nazishop_auth_provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'email_verification_model.dart';
export 'email_verification_model.dart';

class EmailVerificationWidget extends StatefulWidget {
  const EmailVerificationWidget({super.key});

  static String routeName = 'email_verification';
  static String routePath = '/auth/verify-email';

  @override
  State<EmailVerificationWidget> createState() =>
      _EmailVerificationWidgetState();
}

class _EmailVerificationWidgetState extends State<EmailVerificationWidget> {
  late EmailVerificationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isResending = false;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmailVerificationModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 60);
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || _resendCooldown <= 0) return false;
      setState(() => _resendCooldown--);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final authProvider = Provider.of<NaziShopAuthProvider>(context);

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.mark_email_unread_outlined,
                  size: 80,
                  color: theme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Verifica tu correo',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hemos enviado un correo de verificación a:\n${currentUserEmail}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: theme.secondaryText,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),

                // Botón "Ya lo verifiqué"
                FFButtonWidget(
                  onPressed: () async {
                    await authProvider.refreshEmailVerified();
                    if (authProvider.currentUser?.emailVerified == true) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '¡Correo verificado correctamente!',
                              style: TextStyle(color: theme.tertiary),
                            ),
                            backgroundColor: theme.success,
                          ),
                        );
                        // Redirigir a completar perfil o home
                        // Si es registro nuevo, complete_profile. Si es login, home.
                        // Asumimos complete_profile por defecto si viene de registro,
                        // pero router se encargará.
                        if (Navigator.canPop(context)) {
                          context.pop();
                        } else {
                          context.goNamed('home');
                        }
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Aún no hemos detectado la verificación. Revisa tu correo.',
                            ),
                            backgroundColor: theme.error,
                          ),
                        );
                      }
                    }
                  },
                  text: 'Ya verifiqué mi correo',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50,
                    color: theme.primary,
                    textStyle: GoogleFonts.outfit(
                      color: theme.tertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    elevation: 0,
                  ),
                ),

                const SizedBox(height: 16),

                // Botón Reenviar
                TextButton(
                  onPressed: (_isResending || _resendCooldown > 0)
                      ? null
                      : () async {
                          setState(() => _isResending = true);
                          try {
                            await authProvider.sendEmailVerification();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Correo reenviado exitosamente',
                                    style: TextStyle(color: theme.tertiary),
                                  ),
                                  backgroundColor: theme.success,
                                ),
                              );
                              _startCooldown();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: theme.error,
                                ),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _isResending = false);
                          }
                        },
                  child: Text(
                    _resendCooldown > 0
                        ? 'Reenviar en ${_resendCooldown}s'
                        : 'Reenviar correo de verificación',
                    style: GoogleFonts.outfit(
                      color: (_isResending || _resendCooldown > 0)
                          ? theme.secondaryText
                          : theme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                TextButton(
                  onPressed: () async {
                    await authProvider.logout();
                    if (context.mounted) {
                      context.goNamed('login');
                    }
                  },
                  child: Text(
                    'Cerrar Sesión / Cancelar',
                    style: GoogleFonts.outfit(
                      color: theme.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
