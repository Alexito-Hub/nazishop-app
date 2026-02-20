import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

typedef AppCardBuilder = Widget Function(
    BuildContext context, bool isHovered, Widget? child);

class AppCard extends StatelessWidget {
  final Widget? child;
  final AppCardBuilder? builder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? hoverBorderColor;
  final Color? hoverShadowColor;
  final bool hoverEffect;
  final double hoverOffset;

  const AppCard({
    super.key,
    this.child,
    this.builder,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = 24.0,
    this.backgroundColor,
    this.borderColor,
    this.hoverBorderColor,
    this.hoverShadowColor,
    this.hoverEffect = false,
    this.hoverOffset = -5.0,
  }) : assert(child != null || builder != null);

  @override
  Widget build(BuildContext context) {
    if (hoverEffect) {
      return _HoverableCard(
        onTap: onTap,
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        hoverBorderColor: hoverBorderColor,
        hoverShadowColor: hoverShadowColor,
        hoverOffset: hoverOffset,
        builder: builder,
        child: child,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding ?? const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: backgroundColor ??
              FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: builder != null ? builder!(context, false, child) : child,
      ),
    );
  }
}

class _HoverableCard extends StatefulWidget {
  final Widget? child;
  final AppCardBuilder? builder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? hoverBorderColor;
  final Color? hoverShadowColor;
  final double hoverOffset;

  const _HoverableCard({
    this.child,
    this.builder,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = 24.0,
    this.backgroundColor,
    this.borderColor,
    this.hoverBorderColor,
    this.hoverShadowColor,
    required this.hoverOffset,
  });

  @override
  State<_HoverableCard> createState() => _HoverableCardState();
}

class _HoverableCardState extends State<_HoverableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: widget.margin,
          padding: widget.padding ?? const EdgeInsets.all(24),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? widget.hoverOffset : 0.0, 0.0),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? theme.secondaryBackground,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isHovered
                  ? (widget.hoverBorderColor ?? theme.primary)
                  : (widget.borderColor ?? theme.alternate),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.hoverShadowColor ??
                          theme.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
          ),
          clipBehavior: Clip.antiAlias,
          child: widget.builder != null
              ? widget.builder!(context, _isHovered, widget.child)
              : widget.child,
        ),
      ),
    );
  }
}
