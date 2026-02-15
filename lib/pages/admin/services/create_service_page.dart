import 'package:flutter/material.dart';
import 'dart:ui'; // Add for ImageFilter
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/service_model.dart';
import 'package:nazi_shop/models/category_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';

class CreateServicePage extends StatefulWidget {
  final Service? service;

  const CreateServicePage({super.key, this.service});

  @override
  _CreateServicePageState createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _codeCtrl;
  late TextEditingController _primaryColorCtrl;
  late TextEditingController _secondaryColorCtrl;
  late TextEditingController _logoUrlCtrl;
  late TextEditingController _bannerUrlCtrl;

  // Technical Info
  late TextEditingController _platformCtrl;
  late TextEditingController _websiteCtrl;
  late TextEditingController _regionCtrl;
  late TextEditingController _deviceLimitCtrl;

  String? _selectedCategoryId;
  List<Category> _categories = [];
  bool _isLoadingCats = false;

  bool _isActive = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    final s = widget.service;
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _codeCtrl = TextEditingController(text: s?.code ?? '');
    _primaryColorCtrl =
        TextEditingController(text: s?.branding.primaryColor ?? '0xff2196f3');
    _secondaryColorCtrl =
        TextEditingController(text: s?.branding.secondaryColor ?? '0xff90caf9');
    _logoUrlCtrl = TextEditingController(text: s?.branding.logoUrl ?? '');
    _bannerUrlCtrl = TextEditingController(text: s?.branding.bannerUrl ?? '');

    _platformCtrl =
        TextEditingController(text: s?.technicalInfo?.platform ?? '');
    _websiteCtrl = TextEditingController(text: s?.technicalInfo?.website ?? '');
    _regionCtrl =
        TextEditingController(text: s?.technicalInfo?.region ?? 'GLOBAL');
    _deviceLimitCtrl = TextEditingController(
        text: s?.technicalInfo?.deviceLimit?.toString() ?? '1');

    _selectedCategoryId = s?.categoryId is String
        ? s?.categoryId
        : null; // Handle if populated or not
    if (_selectedCategoryId != null && _selectedCategoryId!.isEmpty) {
      _selectedCategoryId = null;
    }

