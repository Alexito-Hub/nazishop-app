import '/flutter_flow/flutter_flow_util.dart';
import 'complete_profile_widget.dart' show CompleteProfileWidget;
import 'package:flutter/material.dart';

class CompleteProfileModel extends FlutterFlowModel<CompleteProfileWidget> {
  // State field(s) for fullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;

  // State field(s) for phone widget.
  FocusNode? phoneFocusNode;
  TextEditingController? phoneTextController;

  // State field(s) for description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;

  // State field(s) for country code dropdown.
  String? selectedCountryCode;

  // State field(s) for profile photo upload.
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();

    phoneFocusNode?.dispose();
    phoneTextController?.dispose();

    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();
  }
}
