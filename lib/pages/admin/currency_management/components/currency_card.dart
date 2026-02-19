import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class CurrencyCard extends StatelessWidget {
  final String code;
  final String name;
  final String flag;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDesktop;

  const CurrencyCard({
    super.key,
    required this.code,
    required this.name,
    required this.flag,
    required this.controller,
    required this.focusNode,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            code,
                            style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            name,
                            style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isDesktop ? 24 : 16),
                Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .primaryBackground
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        '\$',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).success,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.00',
                            hintStyle: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'x 1 USD',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().moveY(begin: 10, end: 0, duration: 400.ms);
  }
}
