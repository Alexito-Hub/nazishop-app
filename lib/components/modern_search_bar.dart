import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ModernSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const ModernSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color:
                FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 14 * FlutterFlowTheme.fontSizeFactor),
        decoration: InputDecoration(
          hintText: 'Buscar servicios...',
          hintStyle: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14 * FlutterFlowTheme.fontSizeFactor),
          prefixIcon: Icon(Icons.search,
              color: FlutterFlowTheme.of(context).secondaryText),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}
