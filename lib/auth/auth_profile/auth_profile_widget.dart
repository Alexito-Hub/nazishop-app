import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components/profile_header.dart';
import 'components/profile_option_card.dart';
import 'components/sign_out_button.dart';

import 'auth_profile_model.dart';
export 'auth_profile_model.dart';

class AuthProfileWidget extends StatefulWidget {
  const AuthProfileWidget({super.key});

  static String routeName = 'auth_profile';
  static String routePath = '/authProfile';

  @override
  State<AuthProfileWidget> createState() => _AuthProfileWidgetState();
}

class _AuthProfileWidgetState extends State<AuthProfileWidget>
    with TickerProviderStateMixin {
  late AuthProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthProfileModel());

    animationsMap.addAll({
      'buttonOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 400.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 60.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxWidth: 770.0,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 4.0, 0.0, 0.0),
                child: Text(
                  'Tu cuenta',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                        ),
                      ),
                ),
              ),
              ProfileOptionCard(
                title: 'Editar perfil',
                icon: Icons.account_circle_outlined,
                onTap: () async {
                  context.pushNamed(AuthEditProfileWidget.routeName);
                },
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 0.0, 0.0),
                child: Text(
                  'Configuración de la aplicación',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                        ),
                      ),
                ),
              ),
              ProfileOptionCard(
                title: 'Soporte',
                icon: Icons.help_outline_rounded,
                onTap: () {
                  // Navigate to support
                },
              ),
              ProfileOptionCard(
                title: 'Términos de servicio',
                icon: Icons.privacy_tip_rounded,
                onTap: () {
                  // Navigate to terms
                },
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: SignOutButton(
                    onPressed: () async {
                      final manager = getAuthManager(context);
                      await manager.signOut();

                      if (!context.mounted) {
                        return;
                      }

                      context.goNamedAuth(
                          OnboardingWidget.routeName, context.mounted);
                    },
                  ).animateOnPageLoad(
                      animationsMap['buttonOnPageLoadAnimation']!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
