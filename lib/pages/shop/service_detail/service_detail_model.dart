import '/flutter_flow/flutter_flow_util.dart';
import 'service_detail_widget.dart' show ServiceDetailWidget;
import 'package:flutter/material.dart';

class ServiceDetailModel extends FlutterFlowModel<ServiceDetailWidget> {
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
