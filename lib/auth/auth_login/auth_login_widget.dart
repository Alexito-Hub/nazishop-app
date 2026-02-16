import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // [IMPORTANTE] Necesario para TextInput
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'auth_login_model.dart';
export 'auth_login_model.dart';

class AuthLoginWidget extends StatefulWidget {
  const AuthLoginWidget({super.key});

  static String routeName = 'login';
  static String routePath = '/auth/login';

  @override
  State<AuthLoginWidget> createState() => _AuthLoginWidgetState();
}

class _AuthLoginWidgetState extends State<AuthLoginWidget>
    with TickerProviderStateMixin {
  late AuthLoginModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthLoginModel());
    getAuthManager(context); // Initialize auth manager if needed

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 140.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: Stack(
          children: [
            // Background Elements
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primaryBackground, theme.secondaryBackground],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primary.withValues(alpha: 0.1),
                ),
              ).animate().fadeIn(duration: 1000.ms),
            ),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Text(
                        'Nazi Shop',
                        style: GoogleFonts.outfit(
                            color: theme.primary,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0),
                      ),
                      const SizedBox(height: 40),

                      // Login Card
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: theme.alternate),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        // [MEJORA 1] AutofillGroup para agrupar las credenciales
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Bienvenido',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  color: theme.primaryText,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ingresa tus credenciales para continuar',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  color: theme.secondaryText,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Inputs
                              _buildInput(
                                controller: _model.emailAddressTextController,
                                focusNode: _model.emailAddressFocusNode,
                                hint: 'Correo Electrónico',
                                icon: Icons.email_outlined,
                                // [MEJORA 2] Hints para email y acción "Siguiente"
                                autofillHints: const [AutofillHints.email],
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),
                              _buildInput(
                                controller: _model.passwordTextController,
                                focusNode: _model.passwordFocusNode,
                                hint: 'Contraseña',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                // [MEJORA 3] Hint para contraseña existente
                                autofillHints: const [AutofillHints.password],
                                textInputAction: TextInputAction.done,
                              ),

                              const SizedBox(height: 24),

                              // Button
                              FFButtonWidget(
                                onPressed: () async {
                                  // [MEJORA 4] Forzar cierre de contexto para guardar/actualizar contraseña
                                  TextInput.finishAutofillContext();

                                  final authProvider =
                                      Provider.of<NaziShopAuthProvider>(context,
                                          listen: false);
                                  await authProvider.login(
                                    email:
                                        _model.emailAddressTextController.text,
                                    password:
                                        _model.passwordTextController.text,
                                  );

                                  if (!context.mounted) return;

                                  if (authProvider.isLoggedIn) {
                                    updateCurrentUser(context);
                                    context.goNamed('home');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            authProvider.errorMessage ??
                                                'Error al iniciar sesión'),
                                        backgroundColor: theme.error,
                                      ),
                                    );
                                  }
                                },
                                text: 'Iniciar Sesión',
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

                              const SizedBox(height: 20),
                              // Google Auth
                              OutlinedButton.icon(
                                onPressed: () async {
                                  final user = await authManager
                                      .signInWithGoogle(context);
                                  if (user == null || !context.mounted) return;
                                  context.goNamedAuth('home', context.mounted);
                                },
                                icon: FaIcon(FontAwesomeIcons.google,
                                    size: 18, color: theme.primaryText),
                                label: Text('Continuar con Google',
                                    style: GoogleFonts.outfit(
                                        color: theme.primaryText)),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: theme.alternate),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().scale(delay: 200.ms, duration: 400.ms),

                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("¿No tienes cuenta?",
                              style: GoogleFonts.outfit(
                                  color: theme.secondaryText)),
                          TextButton(
                            onPressed: () => context.pushNamed('register'),
                            child: Text(
                              'Regístrate',
                              style: GoogleFonts.outfit(
                                color: theme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [Helper Optimizado] Acepta autofillHints y textInputAction
  Widget _buildInput({
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    Iterable<String>? autofillHints,
    TextInputAction? textInputAction,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofillHints: autofillHints, // Pasar hints
      textInputAction: textInputAction, // Pasar acción de teclado
      obscureText: isPassword && !_model.passwordVisibility,
      style: GoogleFonts.outfit(color: theme.primaryText),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: theme.secondaryText),
        prefixIcon:
            Icon(icon, color: theme.secondaryText.withValues(alpha: 0.5)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _model.passwordVisibility
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: theme.secondaryText.withValues(alpha: 0.5),
                ),
                onPressed: () => safeSetState(() =>
                    _model.passwordVisibility = !_model.passwordVisibility),
              )
            : null,
        filled: true,
        fillColor: theme.primaryBackground,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.alternate)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.primary)),
      ),
    );
  }
}
