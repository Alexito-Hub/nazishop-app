import '/flutter_flow/flutter_flow_util.dart';
import 'inventory_details_widget.dart' show InventoryDetailsWidget;
import 'package:flutter/material.dart';

class InventoryDetailsModel extends FlutterFlowModel<InventoryDetailsWidget> {
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
