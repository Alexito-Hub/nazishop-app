import '/flutter_flow/flutter_flow_util.dart';
import 'currency_management_widget.dart' show CurrencyManagementWidget;
import 'package:flutter/material.dart';

class CurrencyManagementModel
    extends FlutterFlowModel<CurrencyManagementWidget> {
  // Controladores para los campos de texto
  final unfocusNode = FocusNode();

  // Controladores para cada moneda
  FocusNode? copFocusNode;
  TextEditingController? copController;

  FocusNode? mxnFocusNode;
  TextEditingController? mxnController;

  FocusNode? penFocusNode;
  TextEditingController? penController;

  FocusNode? arsFocusNode;
  TextEditingController? arsController;

  FocusNode? clpFocusNode;
  TextEditingController? clpController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    copFocusNode?.dispose();
    copController?.dispose();
    mxnFocusNode?.dispose();
    mxnController?.dispose();
    penFocusNode?.dispose();
    penController?.dispose();
    arsFocusNode?.dispose();
    arsController?.dispose();
    clpFocusNode?.dispose();
    clpController?.dispose();
  }
}
