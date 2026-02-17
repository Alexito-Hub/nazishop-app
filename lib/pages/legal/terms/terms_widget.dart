import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../../components/smart_back_button.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:ui';

class TermsWidget extends StatefulWidget {
  const TermsWidget({super.key});

  @override
  State<TermsWidget> createState() => _TermsWidgetState();
}

class _TermsWidgetState extends State<TermsWidget> {
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
        leading:
            SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
        title: Text(
          'Términos y Condiciones',
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primaryText,
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
            right: -100,
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
                        '1. Aceptación de los Términos',
                        'Al acceder y utilizar NaziShop, usted acepta estar legalmente vinculado por estos Términos y Condiciones. Si no está de acuerdo con alguna parte, no debe utilizar nuestros servicios.',
                      ),
                      _buildSection(
                        '2. Cuentas de Usuario',
                        'Usted es responsable de mantener la confidencialidad de su cuenta y contraseña. NaziShop no se hace responsable de cualquier actividad que ocurra bajo su cuenta.',
                      ),
                      _buildSection(
                        '3. Compras y Pagos',
                        'Todos los precios están sujetos a cambios sin previo aviso. Nos reservamos el derecho de rechazar o cancelar cualquier pedido por motivos de seguridad o error en el precio.',
                      ),
                      _buildSection(
                        '4. Productos Digitales',
                        'La venta de productos digitales y suscripciones es final. No se ofrecen reembolsos una vez que el contenido digital ha sido entregado o accedido, salvo excepciones legales aplicables.',
                      ),
                      _buildSection(
                        '5. Propiedad Intelectual',
                        'Todo el contenido, marcas y logotipos en NaziShop son propiedad exclusiva de la empresa o sus licenciantes y están protegidos por leyes de propiedad intelectual.',
                      ),
                      _buildSection(
                        '6. Limitación de Responsabilidad',
                        'NaziShop no será responsable por daños indirectos, incidentales o consecuentes derivados del uso o la imposibilidad de uso del servicio.',
                      ),
                      _buildSection(
                        '7. Modificaciones',
                        'Nos reservamos el derecho de modificar estos términos en cualquier momento. El uso continuado del servicio constituye la aceptación de los nuevos términos.',
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          'Última actualización: 7 de Febrero, 2026',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText,
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
        Icon(Icons.gavel_outlined, color: _primaryColor, size: 48),
        const SizedBox(height: 16),
        Text(
          'Acuerdo de Uso',
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Por favor lea estos términos cuidadosamente antes de utilizar nuestros servicios de streaming y productos digitales.',
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
