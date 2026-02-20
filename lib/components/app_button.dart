import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

enum AppButtonType {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool loading;
  final double? width;
  final double height;
  final double borderRadius;
  final bool expand;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.loading = false,
    this.width,
    this.height = 54.0,
    this.borderRadius = 16.0,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Determine styles based on type
    Color color;
    Color textColor;
    Color? borderColor;
    double borderWidth = 0;

    switch (type) {
      case AppButtonType.primary:
        color = theme.primary;
        textColor = theme.tertiary;
        break;
      case AppButtonType.secondary:
        color = theme.secondary;
        textColor = theme.tertiary;
        break;
      case AppButtonType.outline:
        color = Colors.transparent;
        textColor = theme.primaryText;
        borderColor = theme.alternate;
        borderWidth = 1.0;
        break;
      case AppButtonType.ghost:
        color = Colors.transparent;
        textColor = theme.primary;
        break;
      case AppButtonType.destructive:
        color = theme.error;
        textColor = theme.tertiary;
        break;
    }

    return FFButtonWidget(
      onPressed: onPressed,
      text: text,
      icon: icon != null ? Icon(icon, color: textColor, size: 20) : null,
      options: FFButtonOptions(
        width: expand ? double.infinity : width,
        height: height,
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        color: color,
        textStyle: theme.titleSmall.override(
          fontFamily: 'Inter Tight',
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        elevation: type == AppButtonType.ghost || type == AppButtonType.outline
            ? 0
            : 2,
        borderSide: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        hoverColor: type == AppButtonType.outline
            ? theme.alternate.withValues(alpha: 0.1)
            : null,
      ),
      showLoadingIndicator: true,
    );
  }
}
