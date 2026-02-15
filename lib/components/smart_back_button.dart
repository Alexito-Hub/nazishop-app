import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/app_routes.dart';

/// Smart back button with intelligent fallback navigation.
///
/// Attempts to pop the navigation stack. When not possible (e.g., deep links),
/// navigates to a contextual fallback: admin dashboard for `/admin/*` routes,
/// user profile for `/user/*` routes, or home for other routes.
class SmartBackButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onCustomPop;
  final bool useIcon;

  const SmartBackButton({
    super.key,
    this.color,
    this.onCustomPop,
    this.useIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: color ?? FlutterFlowTheme.of(context).primaryText,
      ),
      onPressed: () {
        if (onCustomPop != null) {
          onCustomPop!();
          return;
        }

        if (context.canPop()) {
          context.pop();
          return;
        }

        // Fallback navigation based on current route
        final location = GoRouterState.of(context).uri.toString();

        if (location.startsWith('/admin')) {
          context.goNamed(location != AppRoutes.admin ? 'admin' : 'home');
        } else if (location.startsWith('/user')) {
          context.goNamed('profile');
        } else {
          context.goNamed('home');
        }
      },
    );
  }
}
