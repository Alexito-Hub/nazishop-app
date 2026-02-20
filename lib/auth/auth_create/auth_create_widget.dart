import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_create_model.dart';
export 'auth_create_model.dart';

class AuthCreateWidget extends StatefulWidget {
  const AuthCreateWidget({super.key});

  static String routeName = 'register';
  static String routePath = '/auth/create';

  @override
  State<AuthCreateWidget> createState() => _AuthCreateWidgetState();
}

class _AuthCreateWidgetState extends State<AuthCreateWidget>
    with TickerProviderStateMixin {
  late AuthCreateModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthCreateModel());

    _model.fullNameTextController ??= TextEditingController();
    _model.fullNameFocusNode ??= FocusNode();

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _model.confirmPasswordTextController ??= TextEditingController();
    _model.confirmPasswordFocusNode ??= FocusNode();

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
                  child: SingleChildScrollView(
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

                        // Register Card
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
                          child: AutofillGroup(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Crea tu cuenta',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    color: theme.primaryText,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Completa el formulario para comenzar',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    color: theme.secondaryText,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Inputs
                                _buildInput(
                                  controller: _model.fullNameTextController,
                                  focusNode: _model.fullNameFocusNode,
                                  hint: 'Nombre Completo',
                                  icon: Icons.person_outline,
                                  autofillHints: const [AutofillHints.name],
                                  textInputAction: TextInputAction.next,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'El nombre es requerido';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildInput(
                                  controller: _model.emailAddressTextController,
                                  focusNode: _model.emailAddressFocusNode,
                                  hint: 'Correo Electrónico',
                                  icon: Icons.email_outlined,
                                  autofillHints: const [AutofillHints.email],
                                  textInputAction: TextInputAction.next,
                                  validator: _model
                                      .emailAddressTextControllerValidator
                                      .asValidator(context),
                                ),
                                const SizedBox(height: 16),
                                _buildInput(
                                  controller: _model.passwordTextController,
                                  focusNode: _model.passwordFocusNode,
                                  hint: 'Contraseña',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  passwordVisibility: _model.passwordVisibility,
                                  onVisibilityChange: () => safeSetState(() =>
                                      _model.passwordVisibility =
                                          !_model.passwordVisibility),
                                  autofillHints: const [
                                    AutofillHints.newPassword
                                  ],
                                  textInputAction: TextInputAction.next,
                                  validator: _model
                                      .passwordTextControllerValidator
                                      .asValidator(context),
                                ),
                                const SizedBox(height: 16),
                                _buildInput(
                                  controller:
                                      _model.confirmPasswordTextController,
                                  focusNode: _model.confirmPasswordFocusNode,
                                  hint: 'Confirmar Contraseña',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  passwordVisibility:
                                      _model.confirmPasswordVisibility,
                                  onVisibilityChange: () => safeSetState(() =>
                                      _model.confirmPasswordVisibility =
                                          !_model.confirmPasswordVisibility),
                                  autofillHints: const [
                                    AutofillHints.newPassword
                                  ],
                                  textInputAction: TextInputAction.done,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Campo requerido';
                                    }
                                    if (val !=
                                        _model.passwordTextController.text) {
                                      return 'Las contraseñas no coinciden';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Button
                                FFButtonWidget(
                                  onPressed: () async {
                                    TextInput.finishAutofillContext();

                                    // Validations
                                    if (_model
                                        .fullNameTextController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'El nombre completo es requerido')),
                                      );
                                      return;
                                    }

                                    if (_model.emailAddressTextController.text
                                        .isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'El correo electrónico es requerido')),
                                      );
                                      return;
                                    }

                                    if (_model
                                        .passwordTextController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'La contraseña es requerida')),
                                      );
                                      return;
                                    }

                                    if (_model.passwordTextController.text
                                            .length <
                                        6) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'La contraseña debe tener al menos 6 caracteres')),
                                      );
                                      return;
                                    }

                                    if (_model.confirmPasswordTextController
                                            .text !=
                                        _model.passwordTextController.text) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Las contraseñas no coinciden')),
                                      );
                                      return;
                                    }

                                    updateCurrentUser(context);

                                    final user = await getAuthManager(context)
                                        .createAccountWithEmail(
                                      context,
                                      _model.emailAddressTextController.text,
                                      _model.passwordTextController.text,
                                      displayName:
                                          _model.fullNameTextController.text,
                                    );

                                    if (!context.mounted) return;

                                    if (user != null) {
                                      context.goNamed('email_verification');
                                    } else {
                                      // Error handled by AuthManager or show generic
                                    }
                                  },
                                  text: 'Crear Cuenta',
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
                                    final result = await getAuthManager(context)
                                        .signInWithGoogle(context);
                                    final user = result['user'];
                                    final isNewUser =
                                        result['isNewUser'] ?? false;

                                    if (user == null || !context.mounted) {
                                      return;
                                    }

                                    if (isNewUser) {
                                      context.goNamed('complete_profile');
                                    } else {
                                      context.goNamedAuth(
                                          'home', context.mounted);
                                    }
                                  },
                                  icon: FaIcon(FontAwesomeIcons.google,
                                      size: 18, color: theme.primaryText),
                                  label: Text('Registrarse con Google',
                                      style: GoogleFonts.outfit(
                                          color: theme.primaryText)),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: theme.alternate),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
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
                            Text("¿Ya tienes cuenta?",
                                style: GoogleFonts.outfit(
                                    color: theme.secondaryText)),
                            TextButton(
                              onPressed: () => context.pushNamed('login'),
                              child: Text(
                                'Inicia Sesión',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool passwordVisibility = false,
    VoidCallback? onVisibilityChange,
    Iterable<String>? autofillHints,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      obscureText: isPassword && !passwordVisibility,
      validator: validator,
      style: GoogleFonts.outfit(color: theme.primaryText),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: theme.secondaryText),
        prefixIcon:
            Icon(icon, color: theme.secondaryText.withValues(alpha: 0.5)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  passwordVisibility ? Icons.visibility : Icons.visibility_off,
                  color: theme.secondaryText.withValues(alpha: 0.5),
                ),
                onPressed: onVisibilityChange,
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
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.error)),
      ),
    );
  }
}
