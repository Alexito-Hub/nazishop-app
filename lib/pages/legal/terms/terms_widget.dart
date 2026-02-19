import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../../components/smart_back_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import 'components/terms_header.dart';
import 'components/terms_section.dart';

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
                      const TermsHeader(),
                      const SizedBox(height: 32),
                      const TermsSection(
                        title: '1. Aceptación de los Términos',
                        content:
                            'Al acceder y utilizar NaziShop, usted acepta estar legalmente vinculado por estos Términos y Condiciones. Si no está de acuerdo con alguna parte, no debe utilizar nuestros servicios.',
                      ),
                      const TermsSection(
                        title: '2. Cuentas de Usuario',
                        content:
                            'Usted es responsable de mantener la confidencialidad de su cuenta y contraseña. NaziShop no se hace responsable de cualquier actividad que ocurra bajo su cuenta.',
                      ),
                      const TermsSection(
                        title: '3. Compras y Pagos',
                        content:
                            'Todos los precios están sujetos a cambios sin previo aviso. Nos reservamos el derecho de rechazar o cancelar cualquier pedido por motivos de seguridad o error en el precio.',
                      ),
                      const TermsSection(
                        title: '4. Productos Digitales',
                        content:
                            'La venta de productos digitales y suscripciones es final. No se ofrecen reembolsos una vez que el contenido digital ha sido entregado o accedido, salvo excepciones legales aplicables.',
                      ),
                      const TermsSection(
                        title: '5. Propiedad Intelectual',
                        content:
                            'Todo el contenido, marcas y logotipos en NaziShop son propiedad exclusiva de la empresa o sus licenciantes y están protegidos por leyes de propiedad intelectual.',
                      ),
                      const TermsSection(
                        title: '6. Limitación de Responsabilidad',
                        content:
                            'NaziShop no será responsable por daños indirectos, incidentales o consecuentes derivados del uso o la imposibilidad de uso del servicio.',
                      ),
                      const TermsSection(
                        title: '7. Modificaciones',
                        content:
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
}
