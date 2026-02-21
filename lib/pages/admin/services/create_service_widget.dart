import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import '/backend/admin_service.dart';
import '/models/service_model.dart';
import '/models/category_model.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../../components/interactive_color_picker.dart';
import '../../../components/smart_image_input.dart';
import '/components/loading_indicator.dart';

class CreateServiceWidget extends StatefulWidget {
  final Service? service;
  const CreateServiceWidget({super.key, this.service});

  @override
  CreateServiceWidgetState createState() => CreateServiceWidgetState();
}

class CreateServiceWidgetState extends State<CreateServiceWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _platformCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _regionCtrl = TextEditingController();
  final _deviceLimitCtrl = TextEditingController();

  Color _primaryColor = const Color(0xFF2196F3);
  Color _secondaryColor = const Color(0xFF90CAF9);
  String _logoUrl = '';
  String _bannerUrl = '';

  String? _selectedCategoryId;
  String? _selectedCategoryName;
  List<Category> _categories = [];
  bool _isLoadingCats = false;
  bool _isActive = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    final s = widget.service;
    if (s != null) {
      _nameCtrl.text = s.name;
      _platformCtrl.text = s.technicalInfo?.platform ?? '';
      _websiteCtrl.text = s.technicalInfo?.website ?? '';
      _regionCtrl.text = s.technicalInfo?.region ?? 'GLOBAL';
      _deviceLimitCtrl.text = s.technicalInfo?.deviceLimit?.toString() ?? '1';
      _logoUrl = s.branding.logoUrl ?? '';
      _bannerUrl = s.branding.bannerUrl ?? '';
      _primaryColor = _parseDbColor(s.branding.primaryColor ?? '0xff2196f3');
      _secondaryColor =
          _parseDbColor(s.branding.secondaryColor ?? '0xff90caf9');
      _selectedCategoryId = s.categoryId.isNotEmpty ? s.categoryId : null;
      _isActive = s.isActive;
    }
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoadingCats = true);
    try {
      final data = await AdminService.getCategories();
      if (mounted) {
        setState(() {
          _categories = data;
          _isLoadingCats = false;
          if (_selectedCategoryId != null) {
            try {
              final match =
                  _categories.firstWhere((c) => c.id == _selectedCategoryId);
              _selectedCategoryName = match.name;
            } catch (_) {}
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingCats = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _platformCtrl.dispose();
    _websiteCtrl.dispose();
    _regionCtrl.dispose();
    _deviceLimitCtrl.dispose();
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
    return '0x${c.value.toRadixString(16).padLeft(8, '0')}';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona una categoría')));
      return;
    }
    setState(() => _isSubmitting = true);

    final data = {
      'name': _nameCtrl.text.trim(),
      'categoryId': _selectedCategoryId,
      'isActive': _isActive,
      'branding': {
        'primaryColor': _colorToDbString(_primaryColor),
        'secondaryColor': _colorToDbString(_secondaryColor),
        'logoUrl': _logoUrl.trim(),
        'bannerUrl': _bannerUrl.trim(),
      },
      'technicalInfo': {
        'platform': _platformCtrl.text.trim(),
        'website': _websiteCtrl.text.trim(),
        'region': _regionCtrl.text.trim(),
        'deviceLimit': int.tryParse(_deviceLimitCtrl.text) ?? 1,
      }
    };

    try {
      Map<String, dynamic> res;
      if (widget.service != null) {
        data['_id'] = widget.service!.id;
        res = await AdminService.updateService(data);
      } else {
        res = await AdminService.createService(data);
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
    final title = widget.service != null ? 'Editar Servicio' : 'Nuevo Servicio';

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
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _infoCard(theme),
              const SizedBox(height: 24),
              _techCard(theme),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _brandingCard(theme),
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
        _techCard(theme),
        const SizedBox(height: 20),
        _brandingCard(theme),
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
          Text('Datos Principales',
              style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildInput(_nameCtrl, 'NOMBRE DEL SERVICIO', Icons.layers),
          const SizedBox(height: 20),
          _buildCategoryAutocomplete(theme),
        ],
      ),
    );
  }

  Widget _techCard(FlutterFlowTheme theme) {
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
          Text('Información Técnica',
              style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildInput(
              _platformCtrl, 'PLATAFORMAS (Ej: Web, App)', Icons.devices),
          const SizedBox(height: 20),
          _buildInput(_websiteCtrl, 'SITIO WEB OFICIAL', Icons.language),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildInput(_regionCtrl, 'REGIÓN', Icons.public)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInput(
                    _deviceLimitCtrl, 'LÍM. DISP.', Icons.screen_lock_portrait,
                    isNumber: true, required: false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _brandingCard(FlutterFlowTheme theme) {
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
          Text('Branding',
              style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SmartImageInput(
            label: 'LOGO',
            initialUrl: _logoUrl,
            onUrlChanged: (url) => setState(() => _logoUrl = url),
          ),
          const SizedBox(height: 20),
          SmartImageInput(
            label: 'BANNER',
            initialUrl: _bannerUrl,
            onUrlChanged: (url) => setState(() => _bannerUrl = url),
          ),
          const SizedBox(height: 20),
          InteractiveColorPicker(
            label: 'COLOR PRIMARIO',
            initialColor: _primaryColor,
            onColorChanged: (c) => setState(() => _primaryColor = c),
          ),
          const SizedBox(height: 20),
          InteractiveColorPicker(
            label: 'COLOR SECUNDARIO',
            initialColor: _secondaryColor,
            onColorChanged: (c) => setState(() => _secondaryColor = c),
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
        title: Text('Servicio Activo',
            style: GoogleFonts.outfit(color: theme.primaryText)),
        subtitle: Text('Habilitar en la plataforma',
            style:
                GoogleFonts.outfit(color: theme.secondaryText, fontSize: 12)),
        value: _isActive,
        onChanged: (v) => setState(() => _isActive = v),
      ),
    );
  }

  Widget _buildCategoryAutocomplete(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CATEGORÍA',
            style: GoogleFonts.outfit(
                color: theme.secondaryText,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Autocomplete<Category>(
          initialValue: TextEditingValue(text: _selectedCategoryName ?? ''),
          optionsBuilder: (tv) {
            if (tv.text.isEmpty) return _categories;
            return _categories.where(
                (c) => c.name.toLowerCase().contains(tv.text.toLowerCase()));
          },
          displayStringForOption: (c) => c.name,
          onSelected: (c) => setState(() {
            _selectedCategoryId = c.id;
            _selectedCategoryName = c.name;
          }),
          fieldViewBuilder: (ctx, ctrl, focusNode, _) => TextFormField(
            controller: ctrl,
            focusNode: focusNode,
            style: GoogleFonts.outfit(color: theme.primaryText),
            validator: (_) => _selectedCategoryId == null ? 'Requerido' : null,
            decoration: InputDecoration(
              hintText: _isLoadingCats ? 'Cargando...' : 'Buscar categoría...',
              hintStyle: GoogleFonts.outfit(color: theme.secondaryText),
              prefixIcon: Icon(Icons.category, color: theme.secondaryText),
              suffixIcon: _isLoadingCats
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                          width: 16,
                          height: 16,
                          child:
                              LoadingIndicator(size: 16, color: theme.primary)))
                  : null,
              filled: true,
              fillColor: theme.primaryBackground,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primary)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.error)),
            ),
          ),
          optionsViewBuilder: (ctx, onSel, opts) {
            final t = FlutterFlowTheme.of(ctx);
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 220),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: t.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: t.alternate),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    shrinkWrap: true,
                    itemCount: opts.length,
                    itemBuilder: (_, i) {
                      final cat = opts.elementAt(i);
                      return InkWell(
                        onTap: () => onSel(cat),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(cat.name,
                              style: GoogleFonts.outfit(color: t.primaryText)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, IconData icon,
      {bool required = true, bool isNumber = false, int maxLines = 1}) {
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
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
              offset: const Offset(0, 4))
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
            ? SizedBox(
                width: 20,
                height: 20,
                child: LoadingIndicator(color: Colors.white, size: 20))
            : Text(
                widget.service != null ? 'Guardar Cambios' : 'Crear Servicio',
                style: GoogleFonts.outfit(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
