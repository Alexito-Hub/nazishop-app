import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class CheckoutTerms extends StatelessWidget {
  final bool accepted;
  final Function(bool) onChanged;
  final Color activeColor;

  const CheckoutTerms({
    super.key,
    required this.accepted,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
          child: Checkbox(
            value: accepted,
            onChanged: (value) => onChanged(value ?? false),
            activeColor: activeColor,
          ),
        ),
        Expanded(
          child: Text(
            'Acepto los términos y condiciones de compra.',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 14 * FlutterFlowTheme.fontSizeFactor),
          ),
        ),
      ],
    );
  }
}
