import '/auth/edit_profile_auth/edit_profile_auth_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'auth_edit_profile_widget.dart' show AuthEditProfileWidget;
import 'package:flutter/material.dart';

class AuthEditProfileModel extends FlutterFlowModel<AuthEditProfileWidget> {
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
