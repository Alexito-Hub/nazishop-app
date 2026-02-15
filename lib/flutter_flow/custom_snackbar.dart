import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'flutter_flow_theme.dart';

class CustomSnackBar {
  static void _show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    String? title,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor ?? theme.primaryText),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(title,
                      style: GoogleFonts.inter(
                          color: textColor ?? theme.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                Text(
                  message,
                  style: GoogleFonts.inter(
                    color: textColor ?? theme.primaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? theme.secondaryBackground,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void success(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3), String? title}) {
    final theme = FlutterFlowTheme.of(context);
    _show(context, message,
        duration: duration,
        backgroundColor: theme.primary,
        textColor: theme.tertiary,
        icon: Icons.check_circle_outline,
        title: title);
  }

  static void warning(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3), String? title}) {
    final theme = FlutterFlowTheme.of(context);
    _show(context, message,
        duration: duration,
        backgroundColor: theme.warning,
        textColor: theme.tertiary,
        icon: Icons.warning_amber_outlined,
        title: title);
  }

  static void error(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3), String? title}) {
    final theme = FlutterFlowTheme.of(context);
    _show(context, message,
        duration: duration,
        backgroundColor: theme.error,
        textColor: theme.tertiary,
        icon: Icons.error_outline,
        title: title);
  }
}

// Backwards-compatible alias (some files referenced the previous name)
class CustomSnackbar {
  static void show(BuildContext context, String message,
          {Duration duration = const Duration(seconds: 3),
          Color? backgroundColor,
          Color? textColor,
          IconData? icon}) =>
      CustomSnackBar._show(context, message,
          duration: duration,
          backgroundColor: backgroundColor,
          textColor: textColor,
          icon: icon);
}
