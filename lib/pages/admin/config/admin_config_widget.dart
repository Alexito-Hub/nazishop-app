import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/app_config_model.dart';
import 'package:nazi_shop/flutter_flow/flutter_flow_theme.dart';
import '../../../components/smart_back_button.dart';
// For BackdropFilter if needed, but not using it extensively now to keep it clean

class AdminConfigWidget extends StatefulWidget {
  const AdminConfigWidget({super.key});

  @override
  State<AdminConfigWidget> createState() => _AdminConfigWidgetState();
}

class _AdminConfigWidgetState extends State<AdminConfigWidget> {
  // static const Color kPrimaryColor = Color(0xFFE50914); // Removed hardcoded color
  bool _isLoading = true;
  bool _isSaving = false;
  AppConfig? _config;

  final _appNameCtrl = TextEditingController();
  final _supportEmailCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _announcementCtrl = TextEditingController();
  final _minVersionCtrl = TextEditingController();
  final _latestVersionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final cfgMap = await AdminService.getGlobalConfig();
      if (cfgMap.isNotEmpty) {
        final cfg = AppConfig.fromJson(cfgMap);
        setState(() {
          _config = cfg;
          _appNameCtrl.text = cfg.site.name;
          _supportEmailCtrl.text = cfg.support.email;
          _whatsappCtrl.text = cfg.support.whatsapp;
          _announcementCtrl.text = cfg.site.announcementText;
          _minVersionCtrl.text = cfg.app.minVersion;
          _latestVersionCtrl.text = cfg.app.latestVersion;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar configuración: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveSettings() async {
    if (_config == null) return;
    setState(() => _isSaving = true);
    try {
      _config!.site.name = _appNameCtrl.text;
      _config!.site.announcementText = _announcementCtrl.text;
      _config!.support.email = _supportEmailCtrl.text;
      _config!.support.whatsapp = _whatsappCtrl.text;
      _config!.app.minVersion = _minVersionCtrl.text;
      _config!.app.latestVersion = _latestVersionCtrl.text;

      await AdminService.updateConfig(_config!.toJson());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Configuración guardada correctamente'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'),
              backgroundColor: FlutterFlowTheme.of(context).error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final theme = FlutterFlowTheme.of(context);

    final cardColor = theme.secondaryBackground;
    final borderColor = theme.alternate;
    final textSecondary = theme.secondaryText;
    final inputFillColor = theme.primaryBackground;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: isDesktop
          ? _buildDesktopLayout(
              theme, cardColor, borderColor, textSecondary, inputFillColor)
          : _buildMobileLayout(
              theme, cardColor, borderColor, textSecondary, inputFillColor),
      floatingActionButton: isDesktop
          ? null
          : FloatingActionButton(
              onPressed: _isSaving ? null : _saveSettings,
              backgroundColor: theme.primary,
              child: _isSaving
                  ? CircularProgressIndicator(color: theme.tertiary)
                  : Icon(Icons.save, color: theme.tertiary),
            ),
    );
  }

  Widget _buildDesktopLayout(FlutterFlowTheme theme, Color cardColor,
      Color borderColor, Color textSecondary, Color inputFillColor) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Configuración',
                            style: GoogleFonts.outfit(
                                color: theme.primaryText,
                                fontSize: 32,
                                fontWeight: FontWeight.bold)),
                        Text('Ajustes generales de la tienda',
                            style: GoogleFonts.outfit(
                                color: textSecondary, fontSize: 16)),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.primary, theme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.save,
                                color: Colors.white, size: 20),
                        label: Text(
                            _isSaving ? 'Guardando...' : 'Guardar Cambios',
                            style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              sliver: SliverToBoxAdapter(
                  child: _buildDesktopContent(theme, cardColor, borderColor,
                      textSecondary, inputFillColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(FlutterFlowTheme theme, Color cardColor,
      Color borderColor, Color textSecondary, Color inputFillColor) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          leading: SmartBackButton(color: theme.primaryText),
          title: Text('Configuración',
              style: GoogleFonts.outfit(
                  color: theme.primaryText, fontWeight: FontWeight.bold)),
          centerTitle: true,
          pinned: true,
          floating: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
              child: _buildMobileContent(theme, cardColor, borderColor,
                  textSecondary, inputFillColor)),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }

  Widget _buildDesktopContent(FlutterFlowTheme theme, Color cardColor,
      Color borderColor, Color textSecondary, Color inputFillColor) {
    if (_isLoading || _config == null) {
      return Center(
          child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary));
    }

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        _buildConfigCard(
          'Identidad del Sitio',
          Icons.web,
          [
            _buildTextField(_appNameCtrl, 'Nombre de la App', theme,
                borderColor, textSecondary, inputFillColor),
            const SizedBox(height: 16),
            _buildSwitchTile(
                'Modo Mantenimiento', _config!.site.maintenanceMode, (v) {
              setState(() => _config!.site.maintenanceMode = v);
            }, theme, borderColor, inputFillColor),
          ],
          theme,
          cardColor,
          borderColor,
          width: 400,
        ),
        _buildConfigCard(
          'Soporte y Contacto',
          Icons.support_agent,
          [
            _buildTextField(_supportEmailCtrl, 'Email de Soporte', theme,
                borderColor, textSecondary, inputFillColor),
            const SizedBox(height: 16),
            _buildTextField(_whatsappCtrl, 'WhatsApp Soporte', theme,
                borderColor, textSecondary, inputFillColor),
          ],
          theme,
          cardColor,
          borderColor,
          width: 400,
        ),
        _buildConfigCard(
          'Control de Versiones',
          Icons.system_update,
          [
            _buildTextField(_minVersionCtrl, 'Versión Mínima', theme,
                borderColor, textSecondary, inputFillColor),
            const SizedBox(height: 16),
            _buildTextField(_latestVersionCtrl, 'Última Versión', theme,
                borderColor, textSecondary, inputFillColor),
          ],
          theme,
          cardColor,
          borderColor,
          width: 400,
        ),
        _buildConfigCard(
          'Anuncios Globales',
          Icons.campaign,
          [
            _buildSwitchTile('Mostrar Anuncio', _config!.site.showAnnouncement,
                (v) {
              setState(() => _config!.site.showAnnouncement = v);
            }, theme, borderColor, inputFillColor),
            const SizedBox(height: 16),
            _buildTextField(_announcementCtrl, 'Mensaje del Anuncio', theme,
                borderColor, textSecondary, inputFillColor,
                maxLines: 3),
          ],
          theme,
          cardColor,
          borderColor,
          width: 824, // Wider card for announcements
          maxWidth: 824,
        ),
      ],
    );
  }

  Widget _buildMobileContent(FlutterFlowTheme theme, Color cardColor,
      Color borderColor, Color textSecondary, Color inputFillColor) {
    if (_isLoading || _config == null) {
      return Center(child: CircularProgressIndicator(color: theme.primary));
    }

    return Column(
      children: [
        _buildConfigCard(
          'Identidad del Sitio',
          Icons.web,
          [
            _buildTextField(_appNameCtrl, 'Nombre de la App', theme,
                borderColor, textSecondary, inputFillColor),
            const SizedBox(height: 16),
            _buildSwitchTile(
                'Modo Mantenimiento', _config!.site.maintenanceMode, (v) {
              setState(() => _config!.site.maintenanceMode = v);
            }, theme, borderColor, inputFillColor),
          ],
          theme,
          cardColor,
          borderColor,
        ),
        const SizedBox(height: 24),
        _buildConfigCard(
          'Soporte y Contacto',
          Icons.support_agent,
          [
            _buildTextField(_supportEmailCtrl, 'Email de Soporte', theme,
                borderColor, textSecondary, inputFillColor),
            const SizedBox(height: 16),
            _buildTextField(_whatsappCtrl, 'WhatsApp Soporte', theme,
                borderColor, textSecondary, inputFillColor),
          ],
          theme,
          cardColor,
          borderColor,
        ),
        const SizedBox(height: 24),
        _buildConfigCard(
          'Control de Versiones',
          Icons.system_update,
          [
            _buildTextField(_minVersionCtrl, 'Versión Mínima', theme,
                borderColor, textSecondary, inputFillColor),
            const SizedBox(height: 16),
            _buildTextField(_latestVersionCtrl, 'Última Versión', theme,
                borderColor, textSecondary, inputFillColor),
          ],
          theme,
          cardColor,
          borderColor,
        ),
        const SizedBox(height: 24),
        _buildConfigCard(
          'Anuncios Globales',
          Icons.campaign,
          [
            _buildSwitchTile('Mostrar Anuncio', _config!.site.showAnnouncement,
                (v) {
              setState(() => _config!.site.showAnnouncement = v);
            }, theme, borderColor, inputFillColor),
            const SizedBox(height: 16),
            _buildTextField(_announcementCtrl, 'Mensaje del Anuncio', theme,
                borderColor, textSecondary, inputFillColor,
                maxLines: 3),
          ],
          theme,
          cardColor,
          borderColor,
        ),
      ],
    );
  }

  Widget _buildConfigCard(String title, IconData icon, List<Widget> children,
      FlutterFlowTheme theme, Color cardColor, Color borderColor,
      {double? width, double? maxWidth}) {
    return Container(
      width: width,
      constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth) : null,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: FlutterFlowTheme.of(context).primary, size: 24),
              const SizedBox(width: 12),
              Text(title,
                  style: GoogleFonts.outfit(
                      color: theme.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      FlutterFlowTheme theme,
      Color borderColor,
      Color labelColor,
      Color fillColor,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.outfit(
                color: labelColor, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.outfit(color: theme.primaryText),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: FlutterFlowTheme.of(context).primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged,
      FlutterFlowTheme theme, Color borderColor, Color fillColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title,
            style: GoogleFonts.outfit(
                color: theme.primaryText, fontWeight: FontWeight.w500)),
        activeThumbColor: FlutterFlowTheme.of(context).primary,
        activeTrackColor:
            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
        inactiveThumbColor: FlutterFlowTheme.of(context).secondaryText,
        inactiveTrackColor:
            FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.3),
      ),
    );
  }
}
