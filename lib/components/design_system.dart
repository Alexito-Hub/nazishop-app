import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/components/smart_back_button.dart';
import '/components/app_dialog.dart';

// ===========================================================================
// 🎨 DESIGN SYSTEM COMPONENTS
// ===========================================================================

/// A standardized button component supporting multiple variants.
class DSButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSecondary;
  final bool isOutline;
  final bool isDanger;
  final double? width;
  final double height;

  const DSButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSecondary = false,
    this.isOutline = false,
    this.isDanger = false,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? border;

    if (isOutline) {
      backgroundColor = Colors.transparent;
      foregroundColor = isDanger
          ? theme.error
          : (isSecondary ? theme.secondaryText : theme.primary);
      border = BorderSide(color: foregroundColor, width: 2);
    } else if (isSecondary) {
      backgroundColor = theme.secondaryBackground;
      foregroundColor = theme.primaryText;
      border = BorderSide(color: theme.alternate, width: 1);
    } else if (isDanger) {
      backgroundColor = theme.error;
      foregroundColor = theme.tertiary; // Use tertiary for contrast on danger
      border = null;
    } else {
      backgroundColor = theme.primary;
      foregroundColor = theme.tertiary; // Use tertiary for contrast on primary
      border = null;
    }

    // Disable state
    if (onPressed == null || isLoading) {
      backgroundColor = theme.alternate.withValues(alpha: 0.5);
      foregroundColor = theme.secondaryText.withValues(alpha: 0.8);
      border = null;
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: isOutline || isSecondary ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: border ?? BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foregroundColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      color: foregroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// A standardized card container with consistent styling.
class DSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const DSCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.alternate.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// A standardized input field with label and error state.
class DSInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const DSInput({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: GoogleFonts.outfit(
            color: theme.primaryText,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.outfit(
              color: theme.secondaryText,
              fontSize: 16,
            ),
            filled: true,
            fillColor: theme.secondaryBackground,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: theme.secondaryText, size: 20)
                : null,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.alternate,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.error,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A standardized badge for status indicators.
class DSBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final bool isOutlined;

  const DSBadge({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.isOutlined = false,
  });

  factory DSBadge.success(BuildContext context, {required String text}) {
    final theme = FlutterFlowTheme.of(context);
    return DSBadge(
      text: text,
      color: theme.success.withValues(alpha: 0.2),
      textColor: theme.success,
      isOutlined: true,
    );
  }

  factory DSBadge.error(BuildContext context, {required String text}) {
    final theme = FlutterFlowTheme.of(context);
    return DSBadge(
      text: text,
      color: theme.error.withValues(alpha: 0.2),
      textColor: theme.error,
      isOutlined: true,
    );
  }

  factory DSBadge.warning(BuildContext context, {required String text}) {
    final theme = FlutterFlowTheme.of(context);
    return DSBadge(
      text: text,
      color: theme.warning.withValues(alpha: 0.2),
      textColor: theme.warning,
      isOutlined: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bgColor = color ?? theme.primary.withValues(alpha: 0.2);
    final txtColor = textColor ?? theme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOutlined ? bgColor : (color ?? theme.primary),
        borderRadius: BorderRadius.circular(20),
        border: isOutlined
            ? Border.all(color: txtColor.withValues(alpha: 0.5))
            : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: isOutlined ? txtColor : (textColor ?? theme.tertiary),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ===========================================================================
// 🚀 ADMIN SHARED COMPONENTS
// ===========================================================================

/// Gradient FloatingActionButton used across all admin list pages on mobile.
/// Extracted from identical blocks in admin_categories, admin_services,
/// admin_listings, admin_promotions.
class DSGradientFab extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const DSGradientFab({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primary, theme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: theme.transparent,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(icon, color: theme.tertiary),
        label: Text(
          label,
          style: GoogleFonts.outfit(
            color: theme.tertiary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

/// Desktop page header row — title/subtitle on the left, gradient action button on the right.
/// Extracted from identical SliverToBoxAdapter > Row blocks in all admin list pages.
class DSAdminPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback onAction;

  const DSAdminPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                color: theme.primaryText,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                color: theme.secondaryText,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primary, theme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            icon: Icon(actionIcon, color: theme.tertiary, size: 20),
            label: Text(
              actionLabel,
              style: GoogleFonts.outfit(
                color: theme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Standard transparent mobile SliverAppBar with a circular SmartBackButton.
/// Extracted from identical SliverAppBar blocks in admin and user pages.
///
/// Must be used inside a [CustomScrollView].
class DSMobileAppBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const DSMobileAppBar({
    super.key,
    required this.title,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return SliverAppBar(
      backgroundColor: theme.transparent,
      surfaceTintColor: theme.transparent,
      pinned: true,
      floating: true,
      elevation: 0,
      leadingWidth: 70,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          shape: BoxShape.circle,
        ),
        child: SmartBackButton(color: theme.primaryText),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: GoogleFonts.outfit(
          color: theme.primaryText,
          fontWeight: FontWeight.w900,
          fontSize: 24,
          letterSpacing: 1.0,
        ),
      ),
      actions: actions,
    );
  }
}

/// Small square icon button used in admin entity cards (edit / delete / inventory).
/// Extracted from identical local `_buildIconButton` methods in CategoryCard,
/// AdminServicesWidget and AdminListingsWidget.
class DSIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;
  final double padding;

  const DSIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 18,
    this.padding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}

/// Standard delete confirmation dialog used across admin pages.
class DSDeleteConfirmDialog {
  static Future<bool> show(
    BuildContext context, {
    String title = 'Confirmar Eliminación',
    String message = '¿Estás seguro? Esta acción es irreversible.',
  }) async {
    return AppDialog.confirm(
      context,
      title: title,
      message: message,
      confirmLabel: 'Eliminar',
      isDanger: true,
      icon: Icons.delete_outline_rounded,
    );
  }
}
