import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import '/backend/admin_service.dart';
import '/models/category_model.dart' as model;
import '/flutter_flow/flutter_flow_theme.dart';
import '../../../components/interactive_color_picker.dart';
import '../../../components/smart_image_input.dart';

class CreateCategoryWidget extends StatefulWidget {
  final model.Category? category;
  const CreateCategoryWidget({super.key, this.category});

  @override
  CreateCategoryWidgetState createState() => CreateCategoryWidgetState();
}

class CreateCategoryWidgetState extends State<CreateCategoryWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _iconCtrl = TextEditingController();

  Color _selectedColor = const Color(0xFF2196F3);
  String _imageUrl = '';
  bool _isActive = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final c = widget.category;
    if (c != null) {
      _nameCtrl.text = c.name;
      _iconCtrl.text = c.ui.icon ?? '';
      _imageUrl = c.ui.imageUrl ?? '';
      _selectedColor = _parseDbColor(c.ui.color ?? '0xff2196f3');
      _isActive = c.isActive;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _iconCtrl.dispose();
    super.dispose();
  }

  Color _parseDbColor(String raw) {
    try {
      final clean =
          raw.replaceAll('#', '').replaceAll('0x', '').replaceAll('0X', '');
      final padded = clean.length == 6 ? 'FF$clean' : clean;
      return Color(int.parse(padded, radix: 16));
    } catch (_) {
      return const Color(0xFF2196F3);
    }
  }

  String _colorToDbString(Color c) {
    final hex = c.value.toRadixString(16).padLeft(8, '0');
    return '0x$hex';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final data = {
      'name': _nameCtrl.text.trim(),
      'isActive': _isActive,
      'ui': {
        'color': _colorToDbString(_selectedColor),
        'icon': _iconCtrl.text.trim(),
        'imageUrl': _imageUrl.trim(),
      }
    };

    try {
      Map<String, dynamic> res;
      if (widget.category != null) {
        data['_id'] = widget.category!.id;
        res = await AdminService.updateCategory(data);
      } else {
        res = await AdminService.createCategory(data);
      }
      if (mounted) {
        if (res['status'] == true || res['_id'] != null) {
          Navigator.pop(context, true);
        } else {
          throw res['msg'] ?? 'Error desconocido';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final title =
        widget.category != null ? 'Editar Categoría' : 'Nueva Categoría';

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      extendBodyBehindAppBar: true,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: SmartBackButton(color: theme.primaryText),
              centerTitle: true,
              title: Text(title,
                  style: GoogleFonts.outfit(
                      color: theme.primaryText, fontWeight: FontWeight.bold)),
            ),
      body: Align(
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
                      top: kToolbarHeight + 24,
                      left: 20,
                      right: 20,
                      bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isDesktop)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Text(title,
                          style: GoogleFonts.outfit(
                              color: theme.tertiary,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                    ),
                  isDesktop
                      ? _buildDesktopLayout(theme)
                      : _buildMobileLayout(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(FlutterFlowTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left — main info
        Expanded(
          flex: 3,
          child: _infoCard(theme),
        ),
        const SizedBox(width: 24),
        // Right — appearance + save
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _appearanceCard(theme),
              const SizedBox(height: 24),
              _visibilityCard(theme),
              const SizedBox(height: 24),
              SizedBox(
                  width: double.infinity, child: _buildSubmitButton(theme)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(FlutterFlowTheme theme) {
    return Column(
      children: [
        _infoCard(theme),
        const SizedBox(height: 20),
        _appearanceCard(theme),
        const SizedBox(height: 20),
        _visibilityCard(theme),
        const SizedBox(height: 28),
        _buildSubmitButton(theme),
      ],
    );
  }

  Widget _infoCard(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información General',
              style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildInput(_nameCtrl, 'NOMBRE', Icons.category),
          const SizedBox(height: 20),
          _buildInput(
              _iconCtrl, 'ICONO (nombre Material)', Icons.insert_emoticon,
              required: false),
        ],
      ),
    );
  }

  Widget _appearanceCard(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Apariencia',
              style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          // Color — compact trigger → floating picker
          InteractiveColorPicker(
            label: 'COLOR',
            initialColor: _selectedColor,
            onColorChanged: (c) => setState(() => _selectedColor = c),
          ),

          const SizedBox(height: 20),

          // Image — URL + file picker
          SmartImageInput(
            label: 'IMAGEN',
            initialUrl: _imageUrl,
            onUrlChanged: (url) => setState(() => _imageUrl = url),
          ),
        ],
      ),
    );
  }

  Widget _visibilityCard(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.alternate),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        activeColor: theme.primary,
        title: Text('Categoría Activa',
            style: GoogleFonts.outfit(color: theme.primaryText)),
        subtitle: Text('Visible en el catálogo',
            style:
                GoogleFonts.outfit(color: theme.secondaryText, fontSize: 12)),
        value: _isActive,
        onChanged: (v) => setState(() => _isActive = v),
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, IconData icon,
      {bool required = true, int maxLines = 1}) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.outfit(
                color: theme.secondaryText,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          style: GoogleFonts.outfit(color: theme.primaryText),
          validator: required
              ? (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.primaryBackground,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.primary)),
            prefixIcon: Icon(icon, color: theme.secondaryText),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(FlutterFlowTheme theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primary, theme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: _isSubmitting ? null : _submit,
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Text(
                widget.category != null ? 'Guardar Cambios' : 'Crear Categoría',
                style: GoogleFonts.outfit(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
