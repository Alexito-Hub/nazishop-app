import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Widget that safely loads network images with robust error handling and loading states.
/// Handles:
/// 1. Loading State: Shows a shimmer effect or centered spinner (or custom widget).
/// 2. Success State: Shows the image with correct fit.
/// 3. Error State: Shows a fallback icon/color matching the design system (or custom widget).
class SafeImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? fallbackColor;
  final IconData fallbackIcon;
  final double fallbackIconSize;
  final bool showLoadingIndicator;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const SafeImage(
    this.imageUrl, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackColor,
    this.fallbackIcon = Icons.image_not_supported_rounded,
    this.fallbackIconSize = 24,
    this.showLoadingIndicator = true,
    this.loadingWidget,
    this.errorWidget,
    // Legacy params kept for compatibility but handled internally or ignored
    @Deprecated('Use constructor directly') dynamic allowRemoteDownload,
    @Deprecated('Use loadingWidget or errorWidget') dynamic placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return errorWidget ?? _buildFallback(context);
    }

    return SizedBox(
      width: width,
      height: height,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: fit,
        width: width,
        height: height,
        fadeInDuration: 200.ms,
        fadeOutDuration: 200.ms,
        placeholder: (context, url) => loadingWidget ?? _buildLoading(context),
        errorWidget: (context, url, error) =>
            errorWidget ?? _buildFallback(context),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    if (!showLoadingIndicator) {
      return Container(
        width: width,
        height: height,
        color: FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.3),
      );
    }

    return Container(
      width: width,
      height: height,
      color: FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.3),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              FlutterFlowTheme.of(context).primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: fallbackColor ??
          FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.5),
      child: Center(
        child: Icon(
          fallbackIcon,
          size: fallbackIconSize,
          color: FlutterFlowTheme.of(context).secondaryText,
        ),
      ),
    );
  }
}
