import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/api_client.dart';
import '../../components/smart_back_button.dart';
import 'package:nazi_shop/backend/notification_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AdminNotificationsWidget extends StatefulWidget {
  const AdminNotificationsWidget({super.key});

  static const String routeName = 'admin_notifications';

  @override
  State<AdminNotificationsWidget> createState() =>
      _AdminNotificationsWidgetState();
}

class _AdminNotificationsWidgetState extends State<AdminNotificationsWidget> {
  final _formKey = GlobalKey<FormState>();

  // Colors

  // Form Controllers
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _userIdController = TextEditingController();

  String _selectedTarget = 'ALL'; // ALL or SPECIFIC
  String _selectedType = 'system';
  String? _selectedIcon = 'notifications';

  bool _isSending = false;

  final List<String> _types = [
    'system',
    'welcome',
    'offer',
    'order',
    'security'
  ];
  final List<String> _icons = [
    'notifications',
    'stars_rounded',
    'local_offer_rounded',
    'check_circle_rounded',
    'security_rounded',
    'warning',
    'info'
  ];

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    try {
      final targetId =
          _selectedTarget == 'ALL' ? 'ALL' : _userIdController.text.trim();

      final response = await ApiClient.post('/api/notifications', body: {
        'action': 'send',
        'targetUserId': targetId,
        'title': _titleController.text.trim(),
        'message': _messageController.text.trim(),
        'type': _selectedType,
        'icon': _selectedIcon,
      });

      if (response['status'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notificación enviada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          _clearForm();
        }
      } else {
        throw Exception(response['msg'] ?? 'Error desconocido');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _clearForm() {
    _titleController.clear();
    _messageController.clear();
    _userIdController.clear();
    setState(() {
      _selectedTarget = 'ALL';
      _selectedType = 'system';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final kPrimaryColor = theme.primary;
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        title: Text('Admin Notificaciones',
            style: GoogleFonts.outfit(color: Colors.white)),
        leading: const SmartBackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme, kPrimaryColor),
                const SizedBox(height: 32),

                // Target Selection
                _buildSectionLabel('Destinatario'),
                ToggleButtons(
                  isSelected: [
                    _selectedTarget == 'ALL',
                    _selectedTarget == 'SPECIFIC'
                  ],
                  onPressed: (index) => setState(
                      () => _selectedTarget = index == 0 ? 'ALL' : 'SPECIFIC'),
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: kPrimaryColor.withValues(alpha: 0.2),
                  color: Colors.white70,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text('Todos (Broadcast)',
                          style: GoogleFonts.outfit()),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text('Usuario Específico',
                          style: GoogleFonts.outfit()),
                    ),
                  ],
                ),
                if (_selectedTarget == 'SPECIFIC') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _userIdController,
                    style: GoogleFonts.outfit(color: Colors.white),
                    decoration: _inputDecoration(
                        'User ID (Firebase UID)', theme, kPrimaryColor),
                    validator: (v) =>
                        v!.isEmpty && _selectedTarget == 'SPECIFIC'
                            ? 'Requerido'
                            : null,
                  ),
                ],

                const SizedBox(height: 24),

                // Content
                _buildSectionLabel('Contenido'),
                TextFormField(
                  controller: _titleController,
                  style: GoogleFonts.outfit(color: Colors.white),
                  decoration: _inputDecoration('Título', theme, kPrimaryColor),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  style: GoogleFonts.outfit(color: Colors.white),
                  decoration: _inputDecoration('Mensaje', theme, kPrimaryColor),
                  maxLines: 3,
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),

                const SizedBox(height: 24),

                // Type & Icon
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel('Tipo'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedType,
                                dropdownColor: theme.secondaryBackground,
                                isExpanded: true,
                                style: GoogleFonts.outfit(color: Colors.white),
                                items: _types
                                    .map((t) => DropdownMenuItem(
                                        value: t, child: Text(t.toUpperCase())))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedType = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel('Icono'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedIcon,
                                dropdownColor: theme.secondaryBackground,
                                isExpanded: true,
                                style: GoogleFonts.outfit(color: Colors.white),
                                items: _icons
                                    .map((t) => DropdownMenuItem(
                                        value: t,
                                        child: Row(
                                          children: [
                                            Icon(
                                                NotificationService.getIconData(
                                                    t),
                                                color: Colors.white70,
                                                size: 20),
                                            const SizedBox(width: 8),
                                            Text(t),
                                          ],
                                        )))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedIcon = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSending ? null : _sendNotification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSending
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('ENVIAR NOTIFICACIÓN',
                            style: GoogleFonts.outfit(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme, Color kPrimaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kPrimaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.admin_panel_settings,
                color: kPrimaryColor, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Panel de Envíos Push',
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                    'Envía notificaciones push a usuarios o a toda la base de datos.',
                    style: GoogleFonts.outfit(
                        color: Colors.white54, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label,
          style: GoogleFonts.outfit(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600)),
    );
  }

  InputDecoration _inputDecoration(
      String label, FlutterFlowTheme theme, Color kPrimaryColor) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white54),
      filled: true,
      fillColor: theme.secondaryBackground,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white12)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primary)),
    );
  }
}
