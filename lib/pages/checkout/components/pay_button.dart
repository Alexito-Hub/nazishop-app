import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class PayButton extends StatelessWidget {
  final bool isProcessing;
  final VoidCallback? onPressed;
  final Color color;

  const PayButton({
    super.key,
    required this.isProcessing,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isProcessing ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withValues(alpha: 0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: color.withValues(alpha: 0.4),
        ),
        child: isProcessing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Text('Confirmar y Pagar',
                style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
                    fontWeight: FontWeight.bold)),
      ),
    );
  }
}
