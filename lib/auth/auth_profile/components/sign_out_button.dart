import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class SignOutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignOutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: onPressed,
      text: 'Cerrar sesión',
      options: FFButtonOptions(
        width: 150.0,
        height: 44.0,
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        color: FlutterFlowTheme.of(context).primaryBackground,
        textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
              font: GoogleFonts.inter(
                fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
              ),
            ),
        elevation: 0.0,
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
