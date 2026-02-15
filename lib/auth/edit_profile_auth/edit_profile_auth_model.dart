import '/flutter_flow/flutter_flow_util.dart';
import 'edit_profile_auth_widget.dart' show EditProfileAuthWidget;
import 'package:flutter/material.dart';

class EditProfileAuthModel extends FlutterFlowModel<EditProfileAuthWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  bool isDataUploadingUploadData8ss = false;
  FFUploadedFile uploadedLocalFileUploadData8ss =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrlUploadData8ss = '';

  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode;
  TextEditingController? yourNameTextController;
  String? Function(BuildContext, String?)? yourNameTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    yourNameFocusNode?.dispose();
    yourNameTextController?.dispose();
  }
}
