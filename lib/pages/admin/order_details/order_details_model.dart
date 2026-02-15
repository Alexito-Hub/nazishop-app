import '/flutter_flow/flutter_flow_util.dart';
import 'order_details_widget.dart' show OrderDetailsWidget;
import 'package:flutter/material.dart';

class OrderDetailsModel extends FlutterFlowModel<OrderDetailsWidget> {
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
