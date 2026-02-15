import '/flutter_flow/flutter_flow_util.dart';
import 'add_balance_admin_widget.dart' show AddBalanceAdminWidget;
import 'package:flutter/material.dart';

class AddBalanceAdminModel extends FlutterFlowModel<AddBalanceAdminWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for search widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchController;
  String? Function(BuildContext, String?)? searchControllerValidator;
  String? selectedUser;

  // State field(s) for amount widget.
  FocusNode? amountFocusNode;
  TextEditingController? amountController;
  String? Function(BuildContext, String?)? amountControllerValidator;

  // State field(s) for note widget.
  FocusNode? noteFocusNode;
  TextEditingController? noteController;
  String? Function(BuildContext, String?)? noteControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchController?.dispose();
    amountFocusNode?.dispose();
    amountController?.dispose();
    noteFocusNode?.dispose();
    noteController?.dispose();
  }
}
