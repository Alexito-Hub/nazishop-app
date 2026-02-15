// SafeImage helper: respects local assets and an explicit remote-allow flag.
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SafeImage extends StatelessWidget {
  final String? src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool allowRemoteDownload;
  final Widget? placeholder;

  const SafeImage(
    this.src, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.allowRemoteDownload = false,
    this.placeholder,
  }) : super(key: key);

  Widget _defaultPlaceholder() => Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: Icon(
          Icons.image,
          color: Colors.grey.shade400,
        ),
      );

  bool _isAsset(String url) {
    return url.startsWith('assets/') ||
        url.startsWith('/') ||
        url.startsWith('file:');
  }

  @override
  Widget build(BuildContext context) {
    final url = src;
    if (url == null || url.isEmpty) return placeholder ?? _defaultPlaceholder();
    if (_isAsset(url)) {
      return Image.asset(
        url.replaceFirst(RegExp(r'^/'), ''),
        width: width,
        height: height,
        fit: fit,
      );
    }

    if (!allowRemoteDownload) {
      return placeholder ?? _defaultPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => placeholder ?? _defaultPlaceholder(),
      errorWidget: (_, __, ___) => placeholder ?? _defaultPlaceholder(),
    );
  }
}
