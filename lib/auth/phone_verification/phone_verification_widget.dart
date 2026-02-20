import '/auth/nazishop_auth/auth_util.dart';
import '/auth/nazishop_auth/nazishop_auth_provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'phone_verification_model.dart';
export 'phone_verification_model.dart';

class PhoneVerificationWidget extends StatefulWidget {
  const PhoneVerificationWidget({super.key});

  static String routeName = 'phone_verification';
  static String routePath = '/auth/verify-phone';

  @override
  State<PhoneVerificationWidget> createState() =>
      _PhoneVerificationWidgetState();
}

class _PhoneVerificationWidgetState extends State<PhoneVerificationWidget> {
  late PhoneVerificationModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _verificationId;
  bool _codeSent = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PhoneVerificationModel());

    _model.phoneTextController ??=
        TextEditingController(text: currentUserPhoneNumber);
    _model.phoneFocusNode ??= FocusNode();

    _model.pinCodeController ??= TextEditingController();
    _model.pinCodeFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final phone = _model.phoneTextController.text;
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un número de teléfono válido')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final authProvider =
        Provider.of<NaziShopAuthProvider>(context, listen: false);

    try {
      await authProvider.verifyPhone(
        phone,
        codeSent: (verificationId, resendToken) {
          if (mounted) {
            setState(() {
              _verificationId = verificationId;
              _codeSent = true;
              _isLoading = false;
            });
          }
        },
        verificationFailed: (e) {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.message}')),
            );
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {
          if (mounted) {
            setState(() => _verificationId = verificationId);
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _verifyCode() async {
    final code = _model.pinCodeController.text;
    if (code.length != 6 || _verificationId == null) {
      if (_verificationId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Error de verificación. Intenta reenviar el código.')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    final authProvider =
        Provider.of<NaziShopAuthProvider>(context, listen: false);

    try {
      await authProvider.confirmPhoneCode(_verificationId!, code, context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Teléfono verificado correctamente',
              style: TextStyle(color: FlutterFlowTheme.of(context).tertiary),
            ),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

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
            'Verificar Teléfono',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_codeSent) ...[
                  Text(
                    'Ingresa tu número de teléfono para recibir un código de verificación',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: theme.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _model.phoneTextController,
                    focusNode: _model.phoneFocusNode,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Número de Teléfono (+57...)',
                      labelStyle:
                          GoogleFonts.outfit(color: theme.secondaryText),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.alternate, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.primary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.secondaryBackground,
                    ),
                    style: GoogleFonts.outfit(color: theme.primaryText),
                  ),
                  const SizedBox(height: 32),
                  FFButtonWidget(
                    onPressed: _isLoading ? null : _sendCode,
                    text: _isLoading ? 'Enviando...' : 'Enviar Código',
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
                ] else ...[
                  Text(
                    'Ingresa el código de 6 dígitos enviado a ${_model.phoneTextController.text}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: theme.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Standard TextField instead of PinCodeTextField
                  TextFormField(
                    controller: _model.pinCodeController,
                    focusNode: _model.pinCodeFocusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 24,
                        letterSpacing: 2.0),
                    onChanged: (val) {
                      if (val.length == 6) _verifyCode();
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Código SMS',
                      labelStyle:
                          GoogleFonts.outfit(color: theme.secondaryText),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.alternate, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.primary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.secondaryBackground,
                    ),
                  ),

                  const SizedBox(height: 32),

                  FFButtonWidget(
                    onPressed: _isLoading ? null : _verifyCode,
                    text: _isLoading ? 'Verificando...' : 'Verificar Código',
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

                  TextButton(
                    onPressed: () => setState(() {
                      _codeSent = false;
                      _model.pinCodeController?.clear();
                    }),
                    child: Text(
                      'Cambiar número / Reenviar',
                      style: GoogleFonts.outfit(color: theme.primary),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
