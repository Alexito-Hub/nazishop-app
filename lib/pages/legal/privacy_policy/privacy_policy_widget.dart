import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../../components/smart_back_button.dart';

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
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildSection(
                        '1. Información que Recopilamos',
                        'Recopilamos información personal que usted nos proporciona voluntariamente al registrarse, realizar compras o contactarnos. Esto incluye nombre, correo electrónico y detalles de transacciones.',
                      ),
                      _buildSection(
                        '2. Uso de la Información',
                        'Utilizamos su información para procesar pedidos, mejorar nuestros servicios, enviar actualizaciones importantes y proteger la seguridad de su cuenta.',
                      ),
                      _buildSection(
                        '3. Protección de Datos',
                        'Implementamos medidas de seguridad avanzadas para proteger sus datos personales contra acceso no autorizado, alteración o divulgación.',
                      ),
                      _buildSection(
                        '4. Compartir Información',
                        'No vendemos ni alquilamos su información personal a terceros. Solo compartimos datos con proveedores de servicios esenciales (como procesadores de pagos) bajo estrictos acuerdos de confidencialidad.',
                      ),
                      _buildSection(
                        '5. Sus Derechos',
                        'Usted tiene derecho a acceder, corregir o eliminar su información personal. Puede gestionar sus datos desde la configuración de su perfil o contactando a soporte.',
                      ),
                      _buildSection(
                        '6. Cambios en la Política',
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.privacy_tip_outlined, color: _primaryColor, size: 48),
        const SizedBox(height: 16),
        Text(
          'Su privacidad es nuestra prioridad',
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'En NaziShop, nos comprometemos a proteger sus datos personales y ser transparentes sobre cómo los utilizamos.',
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: _primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.justify,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