    _isActive = s?.isActive ?? true;
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoadingCats = true);
    try {
      final data = await AdminService.getCategories();
      setState(() {
        _categories = data.map((d) => Category.fromJson(d)).toList();
        _isLoadingCats = false;

        // If editing and categoryId was likely populated object, try to match
        if (widget.service != null && _selectedCategoryId == null) {
          // Fallback if the ID was inside a populated object which our basic model might strictly type or map differently
          // But since Model logic maps `categoryId` to string if possible, we should be good.
        }
      });
    } catch (e) {
      if (mounted) setState(() => _isLoadingCats = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _primaryColorCtrl.dispose();
    _secondaryColorCtrl.dispose();
    _logoUrlCtrl.dispose();
    _bannerUrlCtrl.dispose();
    _platformCtrl.dispose();
    _websiteCtrl.dispose();
    _regionCtrl.dispose();
    _deviceLimitCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final data = {
      'name': _nameCtrl.text.trim(),
      'code': _codeCtrl.text.trim(),
      'categoryId': _selectedCategoryId,
      'isActive': _isActive,
      'branding': {
        'primaryColor': _primaryColorCtrl.text.trim(),
        'secondaryColor': _secondaryColorCtrl.text.trim(),
        'logoUrl': _logoUrlCtrl.text.trim(),
        'bannerUrl': _bannerUrlCtrl.text.trim(),
      },
      'technicalInfo': {
        'platform': _platformCtrl.text.trim(),
        'website': _websiteCtrl.text.trim(),
        'region': _regionCtrl.text.trim(),
        'deviceLimit': int.tryParse(_deviceLimitCtrl.text) ?? 1,
      }
    };

    try {
      if (widget.service != null) {
        data['_id'] = widget.service!.id;
        final res = await AdminService.updateService(data);
        if (res['status'] != true) throw res['msg'];
      } else {
        final res = await AdminService.createService(data);
        if (res['status'] != true) throw res['msg'];
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kBgColor = FlutterFlowTheme.of(context).primaryBackground;
    final kSurfaceColor = FlutterFlowTheme.of(context).secondaryBackground;
    final kPrimaryColor = FlutterFlowTheme.of(context).primary;

    final isDesktop = MediaQuery.of(context).size.width >= 900;

    // Content for the form
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isDesktop)
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              children: [
                Text(
                  widget.service != null ? 'Editar Servicio' : 'Nuevo Servicio',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                _buildSaveButton(kPrimaryColor),
              ],
            ),
          ),
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildMainColumn(kSurfaceColor)),
                const SizedBox(width: 24),
                Expanded(
                    flex: 1,
                    child: _buildSideColumn(kSurfaceColor, kPrimaryColor)),
              ],
            );
          } else {
            return Column(
              children: [
                _buildMainColumn(kSurfaceColor),
                const SizedBox(height: 24),
                _buildSideColumn(kSurfaceColor, kPrimaryColor),
                if (!isDesktop) ...[
                  const SizedBox(height: 32),
                  _buildSaveButton(kPrimaryColor),
                ]
              ],
            );
          }
        }),
      ],
    );

    return Scaffold(
      backgroundColor: kBgColor,
      // No appbar property, handled in body
      body: Stack(
        children: [
          // Background Gradient
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor.withOpacity(0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: Form(
                key: _formKey,
                child: isDesktop
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(40),
                        physics: const BouncingScrollPhysics(),
                        child: content,
                      )
                    : CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverAppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            floating: true,
                            pinned: true,
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SmartBackButton(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText),
                            ),
                            centerTitle: true,
                            title: Text(
                              widget.service != null
                                  ? 'Editar Servicio'
                                  : 'Nuevo Servicio',
                              style: GoogleFonts.outfit(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                            sliver: SliverToBoxAdapter(child: content),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
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
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white)))
            : const Icon(Icons.check),
        label: Text(_isSaving ? 'Guardando...' : 'Guardar Servicio'),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildMainColumn(Color kSurfaceColor) {
    final borderColor = FlutterFlowTheme.of(context).alternate;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kSurfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Datos Principales',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildInput(_nameCtrl, 'Nombre del Servicio', Icons.layers),
              const SizedBox(height: 16),
              _buildInput(_codeCtrl, 'Código (Slug)', Icons.code),
              const SizedBox(height: 16),
              if (_isLoadingCats)
                Center(
                    child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primary))
              else
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategoryId,
                  dropdownColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText),
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    labelStyle: TextStyle(
                        color: FlutterFlowTheme.of(context).secondaryText),
                    prefixIcon: Icon(Icons.category,
                        color: FlutterFlowTheme.of(context).secondaryText),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor)),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCategoryId = v),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kSurfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Información Técnica',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildInput(
                  _platformCtrl, 'Plataformas (Ej: Web, App)', Icons.devices),
              const SizedBox(height: 16),
              _buildInput(_websiteCtrl, 'Website Oficial', Icons.language),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: _buildInput(_regionCtrl, 'Región', Icons.public)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInput(_deviceLimitCtrl, 'Límite Disp.',
                        Icons.screen_lock_portrait,
                        isNumber: true),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSideColumn(Color kSurfaceColor, Color kPrimaryColor) {
    final borderColor = FlutterFlowTheme.of(context).alternate;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kSurfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Branding',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildInput(_logoUrlCtrl, 'Logo URL', Icons.image),
              const SizedBox(height: 16),
              _buildInput(
                  _bannerUrlCtrl, 'Banner URL', Icons.image_aspect_ratio),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: _buildInput(_primaryColorCtrl, 'Color Primario',
                          Icons.color_lens)),
                  const SizedBox(width: 10),
                  _colorBox(_primaryColorCtrl.text),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: _buildInput(_secondaryColorCtrl,
                          'Color Secundario', Icons.color_lens_outlined)),
                  const SizedBox(width: 10),
                  _colorBox(_secondaryColorCtrl.text),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kSurfaceColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
            ),
            child: colStatus(kPrimaryColor))
      ],
    );
  }

  Widget colStatus(Color kPrimaryColor) {
    return SwitchListTile(
      activeThumbColor: kPrimaryColor,
      contentPadding: EdgeInsets.zero,
      title: Text('Servicio Activo',
          style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText)),
      subtitle: Text('Habilitar en la plataforma',
          style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText, fontSize: 12)),
      value: _isActive,
      onChanged: (v) => setState(() => _isActive = v),
    );
  }

  Widget _colorBox(String hex) {
    Color c = Colors.transparent;
    hex = hex.toUpperCase().replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    try {
      c = Color(int.parse(hex, radix: 16));
    } catch (_) {}
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: c,
          border: Border.all(color: FlutterFlowTheme.of(context).alternate),
          borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, IconData icon,
      {bool isNumber = false}) {
    Color kBgColor = FlutterFlowTheme.of(context).primaryBackground;
    Color kPrimaryColor = FlutterFlowTheme.of(context).primary;

    return Container(
      decoration: BoxDecoration(
        color: kBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: TextFormField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style:
            GoogleFonts.outfit(color: FlutterFlowTheme.of(context).primaryText),
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText),
          prefixIcon:
              Icon(icon, color: FlutterFlowTheme.of(context).secondaryText),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (v) {
          if (!isNumber && (v == null || v.isEmpty)) {
            return 'Requerido'; // Basic validation
          }
          return null;
        },
      ),
    );
  }
}
