import 'package:flutter/material.dart';
import 'dart:ui'; // Add for ImageFilter
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/category_model.dart'
    as model; // Alias for UI class
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';

class CreateCategoryWidget extends StatefulWidget {
  final model.Category? category; // If provided, edit mode

  const CreateCategoryWidget({super.key, this.category});

  @override
  CreateCategoryWidgetState createState() => CreateCategoryWidgetState();
}

class CreateCategoryWidgetState extends State<CreateCategoryWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _codeCtrl;
  late TextEditingController _colorCtrl;
  late TextEditingController _iconCtrl;
  late TextEditingController _imageUrlCtrl;

  bool _isActive = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.category;
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _codeCtrl = TextEditingController(text: c?.code ?? '');
    _colorCtrl = TextEditingController(text: c?.ui.color ?? '0xff2196f3');
    _iconCtrl = TextEditingController(text: c?.ui.icon ?? 'category');
    _imageUrlCtrl = TextEditingController(text: c?.ui.imageUrl ?? '');
    _isActive = c?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _colorCtrl.dispose();
    _iconCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final data = {
      'name': _nameCtrl.text.trim(),
      'code': _codeCtrl.text.trim(),
      'isActive': _isActive,
      'ui': {
        'color': _colorCtrl.text.trim(),
        'icon': _iconCtrl.text.trim(),
        'imageUrl': _imageUrlCtrl.text.trim(),
      }
    };

    try {
      if (widget.category != null) {
        // Update
        data['_id'] = widget.category!.id;
        final res = await AdminService.updateCategory(data);
        if (res['status'] != true) throw res['msg'];
      } else {
        // Create
        final res = await AdminService.createCategory(data);
        if (res['status'] != true) throw res['msg'];
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      extendBodyBehindAppBar: true,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: FlutterFlowTheme.of(context).transparent,
              elevation: 0,
              leading: SmartBackButton(
                  color: FlutterFlowTheme.of(context).primaryText),
              centerTitle: true,
              title: Text(
                widget.category != null
                    ? 'Editar Categoría'
                    : 'Nueva Categoría',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.bold),
              ),
            ),
      body: Stack(
        children: [
          // Background Gradient (Same as MyPurchases)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: FlutterFlowTheme.of(context)
                    .primary
                    .withValues(alpha: 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child:
                    Container(color: FlutterFlowTheme.of(context).transparent),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1600),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: isDesktop
                        ? const EdgeInsets.fromLTRB(40, 40, 40, 40)
                        : EdgeInsets.only(
                            top: kToolbarHeight + 20,
                            bottom: 40,
                            left: 20,
                            right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isDesktop)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Row(
                              children: [
                                Text(
                                  widget.category != null
                                      ? 'Editar Categoría'
                                      : 'Nueva Categoría',
                                  style: GoogleFonts.outfit(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                _buildSaveButton(
                                    FlutterFlowTheme.of(context).primary),
                              ],
                            ),
                          ),
                        LayoutBuilder(builder: (context, constraints) {
                          if (constraints.maxWidth >= 900) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: _buildMainColumn(
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground)),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 1,
                                    child: _buildSideColumn(
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        FlutterFlowTheme.of(context).primary)),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                _buildMainColumn(FlutterFlowTheme.of(context)
                                    .secondaryBackground),
                                const SizedBox(height: 24),
                                _buildSideColumn(
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    FlutterFlowTheme.of(context).primary),
                                if (!isDesktop) ...[
                                  const SizedBox(height: 32),
                                  _buildSaveButton(
                                      FlutterFlowTheme.of(context).primary),
                                ],
                              ],
                            );
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMainColumn(Color kSurfaceColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kSurfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información General',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildInput(_nameCtrl, 'Nombre de la Categoría', Icons.category),
          const SizedBox(height: 16),
          _buildInput(_codeCtrl, 'Código Único (Slug)', Icons.code),
        ],
      ),
    );
  }

  Widget _buildSideColumn(Color kSurfaceColor, Color kPrimaryColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kSurfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: FlutterFlowTheme.of(context).alternate),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Apariencia',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                      child: _buildInput(_colorCtrl, 'Color (Hex)',
                          Icons.color_lens_outlined)),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _colorFromHex(_colorCtrl.text),
                      border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              _buildInput(_iconCtrl, 'Nombre de Icono', Icons.insert_emoticon),
              const SizedBox(height: 16),
              _buildInput(_imageUrlCtrl, 'URL de Imagen', Icons.image_outlined),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kSurfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: FlutterFlowTheme.of(context).alternate),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Visibilidad',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SwitchListTile(
                activeThumbColor: FlutterFlowTheme.of(context).primary,
                contentPadding: EdgeInsets.zero,
                title: Text('Categoría Activa',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText)),
                subtitle: Text('Visible en el catálogo',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12)),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(Color kPrimaryColor) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _isSaving ? null : _save,
        icon: _isSaving
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: FlutterFlowTheme.of(context).info))
            : Icon(Icons.check, color: FlutterFlowTheme.of(context).info),
        label: Text(_isSaving ? 'Guardando...' : 'Guardar Datos'),
        style: ElevatedButton.styleFrom(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          foregroundColor: FlutterFlowTheme.of(context).info,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    try {
      return Color(int.parse(hexColor, radix: 16));
    } catch (_) {
      return FlutterFlowTheme.of(context).transparent;
    }
  }

  Widget _buildInput(TextEditingController ctrl, String label, IconData icon) {
    final kBgColor = FlutterFlowTheme.of(context).primaryBackground;
    final kPrimaryColor = FlutterFlowTheme.of(context).primary;
    final kErrorColor = FlutterFlowTheme.of(context).error;

    return TextFormField(
      controller: ctrl,
      style:
          GoogleFonts.outfit(color: FlutterFlowTheme.of(context).primaryText),
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).secondaryText),
        prefixIcon:
            Icon(icon, color: FlutterFlowTheme.of(context).secondaryText),
        filled: true,
        fillColor: kBgColor,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: FlutterFlowTheme.of(context).alternate)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kPrimaryColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kErrorColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kErrorColor)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
    );
  }
}
