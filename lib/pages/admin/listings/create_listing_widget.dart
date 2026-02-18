import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/offer_model.dart';
import 'package:nazi_shop/models/service_model.dart';
import '../../../components/smart_back_button.dart';

class CreateListingWidget extends StatefulWidget {
  final Offer? offer;
  const CreateListingWidget({super.key, this.offer});

  static const String routeName = 'create_listing';

  @override
  State<CreateListingWidget> createState() => _CreateListingWidgetState();
}

class _CreateListingWidgetState extends State<CreateListingWidget> {
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLLERS ---
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;

  // Pricing
  late TextEditingController _priceOriginalCtrl;

  // Metadata (Optional)
  late TextEditingController _durationCtrl; // Free text or number
  late TextEditingController _planCtrl;
  late TextEditingController _badgeCtrl;

  // New Commercial Fields
  late TextEditingController _warrantyCtrl;
  late TextEditingController _rulesCtrl;
  bool _isRenewable = false;

  // New Domain Fields
  String? _domainType;
  late TextEditingController _domainStockCtrl;

  String? _selectedServiceId;
  String? _selectedDeliveryType;

  List<Service> _services = [];
  bool _isLoadingServices = false;
  bool _isSaving = false;
  bool _isActive = true;

  // Delivery Types based on schema
  final List<Map<String, String>> _deliveryTypes = [
    {'value': 'full_account', 'label': 'Cuenta Completa'},
    {'value': 'profile_access', 'label': 'Acceso a Perfil'},
    {'value': 'license_key', 'label': 'Licencia / Key'},
    {'value': 'payment_method', 'label': 'Método de Pago'},
    {'value': 'access_code', 'label': 'Código de Acceso'},
    {'value': 'subscription_access', 'label': 'Suscripción'},
    {'value': 'domain', 'label': 'Dominio / Personalizado'},
  ];

  final List<Map<String, String>> _domainTypes = [
    {'value': 'own_domain', 'label': 'Dominio Propio (Cliente)'},
    {'value': 'internal_account', 'label': 'Cuenta Interna (Stock)'},
  ];

  @override
  void initState() {
    super.initState();
    _loadServices();
    _initControllers();
  }

  void _initControllers() {
    final o = widget.offer;

    _titleCtrl = TextEditingController(text: o?.title ?? '');
    _descCtrl = TextEditingController(text: o?.description ?? '');

    // Pricing logic: only Base Price
    double original = o?.originalPrice ?? (o?.pricing.amount ?? 0);
    if (o == null) original = 0;

    _priceOriginalCtrl =
        TextEditingController(text: original > 0 ? original.toString() : '');

    _durationCtrl =
        TextEditingController(text: o?.commercial.duration?.toString() ?? '');
    _planCtrl = TextEditingController(text: o?.commercial.plan ?? '');
    _badgeCtrl = TextEditingController(text: o?.ui.badge ?? '');

    _warrantyCtrl =
        TextEditingController(text: o?.commercial.warrantyPeriod ?? '');
    // Convert rules list to multiline string
    final rulesText = (o?.usageRules ?? []).map((r) => r.title).join('\n');
    _rulesCtrl = TextEditingController(text: rulesText);
    _isRenewable = o?.commercial.isRenewable ?? false;

    final sId = o?.serviceId;
    _selectedServiceId = (sId != null && sId.isNotEmpty) ? sId : null;
    _selectedDeliveryType = o?.dataDeliveryType ?? 'full_account';

    // Domain fields
    _domainType = o?.domainType;
    _domainStockCtrl =
        TextEditingController(text: o?.domainStock?.toString() ?? '');

    _isActive = o?.isActive ?? true;
  }

