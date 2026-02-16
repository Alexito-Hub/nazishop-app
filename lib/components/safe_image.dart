import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Widget that safely loads network images with error handling
class SafeImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? fallbackColor;
  final IconData fallbackIcon;
  final double fallbackIconSize;

  const SafeImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackColor,
    this.fallbackIcon = Icons.image,
    this.fallbackIconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay URL, mostrar fallback
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallback(context);
    }

    return Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Silenciar el error y mostrar fallback
        return _buildFallback(context);
      },
    );
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: fallbackColor ?? FlutterFlowTheme.of(context).alternate,
      child: Icon(
        fallbackIcon,
        size: fallbackIconSize,
        color: FlutterFlowTheme.of(context).secondaryText,
      ),
    );
  }
}
