import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/auth/nazishop_auth/nazishop_auth_provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/loading_indicator.dart';

class SuperAdminAuthGuard extends StatefulWidget {
  final Widget child;

  const SuperAdminAuthGuard({
    super.key,
    required this.child,
  });

  @override
  State<SuperAdminAuthGuard> createState() => _SuperAdminAuthGuardState();
}

class _SuperAdminAuthGuardState extends State<SuperAdminAuthGuard> {
  @override
  Widget build(BuildContext context) {
    // Escuchar el proveedor de autenticación para actualizaciones reactivas
    final authProvider = Provider.of<NaziShopAuthProvider>(context);
    final user = authProvider.currentUser;

    // 1. Si está cargando, mostrar spinner y NO redirigir aún
    if (authProvider.isLoading) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary),
        ),
      );
    }

    // 2. Si terminó de cargar y no hay usuario -> Redirigir a Login
    if (!authProvider.isLoggedIn || user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed('login');
      });
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Center(
          child: LoadingIndicator(color: FlutterFlowTheme.of(context).primary),
        ),
      );
    }

    // 3. Si está logueado pero NO es SuperAdmin -> Pantalla de acceso denegado
    // Importante: isSuperAdmin es un getter en NaziShopUser
    if (!user.isSuperAdmin) {
      final theme = FlutterFlowTheme.of(context);
      return Scaffold(
        backgroundColor: theme.primaryBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    size: 80,
                    color: theme.error,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'SÓLO SUPERADMINISTRADORES',
                  style: GoogleFonts.outfit(
                    color: theme.error,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Acceso Restringido',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Esta sección contiene herramientas críticas del sistema. Se requiere nivel de Superadministrador para proceder.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    color: theme.secondaryText,
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.alternate.withValues(alpha: 0.3),
                    foregroundColor: theme.primaryText,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: theme.alternate),
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
      );
    }

    return widget.child;
  }
}
