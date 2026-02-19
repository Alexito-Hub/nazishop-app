import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ConfigTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;

  const ConfigTextField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: theme.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.outfit(color: theme.primaryText),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.primaryBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.alternate),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class ConfigSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const ConfigSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: GoogleFonts.outfit(
            color: theme.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        activeThumbColor: theme.primary,
        activeTrackColor: theme.primary.withValues(alpha: 0.3),
        inactiveThumbColor: theme.secondaryText,
        inactiveTrackColor: theme.secondaryText.withValues(alpha: 0.3),
      ),
    );
  }
}
