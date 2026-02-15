import '/auth/edit_profile_auth/edit_profile_auth_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_create_profile_model.dart';
export 'auth_create_profile_model.dart';

class AuthCreateProfileWidget extends StatefulWidget {
  const AuthCreateProfileWidget({super.key});

  static String routeName = 'auth_create_profile';
  static String routePath = '/authCreateProfile';

  @override
  State<AuthCreateProfileWidget> createState() =>
      _AuthCreateProfileWidgetState();
}

class _AuthCreateProfileWidgetState extends State<AuthCreateProfileWidget>
    with TickerProviderStateMixin {
  late AuthCreateProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthCreateProfileModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 140.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(-0.349, 0),
            end: const Offset(0, 0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            // Background Elements (Visible on Mobile/Tablet)
            if (responsiveVisibility(
              context: context,
              desktop: false,
            ))
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).primaryBackground,
                      FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                    ],
                    stops: const [0.0, 1.0],
                    begin: const AlignmentDirectional(0.0, -1.0),
                    end: const AlignmentDirectional(0, 1.0),
                  ),
                ),
              ),

            // Main Layout
            Row(
              children: [
                // Desktop Left Side (Brand/Image)
                if (responsiveVisibility(
                  context: context,
                  phone: false,
                  tablet: false,
                ))
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 100.0,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.black, // Dark matte
                      ),
                      child: Stack(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(
                                      0x99000000), // Semi-transparent black
                                  FlutterFlowTheme.of(context)
                                      .primary
                                      .withOpacity(0.6),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Perfil de Usuario',
                                style: FlutterFlowTheme.of(context)
                                    .displayLarge
                                    .override(
                                      font: GoogleFonts.outfit(),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Text(
                                  'Personaliza tu experiencia',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.outfit(),
                                        color: const Color(0xCCFFFFFF),
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // Right Side (Form)
                Expanded(
                  flex: 1,
                  child: Container(
                    height: double.infinity,
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(
                                maxWidth: 570.0,
                              ),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 12.0,
                                    color: Color(0x1A000000),
                                    offset: Offset(0.0, 5.0),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 24.0),
                                child: wrapWithModel(
                                  model: _model.editProfileAuthModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: EditProfileAuthWidget(
                                    title: 'Crear Perfil',
                                    confirmButtonText: 'Guardar y Continuar',
                                    navigateAction: () async {
                                      context.goNamed('home');
                                    },
                                  ),
                                ),
                              ),
                            ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation']!),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
