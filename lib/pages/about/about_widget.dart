import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_theme.dart';

import 'about_model.dart';
import '../../components/smart_back_button.dart';
export 'about_model.dart';

class AboutWidget extends StatefulWidget {
  const AboutWidget({super.key});

  static String routeName = 'about';
  static String routePath = '/about';

  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  late AboutModel _model;
  static const Color kPrimaryColor = Color(0xFFE50914);

  @override
  void initState() {
    super.initState();
    _model = AboutModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive checks
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: SmartBackButton(color: theme.primaryText),
      ),
      body: Stack(
        children: [
          // Background Gradient Blob
          Positioned(
            top: -100,
            right: -100,
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

          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- LOGO & BRANDING ---
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE50914), Color(0xFFB81D24)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryColor.withOpacity(0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          )
                        ],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 60,
                      ),
                    )
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.elasticOut),

                    const SizedBox(height: 32),
                    Text(
                      'NAZISHOP',
                      style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: isDesktop ? 48 : 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn().moveY(begin: 20, end: 0),

                    Text(
                      'Streaming & Digital Goods Marketplace',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: theme.secondaryText,
                        fontSize: 16,
                      ),
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : theme.accent4,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : theme.alternate),
                      ),
                      child: Text(
                        'Versión 2.0.0 (Beta)',
                        style: GoogleFonts.robotoMono(
                          color: kPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // --- CONTENT GRID ---
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildInfoCard(
                          icon: Icons.security_rounded,
                          title: 'Seguridad Total',
                          desc:
                              'Transacciones encriptadas y entrega automática segura.',
                          delay: 300,
                        ),
                        _buildInfoCard(
                          icon: Icons.flash_on_rounded,
                          title: 'Entrega Inmediata',
                          desc:
                              'Tus credenciales y códigos se entregan al instante.',
                          delay: 400,
                        ),
                        _buildInfoCard(
                          icon: Icons.support_agent_rounded,
                          title: 'Soporte 24/7',
                          desc:
                              'Nuestro equipo está siempre listo para ayudarte.',
                          delay: 500,
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),

                    // --- LEGAL LINKS ---

                    _buildLegalSection(isDesktop),

                    const SizedBox(height: 40),
                    Text(
                      '© 2026 NaziShop Inc. Todos los derechos reservados.',
                      style: GoogleFonts.outfit(
                          color: theme.secondaryText, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String desc,
    required int delay,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: 240,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141414) : theme.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : theme.alternate),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: kPrimaryColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: theme.secondaryText,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).scale();
  }

  Widget _buildLegalSection(bool isDesktop) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(1), // Border width
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            isDark ? Colors.white.withOpacity(0.2) : theme.alternate,
            Colors.transparent
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withOpacity(0.5)
              : theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              'Enlaces de Interés',
              style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _textLink(
                    'Términos y Condiciones', () => context.pushNamed('terms')),
                _textLink('Política de Privacidad',
                    () => context.pushNamed('privacy_policy')),
                _textLink(
                    'Centro de Ayuda', () => context.pushNamed('support')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _textLink(String text, VoidCallback onTap) {
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: theme.secondaryText,
          decoration: TextDecoration.underline,
          decorationColor: theme.alternate,
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
