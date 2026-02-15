import 'package:flutter/material.dart';
import 'dart:ui'; // Add for ImageFilter
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import '../../../components/smart_back_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class CreateInventoryPage extends StatefulWidget {
  final String? listingId;
  final String? listingTitle;

  const CreateInventoryPage({
    super.key,
    this.listingId,
    this.listingTitle,
  });

  @override
  State<CreateInventoryPage> createState() => _CreateInventoryPageState();
}

class _CreateInventoryPageState extends State<CreateInventoryPage> {
  // Styles
  // Removed static consts to use Theme directly
  // static const Color kPrimaryColor = Color(0xFFE50914);

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _profileCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  // DateTime? _selectedExpiryDate; // Removed
  bool _isSubmitting = false;

  // New Selection Logic
  String? _selectedListingId;
  String? _selectedListingTitle;
  List<dynamic> _availableListings = [];
  bool _isLoadingListings = false;

  @override
  void initState() {
    super.initState();
    _selectedListingId = widget.listingId;
    _selectedListingTitle = widget.listingTitle;

    if (_selectedListingId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadListings());
    }
  }

  Future<void> _loadListings() async {
    if (!mounted) return;
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
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pinCtrl.dispose();
    _profileCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check for "Desktop" width (where Dashboard sidebar typically appears)
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      extendBodyBehindAppBar: true,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: SmartBackButton(
                  color: FlutterFlowTheme.of(context).primaryText),
              centerTitle: true,
              title: Text(
                'Nueva Cuenta',
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
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.05),
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
                          'Nueva Cuenta',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
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
                              // Left Column: Credentials
                              Expanded(
                                flex: 3,
                                child: _buildAccessDataCard(),
                              ),
                              const SizedBox(width: 24),
                              // Right Column: Options & Submit
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _buildAdvancedOptionsCard(),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: _buildSubmitButton(),
                                    ),
                                    const SizedBox(height: 24),
                                    _buildInfoText(),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Mobile Layout
                          return Column(
                            children: [
                              _buildAccessDataCard(),
                              const SizedBox(height: 24),
                              _buildAdvancedOptionsCard(),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: _buildSubmitButton(),
                              ),
                              const SizedBox(height: 24),
                              _buildInfoText(),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ), // End Center container
        ],
      ),
    );
  }

  Widget _buildAccessDataCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
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
          if (widget.listingId != null)
            Text(
              'Ingresa las credenciales para "${widget.listingTitle}"',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 14),
            )
          else ...[
            Text(
              'Selecciona el listado para vincular esta cuenta:',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildListingSelector(),
          ],
          const SizedBox(height: 24),
          _buildInput(_emailCtrl, 'Email / Usuario', Icons.email_outlined),
          const SizedBox(height: 16),
          _buildInput(_passCtrl, 'Contraseña', Icons.lock_outline),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildInput(_pinCtrl, 'PIN', Icons.pin_outlined)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildInput(
                      _profileCtrl, 'Perfil', Icons.account_circle_outlined)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedOptionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
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
          _buildInput(
              _notesCtrl, 'Descripción / Metadata', Icons.description_outlined,
              maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildInfoText() {
    return Center(
      child: Text(
        'Esta cuenta estará disponible inmediatamente para los clientes.',
        style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).secondaryText, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : () => _submitSingleItem(),
      style: ElevatedButton.styleFrom(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0),
      child: _isSubmitting
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).info, strokeWidth: 2))
          : Text(
              _selectedListingTitle != null
                  ? 'AÑADIR A "${_selectedListingTitle!.toUpperCase()}"'
                  : 'GUARDAR NUEVA CUENTA',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).info,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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

  // Removed _buildDatePickerTheme as it is no longer used

  Future<void> _submitSingleItem() async {
    // Validate Listing Selection
    if (_selectedListingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Debes seleccionar un listado para vincular'),
            backgroundColor: FlutterFlowTheme.of(context).error),
      );
      return;
    }

    final email = _emailCtrl.text.trim();
    final pwd = _passCtrl.text.trim();

    if (email.isEmpty || pwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Email y Contraseña son obligatorios'),
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
        'isActive': true,
      };

      await AdminService.addInventory(
          listingId: _selectedListingId!, items: [item]);

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

  Widget _buildListingSelector() {
    if (_isLoadingListings) {
      return Center(
          child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedListingId,
          hint: Text('Seleccionar Listado...',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText)),
          dropdownColor: FlutterFlowTheme.of(context).secondaryBackground,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down,
              color: FlutterFlowTheme.of(context).secondaryText),
          style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText),
          items: _availableListings.map<DropdownMenuItem<String>>((listing) {
            final title = listing['title'] ?? 'Sin Título';
            return DropdownMenuItem(
              value: listing['_id'],
              child: Text(title, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: (val) {
            final listing = _availableListings
                .firstWhere((e) => e['_id'] == val, orElse: () => {});
            setState(() {
              _selectedListingId = val;
              _selectedListingTitle = listing['title'];
            });
          },
        ),
      ),
    );
  }
}
