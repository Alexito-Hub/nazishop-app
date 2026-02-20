import '/auth/nazishop_auth/auth_util.dart';
import '/auth/nazishop_auth/nazishop_auth_provider.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import '../../../components/safe_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '/components/design_system.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({
    super.key,
    this.title = 'Editar Perfil',
    this.confirmButtonText = 'Guardar Cambios',
    this.navigateAction,
  });

  final String title;
  final String confirmButtonText;
  final Future Function()? navigateAction;

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final _formKey = GlobalKey<FormState>();

  // Consistencia de Diseño Moderno
  Color get _primaryColor => FlutterFlowTheme.of(context).primary;

  // Controllers
  TextEditingController? nameController;
  TextEditingController? descriptionController;
  TextEditingController? phoneController;

  // State
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';
  String? selectedCountryCode;

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: currentUserDisplayName);
    descriptionController = TextEditingController();
    phoneController = TextEditingController(
        text: _extractPhoneNumber(currentUserPhoneNumber));
    selectedCountryCode = _extractCountryCode(currentUserPhoneNumber);
  }

  String _extractCountryCode(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) return '+51';
    if (phoneNumber.startsWith('+')) {
      final match = RegExp(r'^\+\d{1,3}').firstMatch(phoneNumber);
      return match?.group(0) ?? '+51';
    }
    return '+51';
  }

  String _extractPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) return '';
    final countryCode = _extractCountryCode(phoneNumber);
    return phoneNumber.replaceFirst(countryCode, '');
  }

  @override
  void dispose() {
    nameController?.dispose();
    descriptionController?.dispose();
    phoneController?.dispose();
    super.dispose();
  }

  void _safeUnfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Stack(
        children: [
          // Fondo degradado coherente
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _primaryColor.withValues(alpha: 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: theme.transparent),
              ),
            ),
          ),

          _isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        DSMobileAppBar(title: widget.title),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildFormContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    final theme = FlutterFlowTheme.of(context);
    return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.outfit(
                            color: theme.primaryText,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mantén actualizada tu información',
                          style: GoogleFonts.outfit(
                              color: theme.secondaryText, fontSize: 16),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: theme.alternate),
                      ),
                      child: _buildDesktopFormContent(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildDesktopFormContent() {
    final theme = FlutterFlowTheme.of(context);
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna Izquierda: Foto
          Expanded(
            flex: 1,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _uploadProfilePhoto,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _primaryColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: _buildProfileImage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                DSButton(
                  label: 'Cambiar Foto',
                  icon: Icons.camera_alt_outlined,
                  onPressed: _uploadProfilePhoto,
                  isSecondary: true,
                  width: 200,
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          // Columna Derecha: Campos
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DSInput(
                  controller: nameController,
                  label: 'Nombre Completo',
                  hint: 'Tu nombre visible',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es requerido';
                    }
                    if (value.length < 2) {
                      return 'Min 2 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DSInput(
                  controller: descriptionController,
                  label: 'Bio / Descripción',
                  hint: 'Cuéntanos sobre ti...',
                  prefixIcon: Icons.info_outline,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),
                Text(
                  'Teléfono',
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        border: Border.all(
                          color: theme.alternate,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedCountryCode,
                        dropdownColor: theme.secondaryBackground,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                        ),
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: theme.secondaryText),
                        items: [
                          '+51',
                          '+1',
                          '+34',
                          '+52',
                          '+54',
                          '+56',
                          '+57',
                          '+593'
                        ]
                            .map((val) => DropdownMenuItem(
                                value: val,
                                child: Text(val,
                                    style: GoogleFonts.outfit(
                                        color: theme.primaryText))))
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedCountryCode = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DSInput(
                        controller: phoneController,
                        hint: '987654321',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Solo números';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Botones Row
                Row(
                  children: [
                    SizedBox(
                      width: 160,
                      child: DSButton(
                        label: 'Cancelar',
                        onPressed: () async {
                          _safeUnfocus();
                          if (widget.navigateAction != null) {
                            await widget.navigateAction?.call();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        isOutline: true,
                        isSecondary: true,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DSButton(
                        label: widget.confirmButtonText,
                        onPressed: _saveChanges,
                        isLoading: isDataUploading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    final theme = FlutterFlowTheme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto de perfil
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _uploadProfilePhoto,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _primaryColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: _buildProfileImage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DSButton(
                  label: 'Cambiar Foto',
                  icon: Icons.camera_alt_outlined,
                  onPressed: _uploadProfilePhoto,
                  isSecondary: true,
                  width: 160,
                  height: 40,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Información básica
          DSInput(
            controller: nameController,
            label: 'Nombre Completo',
            hint: 'Tu nombre visible',
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre es requerido';
              }
              if (value.length < 2) {
                return 'Min 2 caracteres';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          DSInput(
            controller: descriptionController,
            label: 'Bio / Descripción',
            hint: 'Cuéntanos sobre ti...',
            prefixIcon: Icons.info_outline,
            maxLines: 3,
          ),

          const SizedBox(height: 20),

          // Teléfono con código de país
          Text(
            'Teléfono',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  border: Border.all(
                    color: theme.alternate,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedCountryCode,
                  dropdownColor: theme.secondaryBackground,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                  ),
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: theme.secondaryText),
                  items: [
                    '+51',
                    '+1',
                    '+34',
                    '+52',
                    '+54',
                    '+56',
                    '+57',
                    '+593'
                  ]
                      .map((val) => DropdownMenuItem(
                          value: val,
                          child: Text(val,
                              style: GoogleFonts.outfit(
                                  color: theme.primaryText))))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedCountryCode = value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DSInput(
                  controller: phoneController,
                  hint: '987654321',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Solo números';
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Botones
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: DSButton(
                  label: widget.confirmButtonText,
                  onPressed: _saveChanges,
                  isLoading: isDataUploading,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: DSButton(
                  label: 'Cancelar',
                  onPressed: () async {
                    _safeUnfocus();
                    if (widget.navigateAction != null) {
                      await widget.navigateAction?.call();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  isOutline: true,
                  isSecondary: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (uploadedFileUrl.isNotEmpty) {
      return SafeImage(
        uploadedFileUrl,
        fit: BoxFit.cover,
        allowRemoteDownload: true,
        placeholder: _buildPlaceholderImage(),
      );
    } else if (currentUserPhoto.isNotEmpty) {
      return SafeImage(
        currentUserPhoto,
        fit: BoxFit.cover,
        allowRemoteDownload: false,
        placeholder: _buildPlaceholderImage(),
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      color: theme.secondaryBackground,
      child: Center(
        child: Icon(
          Icons.person,
          size: 60,
          color: _primaryColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Future<void> _uploadProfilePhoto() async {
    final selectedMedia = await selectMedia(
      mediaSource: MediaSource.photoGallery,
      multiImage: false,
    );

    if (!mounted) return;

    if (selectedMedia != null &&
        selectedMedia
            .every((m) => validateFileFormat(m.storagePath, context))) {
      setState(() => isDataUploading = true);

      try {
        showUploadMessage(context, 'Subiendo imagen...', showLoading: true);

        final photoUrl = await uploadData(
          selectedMedia.first.storagePath,
          selectedMedia.first.bytes,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        setState(() => isDataUploading = false);

        if (photoUrl != null && photoUrl.isNotEmpty) {
          setState(() => uploadedFileUrl = photoUrl);

          final authProvider =
              Provider.of<NaziShopAuthProvider>(context, listen: false);
          await authProvider.updateProfile(
            displayName: currentUserDisplayName,
            photoUrl: photoUrl,
          );

          if (!mounted) return;
          updateCurrentUser(context);
          showUploadMessage(context, 'Imagen subida correctamente!');
        } else {
          throw Exception('Error al subir la imagen');
        }
      } catch (e) {
        setState(() => isDataUploading = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _saveChanges() async {
    _safeUnfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final authProvider =
          Provider.of<NaziShopAuthProvider>(context, listen: false);

      // Actualizar información básica
      final phoneNumber = phoneController!.text.isNotEmpty
          ? '$selectedCountryCode${phoneController!.text}'
          : null;

      await authProvider.updateProfile(
        displayName: nameController!.text,
        photoUrl:
            uploadedFileUrl.isNotEmpty ? uploadedFileUrl : currentUserPhoto,
        phoneNumber: phoneNumber,
      );

      if (!mounted) return;

      updateCurrentUser(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente')),
      );

      if (widget.navigateAction != null) {
        await widget.navigateAction?.call();
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
