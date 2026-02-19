import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../../components/smart_back_button.dart';

import 'components/privacy_header.dart';
import 'components/privacy_section.dart';

class PrivacyPolicyWidget extends StatefulWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  State<PrivacyPolicyWidget> createState() => _PrivacyPolicyWidgetState();
}

class _PrivacyPolicyWidgetState extends State<PrivacyPolicyWidget> {
  final ScrollController _scrollController = ScrollController();
  Color get _primaryColor => FlutterFlowTheme.of(context).primary;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: theme.transparent,
        elevation: 0,
        surfaceTintColor: theme.transparent,
        leading: SmartBackButton(color: theme.primaryText),
        title: Text(
          'Política de Privacidad',
          style: GoogleFonts.outfit(
            color: theme.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _primaryColor.withValues(alpha: 0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: theme.transparent),
              ),
            ),
          ),

          Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PrivacyHeader(),
                      const SizedBox(height: 32),
                      const PrivacySection(
                        title: '1. Información que Recopilamos',
                        content:
                            'Recopilamos información personal que usted nos proporciona voluntariamente al registrarse, realizar compras o contactarnos. Esto incluye nombre, correo electrónico y detalles de transacciones.',
                      ),
                      const PrivacySection(
                        title: '2. Uso de la Información',
                        content:
                            'Utilizamos su información para procesar pedidos, mejorar nuestros servicios, enviar actualizaciones importantes y proteger la seguridad de su cuenta.',
                      ),
                      const PrivacySection(
                        title: '3. Protección de Datos',
                        content:
                            'Implementamos medidas de seguridad avanzadas para proteger sus datos personales contra acceso no autorizado, alteración o divulgación.',
                      ),
                      const PrivacySection(
                        title: '4. Compartir Información',
                        content:
                            'No vendemos ni alquilamos su información personal a terceros. Solo compartimos datos con proveedores de servicios esenciales (como procesadores de pagos) bajo estrictos acuerdos de confidencialidad.',
                      ),
                      const PrivacySection(
                        title: '5. Sus Derechos',
                        content:
                            'Usted tiene derecho a acceder, corregir o eliminar su información personal. Puede gestionar sus datos desde la configuración de su perfil o contactando a soporte.',
                      ),
                      const PrivacySection(
                        title: '6. Cambios en la Política',
                        content:
                            'Podemos actualizar esta política ocasionalmente. Le notificaremos sobre cambios significativos a través de la aplicación o por correo electrónico.',
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          'Última actualización: 7 de Febrero, 2026',
                          style: GoogleFonts.outfit(
                            color: theme.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ]
                        .animate(interval: 50.ms)
                        .fadeIn()
                        .moveY(begin: 10, end: 0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
