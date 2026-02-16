import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class SecurityCheckDialog extends StatefulWidget {
  const SecurityCheckDialog({super.key});

  @override
  State<SecurityCheckDialog> createState() => _SecurityCheckDialogState();
}

class _SecurityCheckDialogState extends State<SecurityCheckDialog> {
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isLoading = false;
  bool _codeSent = false;
  bool _hasError = false;
  String _message = 'Iniciando verificación de seguridad...';

  @override
  void initState() {
    super.initState();
    // Start the process automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendCode();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _message = 'Enviando código de seguridad a tu correo...';
      _hasError = false;
    });

    try {
      await AdminService.sendSecurityOtp();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _codeSent = true;
          _message = 'Ingresa el código de 6 dígitos enviado a tu correo.';
          // Request focus slightly delayed to ensure UI is ready
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) _focusNode.requestFocus();
          });
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _message = 'Error al enviar código. Verifica tu conexión.';
        });
      }
    }
  }

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();
    if (code.length != 6) return;

    setState(() {
      _isLoading = true;
      _message = 'Verificando...';
      _hasError = false;
    });

    try {
      final success = await AdminService.verifySecurityOtp(code);

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true); // Success
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _message = 'Código inválido o expirado.';
          _codeController.clear();
          _focusNode.requestFocus();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _message = 'Error de conexión al verificar.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final dialogWidth = isMobile ? 320.0 : 400.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: dialogWidth,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hasError
                ? FlutterFlowTheme.of(context).error.withValues(alpha: 0.5)
                : FlutterFlowTheme.of(context).primaryText.withValues(alpha: 0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_person_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 32,
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 20),

            // Title
            Text(
              'Verificación de Identidad',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 12),

            // Message
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _message,
                key: ValueKey(_message),
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: _hasError
                      ? FlutterFlowTheme.of(context).error
                      : FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Main Content Area
            if (_isLoading)
              SizedBox(
                height: 60,
                child: Center(
                  child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                    strokeWidth: 3,
                  ),
                ),
              )
            else if (_codeSent)
              _buildPinCodeInput(isMobile)
            else
              // Retry / Error View Button
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton.icon(
                  onPressed: _sendCode,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text('Reenviar Código', style: GoogleFonts.outfit()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context)
                        .primaryBackground
                        .withValues(alpha: 0.1),
                    foregroundColor: FlutterFlowTheme.of(context).primaryText,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

            // Actions for Verify
            if (!_isLoading && _codeSent) ...[
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _codeController.text.length == 6 ? _verifyCode : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        disabledBackgroundColor: FlutterFlowTheme.of(context)
                            .primary
                            .withValues(alpha: 0.3),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Verificar',
                        style: GoogleFonts.outfit(
                          color: _codeController.text.length == 6
                              ? FlutterFlowTheme.of(context).info
                              : FlutterFlowTheme.of(context)
                                  .secondaryText
                                  .withValues(alpha: 0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Actions for Loading / Error only cancel
            if (!_codeSent && !_isLoading) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cerrar',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context)
                          .secondaryText
                          .withValues(alpha: 0.5)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPinCodeInput(bool isMobile) {
    // Calculate box size dynamically based on available width
    // total width = (boxSize * 6) + (spacing * 5)
    // Mobile approx 280px available content width

    // Adaptive size
    final double boxSize = isMobile ? 38.0 : 45.0;
    final double spacing = isMobile ? 6.0 : 10.0;

    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Visual Boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              final code = _codeController.text;
              final char = code.length > index ? code[index] : '';
              final isFocused =
                  code.length == index || (index == 5 && code.length == 6);

              return Container(
                width: boxSize,
                height: boxSize * 1.25,
                margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isFocused
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context)
                            .primaryText
                            .withValues(alpha: 0.1),
                    width: isFocused ? 2 : 1,
                  ),
                  boxShadow: isFocused
                      ? [
                          BoxShadow(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withValues(alpha: 0.2),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
                child: Text(
                  char,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ),

          // Invisible Input Field
          Positioned.fill(
            child: Opacity(
              opacity: 0, // Make strictly invisible but interactive
              child: TextField(
                controller: _codeController,
                focusNode: _focusNode,
                maxLength: 6,
                autofocus: true,
                keyboardType: TextInputType.number,

                // Important for mobile verification SMS code autofill
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                onChanged: (val) {
                  setState(() {}); // Rebuild UI
                  if (val.length == 6) {
                    _verifyCode();
                  }
                },
                decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).moveY(begin: 10, end: 0),
    );
  }
}
