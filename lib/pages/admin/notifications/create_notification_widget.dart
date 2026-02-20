import 'package:flutter/material.dart';
import 'dart:ui'; // Add for ImageFilter
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/admin_service.dart';
import '../../../components/smart_back_button.dart';

class CreateNotificationWidget extends StatefulWidget {
  const CreateNotificationWidget({super.key});

  @override
  State<CreateNotificationWidget> createState() =>
      _CreateNotificationWidgetState();
}

class _CreateNotificationWidgetState extends State<CreateNotificationWidget> {
  // Styles
  Color get kBgColor => FlutterFlowTheme.of(context).primaryBackground;
  Color get kSurfaceColor => FlutterFlowTheme.of(context).secondaryBackground;
  Color get kPrimaryColor => FlutterFlowTheme.of(context).primary;

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();
  final _routeCtrl = TextEditingController();
  final _targetUserCtrl = TextEditingController(text: 'ALL');

  String _selectedType = 'system';
  String _priority = 'normal';
  bool _isSubmitting = false;

  final List<String> _notificationTypes = [
    'system',
    'offer',
    'order',
    'security',
    'update',
    'maintenance'
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _messageCtrl.dispose();
    _imageUrlCtrl.dispose();
    _routeCtrl.dispose();
    _targetUserCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: kBgColor,
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
                'Nueva Notificación',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.bold),
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
                color: kPrimaryColor.withValues(alpha: 0.05),
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
                            'Nueva Notificación',
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
                                // Left Column: Content
                                Expanded(
                                  flex: 3,
                                  child: _buildContentSection(),
                                ),
                                const SizedBox(width: 24),
                                // Right Column: Config & Actions
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      _buildConfigSection(),
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
                                _buildContentSection(),
                                const SizedBox(height: 16),
                                _buildConfigSection(),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
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

  Widget _buildContentSection() {
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
          Text(
            'Contenido del Mensaje',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildInput(_titleCtrl, 'TÍTULO', Icons.title,
              validator: (v) => v!.isEmpty ? 'Requerido' : null),
          const SizedBox(height: 24),
          _buildInput(_messageCtrl, 'MENSAJE', Icons.message,
              maxLines: 4, validator: (v) => v!.isEmpty ? 'Requerido' : null),
          const SizedBox(height: 24),
          _buildInput(_imageUrlCtrl, 'URL DE IMAGEN (OPCIONAL)', Icons.image),
          const SizedBox(height: 24),
          _buildInput(
              _routeCtrl, 'RUTA DE REDIRECCIÓN (Ej: /offers)', Icons.link),
        ],
      ),
    );
  }

  Widget _buildConfigSection() {
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
          Text(
            'Configuración de Envío',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text('TIPO DE NOTIFICACIÓN',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: kBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: FlutterFlowTheme.of(context)
                      .primaryText
                      .withValues(alpha: 0.1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedType,
                dropdownColor: kSurfaceColor,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down,
                    color: FlutterFlowTheme.of(context).secondaryText),
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText),
                items: _notificationTypes
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('PRIORIDAD',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: kBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FlutterFlowTheme.of(context).alternate),
            ),
            child: Row(
              children: [
                Expanded(child: _buildPriorityOption('normal', 'Normal')),
                Expanded(child: _buildPriorityOption('high', 'Alta')),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildInput(
              _targetUserCtrl, 'ID USUARIO (ALL para todos)', Icons.person),
        ],
      ),
    );
  }

  Widget _buildPriorityOption(String value, String label) {
    final isSelected = _priority == value;
    final color = value == 'high'
        ? FlutterFlowTheme.of(context).error
        : FlutterFlowTheme.of(context).primary;

    return GestureDetector(
      onTap: () => setState(() => _priority = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: color) : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: isSelected
                  ? color
                  : FlutterFlowTheme.of(context).secondaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1,
      bool isNumber = false,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText, fontSize: 16),
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: kBgColor,
            hintText: 'Ingrese $label...',
            hintStyle: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText),
            prefixIcon: maxLines == 1
                ? Icon(icon, color: FlutterFlowTheme.of(context).secondaryText)
                : null,
            contentPadding: maxLines > 1 ? const EdgeInsets.all(16) : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: FlutterFlowTheme.of(context).alternate)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: kPrimaryColor)),
            errorStyle:
                GoogleFonts.outfit(color: FlutterFlowTheme.of(context).error),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        shadowColor: kPrimaryColor.withValues(alpha: 0.5),
      ),
      onPressed: _isSubmitting ? null : _submit,
      child: _isSubmitting
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).info, strokeWidth: 2))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded,
                    color: FlutterFlowTheme.of(context).info),
                const SizedBox(width: 12),
                Text(
                  'Enviar Notificación',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).info,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final data = {
        'title': _titleCtrl.text,
        'message': _messageCtrl.text,
        'imageUrl': _imageUrlCtrl.text.isNotEmpty ? _imageUrlCtrl.text : null,
        'route': _routeCtrl.text.isNotEmpty ? _routeCtrl.text : null,
        'type': _selectedType,
        'priority': _priority,
        'userId': _targetUserCtrl.text.isEmpty ? 'ALL' : _targetUserCtrl.text,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await AdminService.sendNotification(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notificación enviada con éxito')));
        Navigator.pop(context, true);
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
