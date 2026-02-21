import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/auth/nazishop_auth/nazishop_auth_provider.dart';
import '/pages/error_page/error_page_widget.dart';
import '/auth/nazishop_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/loading_indicator.dart';

class AdminAuthGuard extends StatelessWidget {
  final Widget child;
  final String title;

  const AdminAuthGuard({
    super.key,
    required this.child,
    this.title = 'Panel de Administrador',
  });

  @override
  Widget build(BuildContext context) {
    // Access provider to get reactive updates
    final authProvider = Provider.of<NaziShopAuthProvider>(context);

    if (authProvider.isLoading) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: const Center(child: LoadingIndicator()),
      );
    }

    if (!loggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed('login');
        }
      });
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: LoadingIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      );
    }

    if (!(currentUser?.isAdmin ?? false)) {
      return const ErrorPageWidget(
        type: ErrorType.accessDenied,
      );
    }

    return child;
  }
}
