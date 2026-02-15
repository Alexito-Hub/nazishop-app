import '/auth/edit_profile_auth/edit_profile_auth_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'auth_create_profile_widget.dart' show AuthCreateProfileWidget;
import 'package:flutter/material.dart';

class AuthCreateProfileModel extends FlutterFlowModel<AuthCreateProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for edit_profile_auth component.
  late EditProfileAuthModel editProfileAuthModel;

  @override
  void initState(BuildContext context) {
    editProfileAuthModel = createModel(context, () => EditProfileAuthModel());
  }

  @override
  void dispose() {
    editProfileAuthModel.dispose();
  }
}
