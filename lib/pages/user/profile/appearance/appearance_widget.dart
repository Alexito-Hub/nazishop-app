import '/flutter_flow/flutter_flow_theme.dart';
import '../../../../components/smart_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'components/theme_selector.dart';
import 'components/accessibility_settings.dart';
import 'components/font_size_selector.dart';
import 'components/language_selector.dart';

class AppearanceWidget extends StatefulWidget {
  const AppearanceWidget({super.key});

  static String routeName = 'appearance';
  static String routePath = '/appearance';

  @override
  State<AppearanceWidget> createState() => _AppearanceWidgetState();
}

class _AppearanceWidgetState extends State<AppearanceWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (_isDesktop) {
              return _buildDesktopLayout();
            } else {
              return _buildMobileLayout();
            }
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // 📱 MOBILE LAYOUT (< 900px)
  // ===========================================================================
  Widget _buildMobileLayout() {
    final theme = FlutterFlowTheme.of(context);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: theme.transparent,
          surfaceTintColor: theme.transparent,
          pinned: true,
          floating: true,
          elevation: 0,
          leadingWidth: 70,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryBackground.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(color: theme.primaryText),
          ),
          centerTitle: true,
          title: Text(
            'Apariencia',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildSectionTitle("Tema"),
                const SizedBox(height: 12),
                const ThemeSelector(isDesktop: false),
                const SizedBox(height: 32),
                _buildSectionTitle("Accesibilidad"),
                const SizedBox(height: 12),
                const AccessibilitySettings(isDesktop: false),
                const SizedBox(height: 12),
                const FontSizeSelector(isDesktop: false),
                const SizedBox(height: 32),
                _buildSectionTitle("Idioma y Región"),
                const SizedBox(height: 12),
                const LanguageSelector(isDesktop: false),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 💻 DESKTOP LAYOUT (>= 900px)
  // ===========================================================================
  Widget _buildDesktopLayout() {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Desktop Header
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apariencia y Preferencias',
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                      Text(
                        'Personaliza tu experiencia visual en NaziShop',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Grid de Configuración Estilo Dashboard
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 240,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    // Card 1: Tema (Principal)
                    _buildDesktopCard(
                      title: "Tema de la Aplicación",
                      icon: Icons.palette_rounded,
                      child: Column(
                        children: const [
                          SizedBox(height: 16),
                          ThemeSelector(isDesktop: true),
                        ],
                      ),
                    ),
                    // Card 2: Accesibilidad
                    _buildDesktopCard(
                      title: "Accesibilidad",
                      icon: Icons.accessibility_new_rounded,
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          const AccessibilitySettings(isDesktop: true),
                          const SizedBox(height: 12),
                          Divider(color: theme.alternate),
                          const SizedBox(height: 12),
                          const FontSizeSelector(isDesktop: true),
                        ],
                      ),
                    ),
                    // Card 3: Idioma
                    _buildDesktopCard(
                      title: "Idioma",
                      icon: Icons.language_rounded,
                      child: const Center(
                        child: LanguageSelector(isDesktop: true),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 🧩 COMPONENTS
  // ===========================================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        color: FlutterFlowTheme.of(context).primary,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildDesktopCard(
      {required String title, required IconData icon, required Widget child}) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.secondaryText, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    ).animate().fadeIn().moveY(begin: 10, curve: Curves.easeOut);
  }
}
