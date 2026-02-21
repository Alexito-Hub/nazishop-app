import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Helper for displaying styled snackbars consistently across the app.
///
/// Usage:
/// ```dart
/// AppSnackbar.show(context, 'Mensaje de error',
///     backgroundColor: FlutterFlowTheme.of(context).error);
/// ```
class AppSnackbar {
  static void show(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    String? actionLabel,
    VoidCallback? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: theme.primaryBackground,
          ),
        ),
        backgroundColor: backgroundColor ?? theme.primaryText,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: duration,
        action: (actionLabel != null && action != null)
            ? SnackBarAction(
                label: actionLabel,
                textColor: theme.primaryBackground,
                onPressed: action,
              )
            : null,
      ),
    );
  }
}
