import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'phone_verification_widget.dart' show PhoneVerificationWidget;

class PhoneVerificationModel extends FlutterFlowModel<PhoneVerificationWidget> {
  final unfocusNode = FocusNode();

  // State for phone input step
  TextEditingController? phoneTextController;
  FocusNode? phoneFocusNode;

  // State for OTP input step
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    phoneFocusNode?.dispose();
    phoneTextController?.dispose();

    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();
  }
}
