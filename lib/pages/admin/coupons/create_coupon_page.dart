import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class CreateCouponPage extends StatefulWidget {
  final Map<String, dynamic>? coupon;
  const CreateCouponPage({super.key, this.coupon});

  @override
  State<CreateCouponPage> createState() => _CreateCouponPageState();
}

class _CreateCouponPageState extends State<CreateCouponPage> {
  // Styles
  static const Color kBgColor = Color(0xFF050505);
  static const Color kSurfaceColor = Color(0xFF141414);
  static const Color kPrimaryColor = Color(0xFFE50914);

  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _limitCtrl = TextEditingController();

  String _discountType = 'percentage'; // percentage, fixed
  DateTime? _validUntil;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.coupon != null) {
      _initControllers();
    }
  }

  void _initControllers() {
    final c = widget.coupon!;
    _codeCtrl.text = c['code'] ?? '';
    _valueCtrl.text = (c['value'] ?? 0).toString();
    _limitCtrl.text = (c['usageLimit'] ?? 0).toString();
    _discountType = c['discountType'] ?? 'percentage';
    if (c['validUntil'] != null) {
      _validUntil = DateTime.tryParse(c['validUntil']);
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _valueCtrl.dispose();
    _limitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const kBgColor = Color(0xFF050505);
    const kSurfaceColor = Color(0xFF141414);
    const kPrimaryColor = Color(0xFFE50914);

    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: kBgColor,
      extendBodyBehindAppBar: true,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const SmartBackButton(color: Colors.white),
              centerTitle: true,
              title: Text(
                widget.coupon != null ? 'Editar Cupón' : 'Nuevo Cupón',
                style: GoogleFonts.outfit(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
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
                          child: Text(
                            widget.coupon != null
                                ? 'Editar Cupón'
                                : 'Nuevo Cupón',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (isDesktop) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Column: General Info
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: kSurfaceColor,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: Colors.white10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Información General',
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        _buildInput(_codeCtrl, 'CÓDIGO',
                                            Icons.confirmation_number_outlined),
                                        const SizedBox(height: 24),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('TIPO DESCUENTO',
                                                      style: GoogleFonts.outfit(
                                                          color: Colors.white70,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: kBgColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color:
                                                              Colors.white10),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: _buildTypeOption(
                                                                'percentage',
                                                                '% Porcentaje')),
                                                        Expanded(
                                                            child: _buildTypeOption(
                                                                'fixed',
                                                                '\$ Monto Fijo')),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: _buildInput(_valueCtrl,
                                                  'VALOR', Icons.attach_money,
                                                  isNumber: true),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                // Right Column: Restrictions & Actions
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: kSurfaceColor,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          border:
                                              Border.all(color: Colors.white10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Restricciones',
                                              style: GoogleFonts.outfit(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            _buildInput(_limitCtrl,
                                                'LÍMITE USUARIOS', Icons.group,
                                                isNumber: true),
                                            const SizedBox(height: 24),
                                            _buildDateInput(),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: double.infinity,
                                        child: _buildSubmitButton(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Mobile View
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: kSurfaceColor,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Información',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      _buildInput(_codeCtrl, 'CÓDIGO',
                                          Icons.confirmation_number_outlined),
                                      const SizedBox(height: 24),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('TIPO DESCUENTO',
                                              style: GoogleFonts.outfit(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: kBgColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors.white10),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: _buildTypeOption(
                                                        'percentage',
                                                        '% Porcentaje')),
                                                Expanded(
                                                    child: _buildTypeOption(
                                                        'fixed',
                                                        '\$ Monto Fijo')),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      _buildInput(_valueCtrl, 'VALOR',
                                          Icons.attach_money,
                                          isNumber: true),
                                      const SizedBox(height: 24),
                                      _buildInput(_limitCtrl, 'LÍMITE USUARIOS',
                                          Icons.group,
                                          isNumber: true),
                                      const SizedBox(height: 24),
                                      _buildDateInput(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: _buildSubmitButton(),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String value, String label) {
    final isSelected = _discountType == value;
    return InkWell(
      onTap: () => setState(() => _discountType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE50914) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.white : Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('VENCIMIENTO (OPCIONAL)',
            style: GoogleFonts.outfit(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
                context: context,
                initialDate:
                    _validUntil ?? DateTime.now().add(const Duration(days: 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030));
            if (date != null) setState(() => _validUntil = date);
          },
          child: Container(
            height: 56, // Match TextField height default approx
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF050505),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white54),
                const SizedBox(width: 12),
                Text(
                  _validUntil != null
                      ? DateFormat('dd MMM yyyy').format(_validUntil!)
                      : 'Sin vencimiento',
                  style: GoogleFonts.outfit(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, IconData icon,
      {int maxLines = 1, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.outfit(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          style: GoogleFonts.outfit(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo requerido';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF050505),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE50914))),
            prefixIcon:
                maxLines == 1 ? Icon(icon, color: Colors.white54) : null,
            contentPadding: maxLines > 1 ? const EdgeInsets.all(16) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE50914),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              widget.coupon != null ? 'Guardar Cambios' : 'Crear Cupón',
              style: GoogleFonts.outfit(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_codeCtrl.text.isEmpty || _valueCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Código y Valor son obligatorios'),
      ));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final value = double.tryParse(_valueCtrl.text) ?? 0.0;
      final limit = int.tryParse(_limitCtrl.text) ?? 0;

      final couponData = {
        'code': _codeCtrl.text.trim().toUpperCase(),
        'discountType': _discountType,
        'value': value,
        'usageLimit': limit,
        'validUntil': _validUntil?.toIso8601String(),
        'isActive':
            widget.coupon != null ? (widget.coupon!['isActive'] ?? true) : true,
        'usedCount':
            widget.coupon != null ? (widget.coupon!['usedCount'] ?? 0) : 0,
      };

      Map<String, dynamic> res;
      if (widget.coupon != null) {
        couponData['_id'] = widget.coupon!['_id'];
        res = await AdminService.updateCoupon(couponData);
      } else {
        res = await AdminService.createCoupon(couponData);
      }

      if (mounted) {
        if (res.isNotEmpty && (res['_id'] != null || res['status'] == true)) {
          context.pop(true); // Success
        } else {
          throw 'Error al guardar cupón';
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
}
