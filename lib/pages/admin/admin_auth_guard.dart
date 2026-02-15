import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/auth/nazishop_auth/nazishop_auth_provider.dart';
import '/auth/nazishop_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

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
        body: Center(
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
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
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      );
    }

    if (!(currentUser?.isAdmin ?? false)) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .error
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_person_rounded,
                      size: 80.0,
                      color: FlutterFlowTheme.of(context).error,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Text(
                    'SÓLO PERSONAL AUTORIZADO',
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).error,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'Acceso Denegado',
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'No tienes los permisos necesarios para acceder a las herramientas administrativas de Nazi Shop.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 48.0),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      foregroundColor: FlutterFlowTheme.of(context).primaryText,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate),
                      ),
                    ),
                    child: Text(
                      'Regresar',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return child;
  }
}
