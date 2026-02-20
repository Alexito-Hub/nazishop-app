import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final bool isFullScreen;

  const LoadingIndicator({
    super.key,
    this.size = 40.0,
    this.color,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final spinner = Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? FlutterFlowTheme.of(context).primary,
          ),
          strokeWidth: 3.0,
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);

    if (isFullScreen) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: FlutterFlowTheme.of(context)
            .primaryBackground
            .withValues(alpha: 0.8),
        child: spinner,
      );
    }

    return spinner;
  }
}
