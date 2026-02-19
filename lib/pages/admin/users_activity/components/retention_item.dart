import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class RetentionItem extends StatelessWidget {
  final String label;
  final String value;

  const RetentionItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Simple bar visual
    final double percentage = double.tryParse(value.replaceAll('%', '')) ?? 0.0;

    // Approximate width based on context constraints. Maximum width is arbitrary here
    // as it will be constrained by parent. Let's assume max width of 200 for calculation.

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context)
                      .secondaryText
                      .withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
