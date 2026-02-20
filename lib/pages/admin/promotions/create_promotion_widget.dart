import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import '/backend/admin_service.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '/models/listing_model.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class CreatePromotionWidget extends StatefulWidget {
  final Map<String, dynamic>? promotion;
  const CreatePromotionWidget({super.key, this.promotion});

  @override
  State<CreatePromotionWidget> createState() => _CreatePromotionWidgetState();
}

class _CreatePromotionWidgetState extends State<CreatePromotionWidget> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _finalPriceCtrl = TextEditingController();

  List<Listing> _availableListings = [];
  final List<String> _selectedListingIds = [];
  bool _isLoadingListings = false;
  bool _isSubmitting = false;

  DateTime? _validFrom = DateTime.now();
  DateTime? _validUntil;

  @override
  void initState() {
    super.initState();
    _loadListings();
    if (widget.promotion != null) {
      _initControllers();
    }
  }

  void _initControllers() {
    final p = widget.promotion!;
    _nameCtrl.text = p['name'] ?? '';
    _descCtrl.text = p['description'] ?? '';
    _finalPriceCtrl.text = (p['finalPrice'] ?? 0).toString();

    if (p['validFrom'] != null) {
      _validFrom = DateTime.tryParse(p['validFrom']);
    }
    if (p['validUntil'] != null) {
      _validUntil = DateTime.tryParse(p['validUntil']);
    }

    if (p['listingIds'] != null) {
      _selectedListingIds.addAll(List<String>.from(p['listingIds']));
    }
  }

  Future<void> _loadListings() async {
    setState(() => _isLoadingListings = true);
    try {
      final res = await AdminService.getListings();
      if (mounted) {
        setState(() {
          _availableListings = res;
          _isLoadingListings = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingListings = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _finalPriceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      extendBodyBehindAppBar: true,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: theme.transparent,
              elevation: 0,
              leading: SmartBackButton(color: theme.primaryText),
              centerTitle: true,
              title: Text(
                widget.promotion != null
                    ? 'Editar Promoción'
                    : 'Nueva Promoción',
                style: GoogleFonts.outfit(
                    color: theme.primaryText, fontWeight: FontWeight.bold),
              ),
            ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: isDesktop
                ? const EdgeInsets.fromLTRB(40, 40, 40, 40)
                : EdgeInsets.only(
                    top: kToolbarHeight + 20, bottom: 40, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isDesktop)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      widget.promotion != null
                          ? 'Editar Promoción'
                          : 'Nueva Promoción',
                      style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
// ... (omitting unchanged layout builder parts)
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (isDesktop) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: General & Pricing
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                _buildGeneralInfoCard(),
                                const SizedBox(height: 24),
                                _buildPricingCard(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Right Column: Listings & Actions
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildListingsCard(maxHeight: 500),
                                const SizedBox(height: 24),
                                // Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => context.pop(),
                                      child: Text(
                                        'Cancelar',
                                        style: GoogleFonts.outfit(
                                            color: theme.secondaryText,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    _buildSubmitButton(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Mobile Layout
                      return Column(
                        children: [
                          _buildGeneralInfoCard(),
                          const SizedBox(height: 24),
                          _buildPricingCard(),
                          const SizedBox(height: 24),
                          _buildListingsCard(maxHeight: 300),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => context.pop(),
                                child: Text(
                                  'Cancelar',
                                  style: GoogleFonts.outfit(
                                      color: theme.secondaryText,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 16),
                              _buildSubmitButton(),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralInfoCard() {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información General',
            style: GoogleFonts.outfit(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildInput(_nameCtrl, 'Nombre de la Promo', Icons.campaign_outlined),
          const SizedBox(height: 16),
          _buildInput(
              _descCtrl, 'Descripción (Opcional)', Icons.description_outlined,
              maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Precio y Vigencia',
            style: GoogleFonts.outfit(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _buildInput(
                      _finalPriceCtrl, 'Precio Final', Icons.attach_money,
                      isNumber: true)),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: theme.alternate),
          const SizedBox(height: 10),
          _buildDatePicker(),
        ],
      ),
    );
  }

  Widget _buildListingsCard({double maxHeight = 300}) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Listings Incluidos',
            style: GoogleFonts.outfit(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona los productos que forman parte de esta promoción.',
            style: GoogleFonts.outfit(color: theme.secondaryText, fontSize: 14),
          ),
          const SizedBox(height: 20),
          if (_isLoadingListings)
            Center(child: CircularProgressIndicator(color: theme.primary))
          else
            Container(
              constraints: BoxConstraints(maxHeight: maxHeight),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.alternate),
              ),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: _availableListings.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: theme.alternate),
                itemBuilder: (context, index) {
                  final item = _availableListings[index];
                  final id = item.id;
                  final title = item.title;
                  final originalPrice = item.price;
                  final isSelected = _selectedListingIds.contains(id);

                  return CheckboxListTile(
                    value: isSelected,
                    activeColor: theme.primary,
                    checkColor: theme.info,
                    title: Text(title,
                        style: GoogleFonts.outfit(color: theme.primaryText)),
                    subtitle: Text('\$$originalPrice',
                        style: GoogleFonts.outfit(color: theme.secondaryText)),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedListingIds.add(id);
                        } else {
                          _selectedListingIds.remove(id);
                        }
                      });
                    },
                  );
                },
              ),
            )
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vigencia',
            style:
                GoogleFonts.outfit(color: theme.secondaryText, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: _validFrom ?? DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030));
                  if (date != null) setState(() => _validFrom = date);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.alternate),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: theme.primary, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        _validFrom != null
                            ? DateFormat('dd MMM yyyy').format(_validFrom!)
                            : 'Inicio',
                        style: GoogleFonts.outfit(color: theme.primaryText),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Icon(Icons.arrow_forward, color: theme.secondaryText, size: 16),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: _validUntil ??
                          DateTime.now().add(const Duration(days: 30)),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030));
                  if (date != null) setState(() => _validUntil = date);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.alternate),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.event_busy, color: theme.primary, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        _validUntil != null
                            ? DateFormat('dd MMM yyyy').format(_validUntil!)
                            : 'Fin (Opcional)',
                        style: GoogleFonts.outfit(color: theme.primaryText),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, IconData icon,
      {int maxLines = 1, bool isNumber = false}) {
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
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          style: GoogleFonts.outfit(color: theme.primaryText),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.primaryBackground,
            hintStyle: GoogleFonts.outfit(color: theme.secondaryText),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none), // No border generally
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.primary)),
            prefixIcon:
                maxLines == 1 ? Icon(icon, color: theme.secondaryText) : null,
            contentPadding: maxLines > 1 ? const EdgeInsets.all(16) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary,
            FlutterFlowTheme.of(context).secondary
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
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
                child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).info, strokeWidth: 2))
            : Text(
                widget.promotion != null
                    ? 'Guardar Cambios'
                    : 'Crear Promoción',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).info,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.isEmpty ||
        _finalPriceCtrl.text.isEmpty ||
        _selectedListingIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Nombre, Precio y al menos 1 Listing son obligatorios'),
          backgroundColor: FlutterFlowTheme.of(context).primary));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final finalPrice = double.tryParse(_finalPriceCtrl.text) ?? 0.0;

      final promotionData = {
        'name': _nameCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'finalPrice': finalPrice,
        'listingIds': _selectedListingIds,
        'validFrom': _validFrom?.toIso8601String(),
        'validUntil': _validUntil?.toIso8601String(),
        'isActive': widget.promotion != null
            ? (widget.promotion!['isActive'] ?? true)
            : true,
        'currency': 'USD',
      };

      Map<String, dynamic> res;
      if (widget.promotion != null) {
        promotionData['_id'] = widget.promotion!['_id'];
        res = await AdminService.updatePromotion(promotionData);
      } else {
        res = await AdminService.createPromotion(promotionData);
      }

      if (mounted) {
        if (res.isNotEmpty && (res['_id'] != null || res['status'] == true)) {
          context.pop(true); // Success
        } else {
          throw 'Error al guardar promoción';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $e'),
            backgroundColor: FlutterFlowTheme.of(context).primary));
        setState(() => _isSubmitting = false);
      }
    }
  }
}
