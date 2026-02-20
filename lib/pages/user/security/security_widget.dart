import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/nazishop_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/auth/nazishop_auth/nazishop_auth_provider.dart';
import '/flutter_flow/nav/nav.dart';
import 'package:provider/provider.dart';
import '/services/biometric_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '/backend/user_service.dart';
import '/components/design_system.dart';
import 'components/device_session_card.dart';

class SecurityWidget extends StatefulWidget {
  const SecurityWidget({super.key});

  @override
  State<SecurityWidget> createState() => _SecurityWidgetState();
}

class _SecurityWidgetState extends State<SecurityWidget> {
  bool _is2FAEnabled = false;
  bool _isBiometricEnabled = false;
  bool _isLoadingSecurity = true;
  List<Map<String, dynamic>> _sessions = [];
  bool _loadingSessions = true;

  @override
  void initState() {
    super.initState();
    _loadSecuritySettings();
    _fetchSessions();
  }

  Future<void> _loadSecuritySettings() async {
    try {
      if (currentUserUid.isEmpty) {
        if (mounted) setState(() => _isLoadingSecurity = false);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      final biometricEnabled = await BiometricService.isEnabled();

      if (mounted) {
        setState(() {
          if (doc.exists) {
            _is2FAEnabled = doc.data()?['is2FAEnabled'] ?? false;
          }
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
        _sessions = List<Map<String, dynamic>>.from(sessions);
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
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesión cerrada')),
        );
        _fetchSessions();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cerrar la sesión')),
        );
      }
    }
  }

  Future<void> _revokeAllOthers() async {
    final success = await UserService.revokeAllOtherSessions();
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Otras sesiones cerradas')),
        );
        _fetchSessions();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cerrar otras sesiones')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    if (_isLoadingSecurity) {
      return Scaffold(
        backgroundColor: theme.primaryBackground,
        body: Center(child: CircularProgressIndicator(color: theme.primary)),
      );
    }

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: isDesktop ? _buildDesktopLayout(theme) : _buildMobileLayout(theme),
    );
  }

  // ── MOBILE ─────────────────────────────────────────────────────────────────
  Widget _buildMobileLayout(FlutterFlowTheme theme) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const DSMobileAppBar(title: 'Seguridad'),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverToBoxAdapter(
            child: _buildMobileContent(theme),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }

  Widget _buildMobileContent(FlutterFlowTheme theme) {
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

  // ── DESKTOP ────────────────────────────────────────────────────────────────
  Widget _buildDesktopLayout(FlutterFlowTheme theme) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Desktop page header (matches DS style)
              Text(
                'Centro de Seguridad',
                style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gestiona tu contraseña, 2FA y sesiones activas',
                style: GoogleFonts.outfit(
                  color: theme.secondaryText,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
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
          ),
        ),
      ),
    );
  }

  // ── SHARED SECTIONS ────────────────────────────────────────────────────────
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
              const SizedBox(height: 16),
              _buildVerificationOptions(theme),
              const SizedBox(height: 20),
              Divider(color: theme.alternate),
              const SizedBox(height: 20),
              Text(
                'Si olvidaste tu contraseña, enviaremos un enlace de recuperación.',
                style: GoogleFonts.outfit(
                    color: theme.secondaryText, fontSize: 13),
              ),
              const SizedBox(height: 12),
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
                  child: const Text('Enviar Correo de Recuperación'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationOptions(FlutterFlowTheme theme) {
    final authProvider = Provider.of<NaziShopAuthProvider>(context);
    return Column(
      children: [
        // Email Verification
        ListTile(
          leading: Icon(Icons.mark_email_read_outlined,
              color: authProvider.currentUser?.emailVerified == true
                  ? theme.success
                  : theme.primaryText),
          title: Text('Correo Electrónico',
              style: GoogleFonts.outfit(color: theme.primaryText)),
          subtitle: Text(
              authProvider.currentUser?.emailVerified == true
                  ? 'Verificado'
                  : 'No verificado',
              style:
                  GoogleFonts.outfit(color: theme.secondaryText, fontSize: 12)),
          trailing: authProvider.currentUser?.emailVerified == true
              ? Icon(Icons.check_circle, color: theme.success)
              : Icon(Icons.arrow_forward_ios,
                  size: 16, color: theme.secondaryText),
          onTap: authProvider.currentUser?.emailVerified == true
              ? null
              : () => context.pushNamed('email_verification'),
          contentPadding: EdgeInsets.zero,
        ),
        Divider(color: theme.alternate, height: 1),

        // Set Password (if needed - currently we show standard set password btn)
        ListTile(
          leading: Icon(Icons.password_rounded, color: theme.primaryText),
          title: Text('Contraseña',
              style: GoogleFonts.outfit(color: theme.primaryText)),
          subtitle: Text('Establecer nueva contraseña',
              style:
                  GoogleFonts.outfit(color: theme.secondaryText, fontSize: 12)),
          trailing: Icon(Icons.arrow_forward_ios,
              size: 16, color: theme.secondaryText),
          onTap: () => context.pushNamed('set_password'),
          contentPadding: EdgeInsets.zero,
        ),
        Divider(color: theme.alternate, height: 1),

        // Phone Verification
        ListTile(
          leading: Icon(Icons.phone_iphone_rounded, color: theme.primaryText),
          title: Text('Número de Teléfono',
              style: GoogleFonts.outfit(color: theme.primaryText)),
          subtitle: Text(
              currentUserPhoneNumber.isNotEmpty
                  ? currentUserPhoneNumber
                  : 'No registrado',
              style:
                  GoogleFonts.outfit(color: theme.secondaryText, fontSize: 12)),
          trailing: Icon(Icons.arrow_forward_ios,
              size: 16, color: theme.secondaryText),
          onTap: () => context.pushNamed('phone_verification'),
          contentPadding: EdgeInsets.zero,
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
                title: Text('Autenticación 2FA',
                    style: GoogleFonts.outfit(color: theme.primaryText)),
                subtitle: Text('Código extra al iniciar sesión.',
                    style: GoogleFonts.outfit(
                        color: theme.secondaryText, fontSize: 12)),
                secondary: Icon(Icons.security_rounded, color: theme.info),
              ),
              Divider(color: theme.alternate, height: 1),
              if (!kIsWeb) ...[
                SwitchListTile(
                  value: _isBiometricEnabled,
                  onChanged: (val) => _toggleSetting('isBiometricEnabled', val),
                  title: Text('Biometría',
                      style: GoogleFonts.outfit(color: theme.primaryText)),
                  subtitle: Text('FaceID o Huella digital',
                      style: GoogleFonts.outfit(
                          color: theme.secondaryText, fontSize: 12)),
                  secondary:
                      Icon(Icons.fingerprint_rounded, color: theme.primary),
                ),
              ],
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

  Widget _buildSessionCard(
      Map<String, dynamic> session, FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DeviceSessionCard(
        session: session,
        onRevoke: () => _revokeSession(session['sessionId']),
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
