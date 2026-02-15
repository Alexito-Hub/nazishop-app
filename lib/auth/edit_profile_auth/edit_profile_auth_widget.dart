import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'edit_profile_auth_model.dart';
export 'edit_profile_auth_model.dart';

class EditProfileAuthWidget extends StatefulWidget {
  const EditProfileAuthWidget({
    super.key,
    this.title = 'Editar Perfil',
    this.confirmButtonText = 'Guardar Cambios',
    this.navigateAction,
  });

  final String title;
  final String confirmButtonText;
  final Future<void> Function()? navigateAction;

  @override
  State<EditProfileAuthWidget> createState() => _EditProfileAuthWidgetState();
}

class _EditProfileAuthWidgetState extends State<EditProfileAuthWidget> {
  late EditProfileAuthModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileAuthModel());
    _model.yourNameTextController ??= TextEditingController();
    _model.yourNameFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          const SizedBox(height: 24),
          // Profile Picture Placeholder
          Center(
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Name Field
          Form(
            key: _model.formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _model.yourNameTextController,
                  focusNode: _model.yourNameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Nombre completo',
                    labelStyle: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    hintText: 'Tu nombre',
                    hintStyle: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context)
                          .secondaryText
                          .withOpacity(0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Save Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                if (_model.formKey.currentState?.validate() ?? false) {
                  if (widget.navigateAction != null) {
                    await widget.navigateAction!();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                widget.confirmButtonText,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
