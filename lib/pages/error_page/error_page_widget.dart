import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_theme.dart';

enum ErrorType {
  notFound,
  accessDenied,
  generalError,
}

class ErrorPageWidget extends StatelessWidget {
  final ErrorType type;
  final int? statusCode;
  final String? customMessage;

  const ErrorPageWidget({
    super.key,
    required this.type,
    this.statusCode,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Dynamic Content based on error type
    String title;
    String subtitle;
    String description;
    IconData icon;
    Color accentColor;

    switch (type) {
      case ErrorType.notFound:
        title = '404';
        subtitle = 'Página no encontrada';
        description = customMessage ??
            'Lo sentimos, la página que buscas no existe o ha sido movida.';
        icon = Icons.search_off_rounded;
        accentColor = theme.primary;
        break;
      case ErrorType.accessDenied:
        title = '403';
        subtitle = 'Acceso Restringido';
        description = customMessage ??
            'No tienes los permisos necesarios para acceder a esta sección.';
        icon = Icons.lock_person_rounded;
        accentColor = theme.error;
        break;
      case ErrorType.generalError:
        title = statusCode?.toString() ?? 'ERR';
        subtitle = 'Algo salió mal';
        description = customMessage ??
            'Ha ocurrido un error inesperado. Por favor, intenta de nuevo más tarde.';
        icon = Icons.error_outline_rounded;
        accentColor = theme.warning;
        break;
    }

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          image: DecorationImage(
            image: const AssetImage(
                'assets/images/glow_bg.png'), // Optional glow effect
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with Glow
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Icon(
                        icon,
                        size: 80,
                        color: accentColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Status Code / Title
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      color: accentColor,
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                    ),
                  ),

                  // Subtitle
                  Text(
                    subtitle.toUpperCase(),
                    style: GoogleFonts.outfit(
                      color: theme.primaryText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    description,
                    style: GoogleFonts.outfit(
                      color: theme.secondaryText,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 60),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        context.canPop() ? 'REGRESAR' : 'IR AL INICIO',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                  if (context.canPop()) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/'),
                      child: Text(
                        'Ir al inicio',
                        style: GoogleFonts.outfit(
                          color: theme.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
