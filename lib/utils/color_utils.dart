import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class ColorUtils {
  static Color parseColor(BuildContext context, String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return FlutterFlowTheme.of(context).primary;
    }

    try {
      if (colorString.startsWith('#')) {
        return Color(
            int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      } else if (colorString.startsWith('0x')) {
        return Color(int.parse(colorString));
      } else if (colorString.length == 6) {
        return Color(int.parse(colorString, radix: 16) + 0xFF000000);
      } else if (colorString.length == 8) {
        return Color(int.parse(colorString, radix: 16));
      } else {
        return Color(int.parse(colorString, radix: 16) + 0xFF000000);
      }
    } catch (e) {
      return FlutterFlowTheme.of(context).primary;
    }
  }
}
