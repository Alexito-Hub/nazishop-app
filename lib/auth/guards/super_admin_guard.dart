import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:nazi_shop/auth/nazishop_auth/nazishop_auth_provider.dart';
import 'package:nazi_shop/flutter_flow/flutter_flow_util.dart';

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
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFE50914)),
        ),
      );
    }

    // 2. Si terminó de cargar y no hay usuario -> Redirigir a Login
    if (!authProvider.isLoggedIn || user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed('login');
      });
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFE50914)),
        ),
      );
    }

    // 3. Si está logueado pero NO es SuperAdmin -> Pantalla de acceso denegado
    // Importante: isSuperAdmin es un getter en NaziShopUser
    if (!user.isSuperAdmin) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3366).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security_rounded,
                    size: 80,
                    color: Color(0xFFFF3366),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'SÓLO SUPERADMINISTRADORES',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFFF3366),
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Esta sección contiene herramientas críticas del sistema. Se requiere nivel de Superadministrador para proceder.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    color: Colors.white38,
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.white.withOpacity(0.1)),
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
