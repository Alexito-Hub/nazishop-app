import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../components/smart_back_button.dart';
import 'dart:ui';

class SupportWidget extends StatefulWidget {
  const SupportWidget({super.key});

  @override
  State<SupportWidget> createState() => _SupportWidgetState();
}

class _SupportWidgetState extends State<SupportWidget> {
  final ScrollController _scrollController = ScrollController();
  static const Color kPrimaryColor = Color(0xFFE50914);

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF050505) : theme.primaryBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading:
            SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
        title: Text(
          'Centro de Ayuda',
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
            left: 50,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor.withOpacity(0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
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
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 48),
                      _buildContactOption(
                        icon: Icons.telegram,
                        title: 'Telegram Soporte',
                        subtitle: 'Respuesta inmediata 24/7',
                        actionText: 'Iniciar Chat',
                        onTap: () => _launchUrl('https://t.me/NaziShopSupport'),
                        color: const Color(0xFF229ED9),
                      ),
                      const SizedBox(height: 24),
                      _buildContactOption(
                        icon: Icons.chat_bubble_outline,
                        title: 'WhatsApp',
                        subtitle: 'Soporte y Ventas',
                        actionText: 'Enviar Mensaje',
                        onTap: () => _launchUrl(
                            'https://wa.me/1234567890'), // Replace with real number
                        color: const Color(0xFF25D366),
                      ),
                      const SizedBox(height: 24),
                      _buildContactOption(
                        icon: Icons.email_outlined,
                        title: 'Correo Electrónico',
                        subtitle: 'support@nazishop.com',
                        actionText: 'Enviar Email',
                        onTap: () => _launchUrl('mailto:support@nazishop.com'),
                        color: FlutterFlowTheme.of(context).primary,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 48),
                      _buildFAQSection(),
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
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child:
              Icon(Icons.support_agent_rounded, color: kPrimaryColor, size: 48),
        ),
        const SizedBox(height: 24),
        Text(
          '¿Cómo podemos ayudarte?',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Nuestro equipo de soporte está disponible las 24 horas del día para resolver tus dudas.',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).secondaryText,
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
    bool isDark = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : FlutterFlowTheme.of(context).alternate),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
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
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: FlutterFlowTheme.of(context).secondaryText, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preguntas Frecuentes',
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFAQItem('¿Cómo recibo mi producto?',
            'Los productos digitales se envían automáticamente a tu correo electrónico después de la confirmación del pago.'),
        _buildFAQItem('¿Qué hago si mi cuenta no funciona?',
            'Contacta a nuestro soporte en Telegram con tu número de pedido y te ayudaremos a solucionarlo inmediatamente.'),
        _buildFAQItem('¿Aceptan devoluciones?',
            'Debido a la naturaleza digital de los productos, no ofrecemos devoluciones una vez entregados, salvo casos excepcionales.'),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.03)
            : FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
