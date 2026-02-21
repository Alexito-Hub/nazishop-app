import '/auth/nazishop_auth/nazishop_auth_provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'set_password_model.dart';
export 'set_password_model.dart';

class SetPasswordWidget extends StatefulWidget {
  const SetPasswordWidget({super.key});

  static String routeName = 'set_password';
  static String routePath = '/auth/set-password';

  @override
  State<SetPasswordWidget> createState() => _SetPasswordWidgetState();
}

class _SetPasswordWidgetState extends State<SetPasswordWidget> {
  late SetPasswordModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SetPasswordModel());

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _model.confirmPasswordTextController ??= TextEditingController();
    _model.confirmPasswordFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
        appBar: AppBar(
          backgroundColor: theme.secondaryBackground,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: theme.primaryText,
              size: 30,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Establecer Contraseña',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontSize: 22,
            ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _model.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Crea una contraseña para acceder con tu correo',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: theme.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Password Input
                  TextFormField(
                    controller: _model.passwordTextController,
                    focusNode: _model.passwordFocusNode,
                    obscureText: !_model.passwordVisibility,
                    decoration: InputDecoration(
                      labelText: 'Nueva Contraseña',
                      labelStyle:
                          GoogleFonts.outfit(color: theme.secondaryText),
                      hintText: 'Mínimo 6 caracteres',
                      hintStyle: GoogleFonts.outfit(
                          color: theme.secondaryText.withValues(alpha: 0.5)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.alternate,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.error,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.error,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.secondaryBackground,
                      suffixIcon: InkWell(
                        onTap: () => setState(
                          () => _model.passwordVisibility =
                              !_model.passwordVisibility,
                        ),
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          _model.passwordVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: theme.secondaryText,
                          size: 22,
                        ),
                      ),
                    ),
                    style: GoogleFonts.outfit(color: theme.primaryText),
                    cursorColor: theme.primary,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Campo requerido';
                      }
                      if (val.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password Input
                  TextFormField(
                    controller: _model.confirmPasswordTextController,
                    focusNode: _model.confirmPasswordFocusNode,
                    obscureText: !_model.confirmPasswordVisibility,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      labelStyle:
                          GoogleFonts.outfit(color: theme.secondaryText),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.alternate,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.error,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.error,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.secondaryBackground,
                      suffixIcon: InkWell(
                        onTap: () => setState(
                          () => _model.confirmPasswordVisibility =
                              !_model.confirmPasswordVisibility,
                        ),
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          _model.confirmPasswordVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: theme.secondaryText,
                          size: 22,
                        ),
                      ),
                    ),
                    style: GoogleFonts.outfit(color: theme.primaryText),
                    cursorColor: theme.primary,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Campo requerido';
                      }
                      if (val != _model.passwordTextController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  FFButtonWidget(
                    onPressed: () async {
                      if (_model.formKey.currentState == null ||
                          !_model.formKey.currentState!.validate()) {
                        return;
                      }

                      try {
                        await authProvider
                            .setPassword(_model.passwordTextController.text);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Contraseña establecida correctamente',
                                style: TextStyle(color: theme.tertiary),
                              ),
                              backgroundColor: theme.success,
                            ),
                          );
                          context.pop();
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
                      }
                    },
                    text: 'Guardar Contraseña',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
