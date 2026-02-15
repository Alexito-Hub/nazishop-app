import '/pages/profile/edit_profile_modern.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/app_layout.dart';
import 'package:flutter/material.dart';
import 'auth_edit_profile_model.dart';
export 'auth_edit_profile_model.dart';

class AuthEditProfileWidget extends StatefulWidget {
  const AuthEditProfileWidget({super.key});

  static String routeName = 'auth_edit_profile';
  static String routePath = '/authEditProfile';

  @override
  State<AuthEditProfileWidget> createState() => _AuthEditProfileWidgetState();
}

class _AuthEditProfileWidgetState extends State<AuthEditProfileWidget> {
  late AuthEditProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthEditProfileModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: AuthEditProfileWidget.routeName,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          body: EditProfileModernWidget(
            title: 'Editar perfil',
            confirmButtonText: 'Guardar cambios',
            navigateAction: () async {
              context.safePop();
            },
          ),
        ),
      ),
    );
  }
}
