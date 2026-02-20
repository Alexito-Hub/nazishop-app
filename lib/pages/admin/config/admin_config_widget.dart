import 'package:flutter/material.dart';
import '/backend/admin_service.dart';
import '/models/app_config_model.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/components/design_system.dart';
import 'components/config_section_card.dart';
import 'components/config_inputs.dart';

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

    // Reuse colors for potential future use or consistency logic
    final textSecondary = theme.secondaryText;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: isDesktop
          ? _buildDesktopLayout(theme, textSecondary)
          : _buildMobileLayout(theme, textSecondary),
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

  Widget _buildDesktopLayout(FlutterFlowTheme theme, Color textSecondary) {
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
                child: DSAdminPageHeader(
                  title: 'Configuración',
                  subtitle: 'Ajustes generales de la tienda',
                  actionLabel: _isSaving ? 'Guardando...' : 'Guardar Cambios',
                  actionIcon: Icons.save,
                  onAction: _isSaving ? () {} : _saveSettings,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              sliver: SliverToBoxAdapter(child: _buildDesktopContent(theme)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(FlutterFlowTheme theme, Color textSecondary) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const DSMobileAppBar(title: 'Configuración'),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(child: _buildMobileContent(theme)),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }

  Widget _buildDesktopContent(FlutterFlowTheme theme) {
    if (_isLoading || _config == null) {
      return Center(
          child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary));
    }

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        ConfigSectionCard(
          title: 'Identidad del Sitio',
          icon: Icons.web,
          width: 400,
          children: [
            ConfigTextField(
              controller: _appNameCtrl,
              label: 'Nombre de la App',
            ),
            const SizedBox(height: 16),
            ConfigSwitchTile(
              title: 'Modo Mantenimiento',
              value: _config!.site.maintenanceMode,
              onChanged: (v) {
                setState(() => _config!.site.maintenanceMode = v);
              },
            ),
          ],
        ),
        ConfigSectionCard(
          title: 'Soporte y Contacto',
          icon: Icons.support_agent,
          width: 400,
          children: [
            ConfigTextField(
              controller: _supportEmailCtrl,
              label: 'Email de Soporte',
            ),
            const SizedBox(height: 16),
            ConfigTextField(
              controller: _whatsappCtrl,
              label: 'WhatsApp Soporte',
            ),
          ],
        ),
        ConfigSectionCard(
          title: 'Control de Versiones',
          icon: Icons.system_update,
          width: 400,
          children: [
            ConfigTextField(
              controller: _minVersionCtrl,
              label: 'Versión Mínima',
            ),
            const SizedBox(height: 16),
            ConfigTextField(
              controller: _latestVersionCtrl,
              label: 'Última Versión',
            ),
          ],
        ),
        ConfigSectionCard(
          title: 'Anuncios Globales',
          icon: Icons.campaign,
          width: 824,
          maxWidth: 824,
          children: [
            ConfigSwitchTile(
              title: 'Mostrar Anuncio',
              value: _config!.site.showAnnouncement,
              onChanged: (v) {
                setState(() => _config!.site.showAnnouncement = v);
              },
            ),
            const SizedBox(height: 16),
            ConfigTextField(
              controller: _announcementCtrl,
              label: 'Mensaje del Anuncio',
              maxLines: 3,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileContent(FlutterFlowTheme theme) {
    if (_isLoading || _config == null) {
      return Center(child: CircularProgressIndicator(color: theme.primary));
    }

    return Column(
      children: [
        ConfigSectionCard(
          title: 'Identidad del Sitio',
          icon: Icons.web,
          children: [
            ConfigTextField(
              controller: _appNameCtrl,
              label: 'Nombre de la App',
            ),
            const SizedBox(height: 16),
            ConfigSwitchTile(
              title: 'Modo Mantenimiento',
              value: _config!.site.maintenanceMode,
              onChanged: (v) {
                setState(() => _config!.site.maintenanceMode = v);
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        ConfigSectionCard(
          title: 'Soporte y Contacto',
          icon: Icons.support_agent,
          children: [
            ConfigTextField(
              controller: _supportEmailCtrl,
              label: 'Email de Soporte',
            ),
            const SizedBox(height: 16),
            ConfigTextField(
              controller: _whatsappCtrl,
              label: 'WhatsApp Soporte',
            ),
          ],
        ),
        const SizedBox(height: 24),
        ConfigSectionCard(
          title: 'Control de Versiones',
          icon: Icons.system_update,
          children: [
            ConfigTextField(
              controller: _minVersionCtrl,
              label: 'Versión Mínima',
            ),
            const SizedBox(height: 16),
            ConfigTextField(
              controller: _latestVersionCtrl,
              label: 'Última Versión',
            ),
          ],
        ),
        const SizedBox(height: 24),
        ConfigSectionCard(
          title: 'Anuncios Globales',
          icon: Icons.campaign,
          children: [
            ConfigSwitchTile(
              title: 'Mostrar Anuncio',
              value: _config!.site.showAnnouncement,
              onChanged: (v) {
                setState(() => _config!.site.showAnnouncement = v);
              },
            ),
            const SizedBox(height: 16),
            ConfigTextField(
              controller: _announcementCtrl,
              label: 'Mensaje del Anuncio',
              maxLines: 3,
            ),
          ],
        ),
      ],
    );
  }
}