  Future<void> _loadServices() async {
    setState(() => _isLoadingServices = true);
    try {
      final data = await AdminService.getServices();
      if (mounted) {
        setState(() {
          _services = data.map((d) => Service.fromJson(d)).toList();
          _isLoadingServices = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingServices = false);
    }
  }

  @override
  void dispose() {
    _warrantyCtrl.dispose();
    _rulesCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceOriginalCtrl.dispose();
    _durationCtrl.dispose();
    _planCtrl.dispose();
    _badgeCtrl.dispose();
    _domainStockCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedServiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar un servicio/marca')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Find category linkage
      final service = _services.firstWhere((s) => s.id == _selectedServiceId);

      // Parse Rules
      final rules = _rulesCtrl.text
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .map((line) => {
                'title': line.trim(),
                'description': '',
                'isCritical': true, // Default to critical for quick entry
                'icon': 'security'
              })
          .toList();

      // Map to Listing Model (Strict Price)
      final price = double.tryParse(_priceOriginalCtrl.text) ?? 0;

      final data = {
        'title': _titleCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'serviceId': _selectedServiceId,
        'categoryId': service.categoryId,
        'dataDeliveryType': _selectedDeliveryType,
        'isActive': _isActive,
        'price': price,
        'currency': 'USD',
        'commercial': {
          'plan': _planCtrl.text.trim(),
          'duration': int.tryParse(_durationCtrl.text),
          'timeUnit': 'days',
          'warrantyPeriod': _warrantyCtrl.text.trim(),
          'isRenewable': _isRenewable,
        },
        'usageRules': rules,
        'ui': {
          'badge': _badgeCtrl.text.trim(),
          'highlight': widget.offer?.isFeatured ?? false
        }
      };

      // Add domain specific fields
      if (_selectedDeliveryType == 'domain') {
        data['domainType'] = _domainType;
        if (_domainType == 'own_domain') {
          data['domainStock'] = int.tryParse(_domainStockCtrl.text) ?? 0;
          // Own domain doesn't rely on standard inventory stock, but passing availableStock helps list view
          data['availableStock'] = int.tryParse(_domainStockCtrl.text) ?? 0;
        }
      }

      if (widget.offer != null) {
        data['_id'] = widget.offer!.id;
        final res = await AdminService.updateListing(data);
        if (res['status'] != true) throw res['msg'];
      } else {
        final res = await AdminService.createListing(data);
        if (res['status'] != true) throw res['msg'];
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: FlutterFlowTheme.of(context).error,
              content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    // Content for the form
    final content = Column(
      children: [
        if (isDesktop)
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.offer != null ? 'Editar Oferta' : 'Nueva Oferta',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Configura el producto digital a vender',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 16),
                    ),
                  ],
                ),
                const Spacer(),
                _buildSaveButton(FlutterFlowTheme.of(context).primary),
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
                        FlutterFlowTheme.of(context).secondaryBackground)),
                const SizedBox(width: 24),
                Expanded(
                    flex: 1,
                    child: _buildSideColumn(
                        FlutterFlowTheme.of(context).secondaryBackground,
                        FlutterFlowTheme.of(context).primary)),
              ],
            );
          } else {
            return Column(
              children: [
                _buildMainColumn(
                    FlutterFlowTheme.of(context).secondaryBackground),
                const SizedBox(height: 24),
                _buildSideColumn(
                    FlutterFlowTheme.of(context).secondaryBackground,
                    FlutterFlowTheme.of(context).primary),
                if (!isDesktop) ...[
                  const SizedBox(height: 32),
                  _buildSaveButton(FlutterFlowTheme.of(context).primary),
                ]
              ],
            );
          }
        }),
      ],
    );

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      // No appbar property
      body: Stack(
        children: [
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
                child: isDesktop
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(40),
                        child: content,
                      )
                    : CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverAppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            pinned: true,
                            floating: true,
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SmartBackButton(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText),
                            ),
                            centerTitle: true,
                            title: Text(
                              widget.offer != null
                                  ? 'Editar Oferta'
                                  : 'Nueva Oferta',
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
          )
        ],
      ),
    );
  }

  Widget _buildSaveButton(Color color) {
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
            : const Icon(Icons.check),
        label: Text(_isSaving ? 'Guardando...' : 'Publicar Oferta'),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: FlutterFlowTheme.of(context).info,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildMainColumn(Color kSurfaceColor) {
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
              Text('Información de la Oferta',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _buildInput(_titleCtrl, 'Título de la Oferta', Icons.title),
              const SizedBox(height: 16),
              if (_isLoadingServices)
                Center(
                    child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primary))
              else
                DropdownButtonFormField<String>(
                  initialValue: _selectedServiceId,
                  dropdownColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText),
                  decoration: _inputDeco('Servicio / Plataforma', Icons.layers),
                  items: _services
                      .map((s) => DropdownMenuItem(
                            value: s.id,
                            child: Text(s.name),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedServiceId = v),
                ),
              const SizedBox(height: 16),
              _buildInput(_descCtrl, 'Descripción detallada', Icons.description,
                  maxLines: 4),
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
              Text('Reglas de Uso (Una por línea)',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildInput(_rulesCtrl,
                  'Ej: No cambiar contraseña\nEj: Solo 1 perfil', Icons.gavel,
                  maxLines: 5),
            ],
          ),
        )
      ],
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
              Text('Precio y Comercial',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildInput(_priceOriginalCtrl, 'Precio', null,
                        keyboardType: TextInputType.number, prefixText: '\$'),
                  ),
                  const SizedBox(width: 12),
                  Text('USD',
                      style: TextStyle(
                          color: FlutterFlowTheme.of(context).secondaryText)),
                ],
              ),
              const SizedBox(height: 16),
              _buildInput(_planCtrl, 'Nombre del Plan (Ej: Premium 4K)',
                  Icons.card_membership),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInput(_durationCtrl, 'Duración', Icons.timer,
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 8),
                  Text('días',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText))
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: kPrimaryColor,
                title: Text('¿Es renovable?',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText)),
                value: _isRenewable,
                onChanged: (v) => setState(() => _isRenewable = v),
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
            border: Border.all(color: FlutterFlowTheme.of(context).alternate),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Entrega y Estado',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: _selectedDeliveryType,
                dropdownColor: const Color(0xFF1F1F1F),
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText),
                decoration: _inputDeco('Tipo de Entrega', Icons.inventory_2),
                items: _deliveryTypes
                    .map((d) => DropdownMenuItem(
                          value: d['value'],
                          child: Text(d['label']!),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedDeliveryType = v),
              ),

              // New Domain Options
              if (_selectedDeliveryType == 'domain') ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _domainType,
                  dropdownColor: const Color(0xFF1F1F1F),
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText),
                  decoration: _inputDeco('Tipo de Dominio', Icons.dns),
                  items: _domainTypes
                      .map((d) => DropdownMenuItem(
                            value: d['value'],
                            child: Text(d['label']!),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _domainType = v),
                  validator: (v) {
                    if (_selectedDeliveryType == 'domain' && v == null) {
                      return 'Requerido';
                    }
                    return null;
                  },
                ),
                if (_domainType == 'own_domain') ...[
                  const SizedBox(height: 16),
                  _buildInput(
                      _domainStockCtrl, 'Stock Disponible', Icons.warehouse,
                      keyboardType: TextInputType.number,
                      isNumber: true,
                      hint: 'Slots disponibles'),
                ]
              ],

              const SizedBox(height: 16),
              _buildInput(_badgeCtrl, 'Badge (Ej: HOT)', Icons.label),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: kPrimaryColor,
                title: Text('Oferta Activa',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText)),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: FlutterFlowTheme.of(context).warning,
                title: Text('Destacado',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText)),
                value: widget.offer?.isFeatured ?? false,
                onChanged:
                    (v) {}, // Not wired in controller for now, just visual
              ),
            ],
          ),
        )
      ],
    );
  }

  InputDecoration _inputDeco(String label, IconData? icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
      prefixIcon: icon != null
          ? Icon(icon, color: FlutterFlowTheme.of(context).secondaryText)
          : null,
      filled: true,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, IconData? icon,
      {bool isNumber = false,
      int maxLines = 1,
      String? hint,
      TextInputType? keyboardType,
      String? prefixText}) {
    // Merge keyboardType logic
    final kt =
        keyboardType ?? (isNumber ? TextInputType.number : TextInputType.text);

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: kt,
        style:
            GoogleFonts.outfit(color: FlutterFlowTheme.of(context).primaryText),
        cursorColor: FlutterFlowTheme.of(context).primary,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: prefixText,
          prefixStyle: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText),
          labelStyle: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText),
          hintStyle: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText),
          prefixIcon: icon != null
              ? Icon(icon, color: FlutterFlowTheme.of(context).secondaryText)
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (v) {
          if (!isNumber && (v == null || v.isEmpty)) return 'Requerido';
          return null;
        },
      ),
    );
  }
}
