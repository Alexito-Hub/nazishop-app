import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/components/design_system.dart';
import 'dart:ui';

class SupportWidget extends StatefulWidget {
  const SupportWidget({super.key});

  @override
  State<SupportWidget> createState() => _SupportWidgetState();
}

class _SupportWidgetState extends State<SupportWidget> {
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -100,
            left: 50,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primary.withValues(alpha: 0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: theme.transparent),
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const DSMobileAppBar(title: 'Centro de Ayuda'),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        children: [
                          _buildHeader(theme),
                          const SizedBox(height: 48),
                          _buildContactOption(
                            icon: Icons.telegram,
                            title: 'Telegram Soporte',
                            subtitle: 'Respuesta inmediata 24/7',
                            actionText: 'Iniciar Chat',
                            onTap: () =>
                                _launchUrl('https://t.me/NaziShopSupport'),
                            color: theme.primary,
                          ),
                          const SizedBox(height: 24),
                          _buildContactOption(
                            icon: Icons.chat_bubble_outline,
                            title: 'WhatsApp',
                            subtitle: 'Soporte y Ventas',
                            actionText: 'Enviar Mensaje',
                            onTap: () => _launchUrl('https://wa.me/1234567890'),
                            color: theme.secondary,
                          ),
                          const SizedBox(height: 24),
                          _buildContactOption(
                            icon: Icons.email_outlined,
                            title: 'Correo Electrónico',
                            subtitle: 'support@nazishop.com',
                            actionText: 'Enviar Email',
                            onTap: () =>
                                _launchUrl('mailto:support@nazishop.com'),
                            color: theme.primary,
                          ),
                          const SizedBox(height: 48),
                          _buildFAQSection(theme),
                          const SizedBox(height: 40),
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
        ],
      ),
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child:
              Icon(Icons.support_agent_rounded, color: theme.primary, size: 48),
        ),
        const SizedBox(height: 24),
        Text(
          '¿Cómo podemos ayudarte?',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: theme.primaryText,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Nuestro equipo de soporte está disponible las 24 horas del día para resolver tus dudas.',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: theme.secondaryText,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
    required Color color,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Material(
      color: theme.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.alternate),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        color: theme.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: theme.secondaryText, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preguntas Frecuentes',
          style: GoogleFonts.outfit(
            color: theme.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFAQItem(
            '¿Cómo recibo mi producto?',
            'Los productos digitales se envían automáticamente a tu correo electrónico después de la confirmación del pago.',
            theme),
        _buildFAQItem(
            '¿Qué hago si mi cuenta no funciona?',
            'Contacta a nuestro soporte en Telegram con tu número de pedido y te ayudaremos a solucionarlo inmediatamente.',
            theme),
        _buildFAQItem(
            '¿Aceptan devoluciones?',
            'Debido a la naturaleza digital de los productos, no ofrecemos devoluciones una vez entregados, salvo casos excepcionales.',
            theme),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer, FlutterFlowTheme theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: GoogleFonts.outfit(
              color: theme.secondaryText,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
