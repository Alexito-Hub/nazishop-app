import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/auth/nazishop_auth/nazishop_auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'complete_profile_model.dart';
export 'complete_profile_model.dart';

class CompleteProfileWidget extends StatefulWidget {
  const CompleteProfileWidget({super.key});

  static String routeName = 'complete_profile';
  static String routePath = '/completeProfile';

  @override
  State<CompleteProfileWidget> createState() => _CompleteProfileWidgetState();
}

class _CompleteProfileWidgetState extends State<CompleteProfileWidget> {
  late CompleteProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CompleteProfileModel());

    _model.fullNameTextController ??= TextEditingController();
    _model.fullNameFocusNode ??= FocusNode();

    _model.descriptionTextController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();

    _model.phoneTextController ??= TextEditingController();
    _model.phoneFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.sizeOf(context).width > 600 ? 40.0 : 24.0,
                        MediaQuery.sizeOf(context).width > 600 ? 48.0 : 32.0,
                        MediaQuery.sizeOf(context).width > 600 ? 40.0 : 24.0,
                        24.0,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '¡Bienvenido!',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  font: GoogleFonts.inter(),
                                  letterSpacing: 0.0,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Text(
                              'Completa tu perfil para comenzar',
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    font: GoogleFonts.inter(),
                                    letterSpacing: 0.0,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Form Container
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.sizeOf(context).width > 600 ? 40.0 : 24.0,
                        0.0,
                        MediaQuery.sizeOf(context).width > 600 ? 40.0 : 24.0,
                        MediaQuery.sizeOf(context).width > 600 ? 40.0 : 24.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x33000000),
                              offset: Offset(0.0, 2.0),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Foto de perfil
                              GestureDetector(
                                onTap: () async {
                                  final selectedMedia =
                                      await selectMediaWithSourceBottomSheet(
                                    context: context,
                                    allowPhoto: true,
                                    backgroundColor:
                                        FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                    textColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  );
                                  if (selectedMedia != null &&
                                      selectedMedia.every((m) =>
                                          validateFileFormat(
                                              m.storagePath, context))) {
                                    safeSetState(
                                        () => _model.isDataUploading = true);
                                    try {
                                      final selectedUploadedFiles =
                                          selectedMedia
                                              .map((m) => FFUploadedFile(
                                                    name: m.storagePath
                                                        .split('/')
                                                        .last,
                                                    bytes: m.bytes,
                                                  ))
                                              .toList();

                                      safeSetState(() {
                                        _model.uploadedFileUrl = '';
                                      });
                                      if (selectedUploadedFiles.isNotEmpty) {
                                        safeSetState(() {
                                          _model.uploadedLocalFile =
                                              selectedUploadedFiles.first;
                                        });
                                      }
                                    } finally {
                                      _model.isDataUploading = false;
                                    }
                                  }
                                },
                                child: Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).accent1,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: _model.uploadedLocalFile.bytes
                                              ?.isNotEmpty ??
                                          false
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                          child: Image.memory(
                                            _model.uploadedLocalFile.bytes!,
                                            width: 120.0,
                                            height: 120.0,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon(
                                          Icons.add_a_photo,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 40.0,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 24.0),
                                child: Text(
                                  'Toca para agregar foto',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                ),
                              ),
                              // Campo Nombre Completo
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 16.0),
                                child: TextFormField(
                                  controller: _model.fullNameTextController,
                                  focusNode: _model.fullNameFocusNode,
                                  autofocus: false,
                                  autofillHints: const [AutofillHints.name],
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Nombre Completo *',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          font: GoogleFonts.inter(),
                                          letterSpacing: 0.0,
                                        ),
                                    hintText: 'Ingresa tu nombre',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                      ),
                                  keyboardType: TextInputType.name,
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              // Campo Número de Teléfono con Prefijo
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 16.0),
                                child: Row(
                                  children: [
                                    // Dropdown para prefijo de país
                                    Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        initialValue:
                                            _model.selectedCountryCode ?? '+51',
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 8.0,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                              value: '+51', child: Text('+51')),
                                          DropdownMenuItem(
                                              value: '+1', child: Text('+1')),
                                          DropdownMenuItem(
                                              value: '+34', child: Text('+34')),
                                          DropdownMenuItem(
                                              value: '+52', child: Text('+52')),
                                          DropdownMenuItem(
                                              value: '+54', child: Text('+54')),
                                          DropdownMenuItem(
                                              value: '+56', child: Text('+56')),
                                          DropdownMenuItem(
                                              value: '+57', child: Text('+57')),
                                          DropdownMenuItem(
                                              value: '+593',
                                              child: Text('+593')),
                                        ],
                                        onChanged: (value) {
                                          safeSetState(() {
                                            _model.selectedCountryCode = value;
                                          });
                                        },
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Campo de número de teléfono
                                    Expanded(
                                      child: TextFormField(
                                        controller: _model.phoneTextController,
                                        focusNode: _model.phoneFocusNode,
                                        autofocus: false,
                                        autofillHints: const [
                                          AutofillHints.telephoneNumber
                                        ],
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Teléfono (Opcional)',
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelLarge
                                                  .override(
                                                    font: GoogleFonts.inter(),
                                                    letterSpacing: 0.0,
                                                  ),
                                          hintText: '987654321',
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          filled: true,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              font: GoogleFonts.inter(),
                                              letterSpacing: 0.0,
                                            ),
                                        keyboardType: TextInputType.phone,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Campo Descripción
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 24.0),
                                child: TextFormField(
                                  controller: _model.descriptionTextController,
                                  focusNode: _model.descriptionFocusNode,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Sobre ti (Opcional)',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          font: GoogleFonts.inter(),
                                          letterSpacing: 0.0,
                                        ),
                                    hintText: 'Cuéntanos un poco sobre ti...',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                      ),
                                  maxLines: 4,
                                  maxLength: 500,
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              // Botón Continuar
                              FFButtonWidget(
                                onPressed: () async {
                                  // Validar nombre
                                  if (_model
                                      .fullNameTextController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('El nombre es requerido')),
                                    );
                                    return;
                                  }

                                  if (_model
                                          .fullNameTextController.text.length <
                                      2) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'El nombre debe tener al menos 2 caracteres')),
                                    );
                                    return;
                                  }

                                  // Validar teléfono si se proporcionó
                                  if (_model
                                      .phoneTextController.text.isNotEmpty) {
                                    if (_model.phoneTextController.text.length <
                                            7 ||
                                        _model.phoneTextController.text.length >
                                            15) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'El número debe tener entre 7 y 15 dígitos')),
                                      );
                                      return;
                                    }
                                    if (!RegExp(r'^[0-9]+$').hasMatch(
                                        _model.phoneTextController.text)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Solo se permiten números')),
                                      );
                                      return;
                                    }
                                  }

                                  // Actualizar perfil del usuario
                                  final authProvider =
                                      Provider.of<NaziShopAuthProvider>(context,
                                          listen: false);
                                  await authProvider.updateProfile(
                                    displayName:
                                        _model.fullNameTextController.text,
                                    photoUrl: _model.uploadedFileUrl,
                                  );

                                  // Actualizar datos adicionales en Firestore
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .update({
                                      'phoneNumber':
                                          '${_model.selectedCountryCode}${_model.phoneTextController.text}',
                                      'description':
                                          _model.descriptionTextController.text,
                                    });
                                  }

                                  if (!context.mounted) return;

                                  // Redirigir al home
                                  context.goNamed('/home');
                                },
                                text: 'Continuar',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 48.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.inter(),
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 3.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              // Botón Omitir
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: TextButton(
                                  onPressed: () {
                                    context.goNamed('/home');
                                  },
                                  child: Text(
                                    'Omitir por ahora',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(),
                                          letterSpacing: 0.0,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
