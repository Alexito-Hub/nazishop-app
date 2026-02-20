import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// A standardized dialog component to ensure consistent layout across the app.
class AppDialog extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final String? message;
  final Widget? content;
  final List<Widget>? actions;
  final double maxWidth;
  final bool showCloseButton;
  final bool barrierDismissible;

  const AppDialog({
    super.key,
    this.icon,
    this.title,
    this.message,
    this.content,
    this.actions,
    this.maxWidth = 440,
    this.showCloseButton = false,
    this.barrierDismissible = true,
  });

  /// Helper to show a confirmation dialog.
  static Future<bool> confirm(
    BuildContext context, {
    String? title,
    required String message,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    bool isDanger = false,
    IconData? icon,
  }) async {
    final theme = FlutterFlowTheme.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        icon: icon != null
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (isDanger ? theme.error : theme.primary)
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDanger ? theme.error : theme.primary,
                  size: 32,
                ),
              )
            : null,
        title: title,
        message: message,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelLabel,
              style: GoogleFonts.outfit(color: theme.secondaryText),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDanger ? theme.error : theme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              confirmLabel,
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.alternate.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showCloseButton)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: theme.secondaryText),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              if (icon != null) ...[
                icon!,
                const SizedBox(height: 20),
              ],
              if (title != null) ...[
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (message != null) ...[
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: theme.secondaryText,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (content != null) ...[
                content!,
                if (actions != null) const SizedBox(height: 24),
              ],
              if (actions != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actions!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
