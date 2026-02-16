import '/flutter_flow/flutter_flow_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'onboarding_model.dart';
export 'onboarding_model.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key});

  static String routeName = 'onboarding';
  static String routePath = '/onboarding';

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget>
    with TickerProviderStateMixin {
  late OnboardingModel _model;
  PageController? _pageController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingModel());
    _pageController = PageController(initialPage: 0);

    animationsMap.addAll({
      'fadeOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'scaleIcon': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.elasticOut,
            delay: 200.ms,
            duration: 800.ms,
            begin: const Offset(0.5, 0.5),
            end: const Offset(1.0, 1.0),
          ),
          FadeEffect(duration: 600.ms, begin: 0.0, end: 1.0),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(String routeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      context.pushNamed(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Breakpoint logic: Mobile < 900px, Desktop >= 900px
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.secondaryBackground,
        body: SafeArea(
          top: false,
          child: isDesktop
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),
        ),
      ),
    );
  }

  // ===========================================================================
  // MOBILE LAYOUT
  // ===========================================================================
  Widget _buildMobileLayout(BuildContext context) {
    return Stack(
      children: [
        // 1. Background Gradient Area (Top Half)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                  FlutterFlowTheme.of(context).secondaryBackground,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // 2. Main Content
        Column(
          children: [
            // Skip Button (Top Right)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 24, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => _completeOnboarding(AuthLoginWidget.routeName),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Omitir',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Page View with Icons/Illustrations
            Expanded(
              flex: 3,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  // Optional: Update state if you need to change button text based on index
                },
                children: _buildSlides(context, isDesktop: false),
              ),
            ),

            // Bottom Sheet Area (White/Card)
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    )
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Indicators
                      smooth_page_indicator.SmoothPageIndicator(
                        controller: _pageController ?? PageController(),
                        count: 3,
                        effect: smooth_page_indicator.ExpandingDotsEffect(
                          expansionFactor: 3,
                          spacing: 8.0,
                          radius: 4.0,
                          dotWidth: 8.0,
                          dotHeight: 8.0,
                          dotColor: FlutterFlowTheme.of(context).alternate,
                          activeDotColor: FlutterFlowTheme.of(context).primary,
                          paintStyle: PaintingStyle.fill,
                        ),
                      ),

                      const Spacer(),

                      // Action Buttons
                      Column(
                        children: [
                          FFButtonWidget(
                            onPressed: () =>
                                _completeOnboarding(AuthCreateWidget.routeName),
                            text: 'Empezar ahora',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 54.0,
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                              elevation: 2.0,
                              borderSide: const BorderSide(
                                  color: Colors.transparent, width: 1.0),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FFButtonWidget(
                            onPressed: () =>
                                _completeOnboarding(AuthLoginWidget.routeName),
                            text: 'Ya tengo cuenta',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 54.0,
                              color: Colors.transparent,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // DESKTOP LAYOUT
  // ===========================================================================
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // LEFT SIDE: Visuals & Branding (Immersive)
        Expanded(
          flex: 6, // 60% Width
          child: Container(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            child: Stack(
              children: [
                // Decorative Background Elements
                Positioned(
                  top: -100,
                  left: -100,
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.05),
                    ),
                  ),
                ),

                // Centered Carousel
                Center(
                  child: SizedBox(
                    height: 600,
                    width: 600,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            children: _buildSlides(context, isDesktop: true),
                          ),
                        ),
                        const SizedBox(height: 40),
                        smooth_page_indicator.SmoothPageIndicator(
                          controller: _pageController ?? PageController(),
                          count: 3,
                          effect: smooth_page_indicator.ExpandingDotsEffect(
                            expansionFactor: 3,
                            spacing: 12.0,
                            radius: 6.0,
                            dotWidth: 10.0,
                            dotHeight: 10.0,
                            dotColor: FlutterFlowTheme.of(context).alternate,
                            activeDotColor:
                                FlutterFlowTheme.of(context).primary,
                            paintStyle: PaintingStyle.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // RIGHT SIDE: Action Panel (Clean & Professional)
        Expanded(
          flex: 4, // 40% Width
          child: Container(
            color: FlutterFlowTheme.of(context).primaryBackground,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header / Logo
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.bagShopping,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Digital Shop', // Nombre actualizado
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Inter Tight',
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  'Todo lo digital,\nen un solo lugar.',
                  style: FlutterFlowTheme.of(context).displaySmall.override(
                        fontFamily: 'Inter Tight',
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: FlutterFlowTheme.of(context).primaryText,
                        lineHeight: 1.1,
                      ),
                ).animateOnPageLoad(animationsMap['fadeOnPageLoadAnimation']!),

                const SizedBox(height: 24),

                Text(
                  'Únete a la plataforma líder en servicios digitales y licencias de software. Garantía total y entrega inmediata.',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        lineHeight: 1.6,
                      ),
                ).animateOnPageLoad(animationsMap['fadeOnPageLoadAnimation']!),

                const Spacer(),

                // Desktop Actions
                FFButtonWidget(
                  onPressed: () =>
                      _completeOnboarding(AuthCreateWidget.routeName),
                  text: 'Crear cuenta gratuita',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 60.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter Tight',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes cuenta?',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                    ),
                    TextButton(
                      onPressed: () =>
                          _completeOnboarding(AuthLoginWidget.routeName),
                      child: Text(
                        'Iniciar sesión',
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              color: FlutterFlowTheme.of(context).primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // SLIDE CONTENT GENERATOR
  // ===========================================================================
  List<Widget> _buildSlides(BuildContext context, {required bool isDesktop}) {
    return [
      _buildSlideItem(
        context,
        title: 'Calidad Premium',
        description:
            'Tu destino confiable para servicios digitales de alta calidad con garantía asegurada.',
        icon: Icons.verified_user_rounded,
        color: FlutterFlowTheme.of(context).primary,
        isDesktop: isDesktop,
      ),
      _buildSlideItem(
        context,
        title: 'Streaming Total',
        description:
            'Netflix, Disney+, Spotify y más. Tus plataformas favoritas sin interrupciones.',
        isCustomIcon: true,
        customContent: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBrandIcon(
                context, FontAwesomeIcons.n, const Color(0xFFE50914)),
            const SizedBox(width: 20),
            _buildBrandIcon(
                context, FontAwesomeIcons.spotify, const Color(0xFF1DB954)),
            const SizedBox(width: 20),
            _buildBrandIcon(
                context, FontAwesomeIcons.amazon, const Color(0xFF00A8E1)),
          ],
        ),
        isDesktop: isDesktop,
      ),
      _buildSlideItem(
        context,
        title: 'Software & Redes',
        description:
            'Licencias originales de Windows y Office. Impulsa tus redes sociales con nuestros servicios.',
        isCustomIcon: true,
        customContent: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBrandIcon(
                context, FontAwesomeIcons.microsoft, const Color(0xFF0078D6)),
            const SizedBox(width: 20),
            _buildBrandIcon(
                context, FontAwesomeIcons.instagram, const Color(0xFFC13584)),
            const SizedBox(width: 20),
            _buildBrandIcon(context, FontAwesomeIcons.key,
                FlutterFlowTheme.of(context).primaryText),
          ],
        ),
        isDesktop: isDesktop,
      ),
    ];
  }

  Widget _buildSlideItem(
    BuildContext context, {
    required String title,
    required String description,
    IconData? icon,
    Color? color,
    bool isCustomIcon = false,
    Widget? customContent,
    required bool isDesktop,
  }) {
    // Si estamos en Desktop, ocultamos los textos en el carrusel (porque están estáticos a la derecha)
    // Pero si quieres que cambien, puedes dejarlos. En este diseño profesional,
    // en desktop a veces es mejor que la imagen cambie y el texto de la derecha sea genérico o cambie también.
    // Para simplificar, en Desktop solo mostramos el ícono grande.

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container with Glassmorphism feel
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: (color ?? FlutterFlowTheme.of(context).primary)
                  .withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: (color ?? FlutterFlowTheme.of(context).primary)
                    .withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: isCustomIcon
                ? customContent
                : Icon(
                    icon,
                    size: isDesktop ? 100 : 80,
                    color: color ?? FlutterFlowTheme.of(context).primary,
                  ),
          ).animateOnPageLoad(animationsMap['scaleIcon']!),

          // Only show text here for Mobile. Desktop text is on the right panel.
          if (!isDesktop) ...[
            const SizedBox(height: 40),
            Text(
              title,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Inter Tight',
                    fontWeight: FontWeight.bold,
                  ),
            ).animateOnPageLoad(animationsMap['fadeOnPageLoadAnimation']!),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    lineHeight: 1.5,
                  ),
            ).animateOnPageLoad(animationsMap['fadeOnPageLoadAnimation']!),
          ],
        ],
      ),
    );
  }

  Widget _buildBrandIcon(BuildContext context, IconData icon, Color color) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Center(
        child: FaIcon(icon, color: color, size: 24),
      ),
    );
  }
}
