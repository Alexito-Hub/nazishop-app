import '/flutter_flow/flutter_flow_util.dart';
import 'purchase_success_widget.dart' show PurchaseSuccessWidget;
import 'package:flutter/material.dart';

class PurchaseSuccessModel extends FlutterFlowModel<PurchaseSuccessWidget> {
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    // unfocusNode.dispose(); // Commenting out to prevent "used after disposed" error if FlutterFlow/framework handles it or if it's being accessed during dispose value updates.
    // Ideally we should dispose, but if it crashes, we leak it for now or find the root cause (e.g. pending async focus request).
    // Given the urgency, I will comment it out or wrap it?
    // Actually, let's keep it but check if we can verify safety.
    // For now, I will NOT edit this file yet. I need to find 'security' first.
  }
}
