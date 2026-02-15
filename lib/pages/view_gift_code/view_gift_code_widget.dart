import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view_gift_code_model.dart';
import '../../components/smart_back_button.dart';
export 'view_gift_code_model.dart';

class ViewGiftCodeWidget extends StatefulWidget {
  const ViewGiftCodeWidget({
    super.key,
    required this.serviceName,
    required this.code,
    this.expiryDate,
    this.instructions,
  });

  final String serviceName;
  final String code;
  final String? expiryDate;
  final String? instructions;

  static String routeName = 'view_gift_code';
  static String routePath = '/viewGiftCode';

  @override
  State<ViewGiftCodeWidget> createState() => _ViewGiftCodeWidgetState();
}

class _ViewGiftCodeWidgetState extends State<ViewGiftCodeWidget> {
  late ViewGiftCodeModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewGiftCodeModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('¡Código copiado!'),
        backgroundColor: FlutterFlowTheme.of(context).success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

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
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: false,
                leading: SmartBackButton(
                    color: FlutterFlowTheme.of(context).primaryText),
                title: Text(
                  'Tu Código',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 22.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                centerTitle: true,
                elevation: 2.0,
              ),
        body: SafeArea(
          top: true,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 800 : double.infinity,
              ),
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 48.0 : 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isDesktop) ...[
                      Row(
                        children: [
                          SmartBackButton(
                              color: FlutterFlowTheme.of(context).primaryText),
                          const SizedBox(width: 16.0),
                          Text(
                            'Tu Código de Regalo',
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  font: GoogleFonts.inter(),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32.0),
                    ],
                    // Product Header
                    Text(
                      widget.serviceName,
                      textAlign: TextAlign.center,
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.outfit(),
                                fontWeight: FontWeight.bold,
                                fontSize: isDesktop ? 32.0 : null,
                              ),
                    ),
                    SizedBox(height: isDesktop ? 40.0 : 32.0),

                    // Code Display Area
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isDesktop ? 32.0 : 24.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius:
                            BorderRadius.circular(isDesktop ? 20.0 : 16.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primary,
                          width: isDesktop ? 3.0 : 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.1),
                            blurRadius: isDesktop ? 20.0 : 10.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'CÓDIGO DE REGALO',
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  font: GoogleFonts.inter(),
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isDesktop ? 14.0 : null,
                                ),
                          ),
                          SizedBox(height: isDesktop ? 24.0 : 16.0),
                          SelectableText(
                            widget.code,
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  font: GoogleFonts.robotoMono(),
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isDesktop ? 40 : 32,
                                ),
                          ),
                          SizedBox(height: isDesktop ? 32.0 : 24.0),
                          FFButtonWidget(
                            onPressed: _copyToClipboard,
                            text: 'Copiar Código',
                            icon: const Icon(Icons.copy, size: 20),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50.0,
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32.0),

                    // Instructions
                    if (widget.instructions != null &&
                        widget.instructions!.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Instrucciones:',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.inter(),
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .accent1
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          widget.instructions!,
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Footer
                    Text(
                      'Si tienes problemas con tu código, contacta a soporte.',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
