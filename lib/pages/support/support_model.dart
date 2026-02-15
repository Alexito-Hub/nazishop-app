import '/flutter_flow/flutter_flow_util.dart';
import 'support_widget.dart' show SupportWidget;
import 'package:flutter/material.dart';

class SupportModel extends FlutterFlowModel<SupportWidget> {
  final unfocusNode = FocusNode();

  // Form controllers
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? messageController;

  @override
  void initState(BuildContext context) {
    nameController = TextEditingController();
    emailController = TextEditingController();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    nameController?.dispose();
    emailController?.dispose();
    messageController?.dispose();
  }
}
