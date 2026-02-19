import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/nazishop_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/services/biometric_service.dart';
import '/backend/user_service.dart';

class SecurityWidget extends StatefulWidget {
  const SecurityWidget({super.key});

  @override
  State<SecurityWidget> createState() => _SecurityWidgetState();
}

class _SecurityWidgetState extends State<SecurityWidget> {
  bool _is2FAEnabled = false;
  bool _isBiometricEnabled = false;
  bool _isLoadingSecurity = true;
  List<dynamic> _sessions = [];
  bool _loadingSessions = true;

  @override
  void initState() {
    super.initState();
    _loadSecuritySettings();
    _fetchSessions();
  }

  Future<void> _loadSecuritySettings() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      if (doc.exists && mounted) {
        final biometricEnabled = await BiometricService.isEnabled();
        setState(() {
          _is2FAEnabled = doc.data()?['is2FAEnabled'] ?? false;
          _isBiometricEnabled = biometricEnabled;
          _isLoadingSecurity = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingSecurity = false);
    }
  }

  Future<void> _fetchSessions() async {
    if (mounted) setState(() => _loadingSessions = true);
    final sessions = await UserService.getSessions();
    if (mounted) {
      setState(() {
        _sessions = sessions;
        _loadingSessions = false;
      });
    }
  }

  Future<void> _toggleSetting(String field, bool value) async {
    if (field == 'isBiometricEnabled') {
      await BiometricService.setEnabled(value);
      setState(() => _isBiometricEnabled = value);
      return;
    }

    setState(() {
      if (field == 'is2FAEnabled') _is2FAEnabled = value;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .update({field: value});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Configuración actualizada')));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (field == 'is2FAEnabled') _is2FAEnabled = !value;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
      }
    }
  }

  Future<void> _revokeSession(String sessionId) async {
    final success = await UserService.revokeSession(sessionId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada')),
      );
      _fetchSessions();
    }
  }

  Future<void> _revokeAllOthers() async {
    final success = await UserService.revokeAllOtherSessions();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Otras sesiones cerradas')),
      );
      _fetchSessions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Centro de Seguridad',
          style: GoogleFonts.outfit(
            color: theme.primaryText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: !isDesktop,
      ),
      body: _isLoadingSecurity
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: isDesktop
                  ? _buildDesktopLayout(theme)
                  : _buildMobileLayout(theme),
            ),
    );
  }

  Widget _buildDesktopLayout(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildPasswordSection(theme)),
            const SizedBox(width: 24),
            Expanded(child: _buildAdditionalProtectionSection(theme)),
          ],
        ),
        const SizedBox(height: 32),
        _buildDeviceSection(theme),
      ],
    );
  }

  Widget _buildMobileLayout(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPasswordSection(theme),
        const SizedBox(height: 32),
        _buildAdditionalProtectionSection(theme),
        const SizedBox(height: 32),
        _buildDeviceSection(theme),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          color: FlutterFlowTheme.of(context).primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildPasswordSection(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Contraseña'),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(theme),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.mark_email_read_outlined, color: theme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Correo Vinculado',
                            style: GoogleFonts.outfit(
                                color: theme.secondaryText, fontSize: 12)),
                        Text(currentUserEmail,
                            style: GoogleFonts.outfit(
                                color: theme.primaryText, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: theme.alternate),
              const SizedBox(height: 20),
              Text(
                'Para cambiar tu contraseña, te enviaremos un enlace seguro.',
                style: GoogleFonts.outfit(
                    color: theme.secondaryText, fontSize: 14),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    if (currentUserEmail.isEmpty) return;
                    await getAuthManager(context)
                        .resetPassword(email: currentUserEmail);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Enlace enviado a $currentUserEmail'),
                        backgroundColor: theme.primary,
                      ));
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.primaryText,
                    side:
                        BorderSide(color: theme.primary.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Enviar Correo'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalProtectionSection(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Protección Adicional'),
        Container(
          decoration: _cardDecoration(theme),
          child: Column(
            children: [
              SwitchListTile(
                value: _is2FAEnabled,
                onChanged: (val) => _toggleSetting('is2FAEnabled', val),
                activeColor: theme.primary,
                title: Text('Autenticación 2FA',
                    style: GoogleFonts.outfit(color: theme.primaryText)),
                subtitle: Text('Código extra al iniciar sesión.',
                    style: GoogleFonts.outfit(
                        color: theme.secondaryText, fontSize: 12)),
                secondary: Icon(Icons.security_rounded, color: theme.info),
              ),
              Divider(color: theme.alternate, height: 1),
              SwitchListTile(
                value: _isBiometricEnabled,
                onChanged: (val) => _toggleSetting('isBiometricEnabled', val),
                activeColor: theme.primary,
                title: Text('Biometría',
                    style: GoogleFonts.outfit(color: theme.primaryText)),
                subtitle: Text('FaceID o Huella digital.',
                    style: GoogleFonts.outfit(
                        color: theme.secondaryText, fontSize: 12)),
                secondary:
                    Icon(Icons.fingerprint_rounded, color: theme.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceSection(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Dispositivos Conectados'),
        if (_loadingSessions)
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator()))
        else if (_sessions.isEmpty)
          _buildEmptySessions(theme)
        else ...[
          ..._sessions.map((session) => _buildSessionCard(session, theme)),
          const SizedBox(height: 16),
          _buildRevokeAllButton(theme),
        ],
      ],
    );
  }

  Widget _buildSessionCard(dynamic session, FlutterFlowTheme theme) {
    final bool isCurrent = session['isCurrent'] ?? false;
    final String deviceType = session['deviceType'] ?? 'web';

    IconData deviceIcon = Icons.language_rounded;
    if (deviceType == 'mobile') deviceIcon = Icons.smartphone_rounded;
    if (deviceType == 'desktop') deviceIcon = Icons.laptop_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _cardDecoration(theme).copyWith(
        border: Border.all(
          color: isCurrent
              ? theme.primary.withValues(alpha: 0.3)
              : theme.alternate,
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(deviceIcon, color: theme.secondaryText, size: 28),
        title: Text(
          session['deviceName'] ?? 'Unknown Device',
          style: GoogleFonts.outfit(
              color: theme.primaryText, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${session['os']} • ${session['ipAddress']}',
            style:
                GoogleFonts.outfit(color: theme.secondaryText, fontSize: 12)),
        trailing: isCurrent
            ? Icon(Icons.circle, size: 8, color: theme.success)
            : IconButton(
                icon: Icon(Icons.logout_rounded, color: theme.error, size: 22),
                onPressed: () => _revokeSession(session['sessionId']),
              ),
      ),
    );
  }

  Widget _buildEmptySessions(FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(theme),
      child: Center(
          child: Text('No hay otras sesiones activas',
              style: GoogleFonts.outfit(color: theme.secondaryText))),
    );
  }

  Widget _buildRevokeAllButton(FlutterFlowTheme theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _revokeAllOthers,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.error,
          side: BorderSide(color: theme.error.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('CERRAR TODAS LAS DEMÁS SESIONES',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  BoxDecoration _cardDecoration(FlutterFlowTheme theme) => BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.alternate),
      );
}
