import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import '../../../components/smart_back_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AddInventoryPage extends StatefulWidget {
  final String listingId;
  final String listingTitle;

  const AddInventoryPage({
    super.key,
    required this.listingId,
    required this.listingTitle,
  });

  @override
  State<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  // Styles
  // static const Color kPrimaryColor = Color(0xFFE50914);

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _profileCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime? _selectedExpiryDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pinCtrl.dispose();
    _profileCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:
            SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
        title: Text(
          'Nueva Cuenta',
          style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Datos de acceso',
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ingresa las credenciales para "${widget.listingTitle}"',
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      _buildInput(
                          _emailCtrl, 'Email / Usuario', Icons.email_outlined),
                      const SizedBox(height: 16),
                      _buildInput(_passCtrl, 'Contraseña', Icons.lock_outline),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _buildInput(
                                  _pinCtrl, 'PIN', Icons.pin_outlined)),
                          const SizedBox(width: 16),
                          Expanded(
                              child: _buildInput(_profileCtrl, 'Perfil',
                                  Icons.account_circle_outlined)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Extra Options
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Opciones Avanzadas',
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      // Expiry Date
                      InkWell(
                        onTap: () async {
                          // Fix: Ensure context is valid before showing dialog
                          if (!mounted) return;

                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now().add(const Duration(days: 30)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365 * 2)),
                            builder: (context, child) =>
                                _buildDatePickerTheme(child!),
                          );
                          if (picked != null && mounted) {
                            setState(() => _selectedExpiryDate = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: _selectedExpiryDate != null
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context)
                                          .secondaryText),
                              const SizedBox(width: 16),
                              Text(
                                _selectedExpiryDate == null
                                    ? 'Fecha de Expiración (Opcional)'
                                    : 'Expira: ${_selectedExpiryDate!.day}/${_selectedExpiryDate!.month}/${_selectedExpiryDate!.year}',
                                style: GoogleFonts.outfit(
                                    color: _selectedExpiryDate == null
                                        ? FlutterFlowTheme.of(context)
                                            .secondaryText
                                        : FlutterFlowTheme.of(context)
                                            .primaryText),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      _buildInput(_notesCtrl, 'Notas Internas / Restricciones',
                          Icons.sticky_note_2_outlined,
                          maxLines: 3),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => _submitSingleItem(), // Wrap in closure
                    style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: FlutterFlowTheme.of(context).primaryText,
                                strokeWidth: 2))
                        : Text(
                            'GUARDAR Y AÑADIR A "${widget.listingTitle.toUpperCase()}"',
                            style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),

                const SizedBox(height: 24),
                // Info
                Center(
                  child: Text(
                    'Esta cuenta estará disponible inmediatamente para los clientes.',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context)
                            .secondaryText
                            .withOpacity(0.5),
                        fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, IconData icon,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        style:
            GoogleFonts.outfit(color: FlutterFlowTheme.of(context).primaryText),
        cursorColor: FlutterFlowTheme.of(context).primary,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child:
                Icon(icon, color: FlutterFlowTheme.of(context).secondaryText),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDatePickerTheme(Widget child) {
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: FlutterFlowTheme.of(context).primary,
          onPrimary: FlutterFlowTheme.of(context).info,
          surface: FlutterFlowTheme.of(context).secondaryBackground,
          onSurface: FlutterFlowTheme.of(context).primaryText,
        ),
        dialogTheme: DialogThemeData(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground),
      ),
      child: child,
    );
  }

  Future<void> _submitSingleItem() async {
    final email = _emailCtrl.text.trim();
    final pwd = _passCtrl.text.trim();

    if (email.isEmpty || pwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text('Email y Contraseña son obligatorios'),
            backgroundColor: FlutterFlowTheme.of(context).error),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final item = {
        'credentials': {
          'email': email,
          'password': pwd,
          'pin': _pinCtrl.text.trim(),
          'profileName': _profileCtrl.text.trim(),
        },
        'metadata': {
          'notes': _notesCtrl.text.trim(),
        },
        'expiryDate': _selectedExpiryDate?.toIso8601String(),
        'isActive': true,
      };

      await AdminService.addInventory(
          listingId: widget.listingId, items: [item]);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Cuenta agregada exitosamente'),
            backgroundColor: FlutterFlowTheme.of(context).success),
      );
      // Wait for snackbar before popping to avoid quick layout shifts
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $e'),
            backgroundColor: FlutterFlowTheme.of(context).error));
      }
    }
  }
}
