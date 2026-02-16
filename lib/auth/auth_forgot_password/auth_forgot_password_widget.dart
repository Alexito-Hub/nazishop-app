import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/nazishop_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_forgot_password_model.dart';
export 'auth_forgot_password_model.dart';

class AuthForgotPasswordWidget extends StatefulWidget {
  const AuthForgotPasswordWidget({super.key});

  static String routeName = 'auth_forgot_password';
  static String routePath = '/authForgotPassword';

  @override
  State<AuthForgotPasswordWidget> createState() =>
      _AuthForgotPasswordWidgetState();
}

class _AuthForgotPasswordWidgetState extends State<AuthForgotPasswordWidget>
    with TickerProviderStateMixin {
  late AuthForgotPasswordModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Design constants removed – using FlutterFlowTheme tokens instead.

  // Security State
  bool _is2FAEnabled = false;
  bool _isBiometricEnabled = false;
  bool _isLoadingSecurity = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthForgotPasswordModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    if (_isLoggedIn) {
      _loadSecuritySettings();
    }
  }

  Future<void> _loadSecuritySettings() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _is2FAEnabled = doc.data()?['is2FAEnabled'] ?? false;
          _isBiometricEnabled = doc.data()?['isBiometricEnabled'] ?? false;
          _isLoadingSecurity = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading security settings: $e');
      if (mounted) setState(() => _isLoadingSecurity = false);
    }
  }

  Future<void> _toggleSetting(String field, bool value) async {
    setState(() {
      if (field == 'is2FAEnabled') _is2FAEnabled = value;
      if (field == 'isBiometricEnabled') _isBiometricEnabled = value;
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
      // Revert if error
      if (mounted) {
        setState(() {
          if (field == 'is2FAEnabled') _is2FAEnabled = !value;
          if (field == 'isBiometricEnabled') _isBiometricEnabled = !value;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  // Use auth_util getter if available, otherwise check currentUserUid
  bool get _isLoggedIn => currentUserUid.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Stack(
        children: [
          // Main Layout
          _isLoggedIn
              ? (_isLoadingSecurity
                  ? Center(
                      child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary))
                  : _buildSecurityDashboard())
              : SafeArea(child: _buildForgotPasswordForm()),

          // Back Button (Guest Mode Only)
          if (!_isLoggedIn)
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .primaryBackground
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12)),
                  child: BackButton(
                      color: FlutterFlowTheme.of(context).primaryText),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 🔐 MODE 1: LOGGED IN SECURITY DASHBOARD
  // ===========================================================================
  Widget _buildSecurityDashboard() {
    if (!_isDesktop) {
      // Mobile Layout con SliverAppBar
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            surfaceTintColor: FlutterFlowTheme.of(context).primaryBackground,
            pinned: true,
            floating: true,
            elevation: 0,
            leadingWidth: 70,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context)
                    .alternate
                    .withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child:
                  BackButton(color: FlutterFlowTheme.of(context).primaryText),
            ),
            centerTitle: true,
            title: Text(
              'Seguridad',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontWeight: FontWeight.w900,
                fontSize: 24,
                letterSpacing: 1.0,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSecurityContent(isMobile: true),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Desktop Layout
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Centro de Seguridad',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gestiona la protección de tu cuenta y dispositivos',
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              sliver: SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _buildSecurityContent(isMobile: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityContent({required bool isMobile}) {
    if (!isMobile) {
      // Desktop Multi-Column Layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Col 1: Password
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Contraseña'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: _cardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.mark_email_read_outlined,
                                  color: FlutterFlowTheme.of(context).primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Correo Vinculado',
                                        style: GoogleFonts.outfit(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 12)),
                                    Text(currentUserEmail,
                                        style: GoogleFonts.outfit(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 16)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(
                              color: FlutterFlowTheme.of(context).alternate),
                          const SizedBox(height: 20),
                          Text(
                            'Para cambiar tu contraseña, te enviaremos un enlace.',
                            style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                if (currentUserEmail.isEmpty) return;
                                await authManager.resetPassword(
                                    email: currentUserEmail);
                                if (mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Enlace enviado a $currentUserEmail'),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).primary,
                                  ));
                                }
                              },
                              icon: const Icon(Icons.send_rounded, size: 18),
                              label: const Text('Enviar Correo'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                side: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primary
                                        .withValues(alpha: 0.5)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Col 2: Advanced Security
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Protección Adicional'),
                    Container(
                      decoration: _cardDecoration,
                      child: Column(
                        children: [
                          SwitchListTile(
                            value: _is2FAEnabled,
                            onChanged: (val) =>
                                _toggleSetting('is2FAEnabled', val),
                            activeThumbColor:
                                FlutterFlowTheme.of(context).primary,
                            tileColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Text('2FA',
                                style: GoogleFonts.outfit(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 16)),
                            subtitle: Text('Código extra al iniciar sesión.',
                                style: GoogleFonts.outfit(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 13)),
                            secondary: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .alternate
                                        .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(Icons.security_rounded,
                                    color: FlutterFlowTheme.of(context).info)),
                          ),
                          Divider(
                              color: FlutterFlowTheme.of(context).alternate,
                              height: 1),
                          SwitchListTile(
                            value: _isBiometricEnabled,
                            onChanged: (val) =>
                                _toggleSetting('isBiometricEnabled', val),
                            activeThumbColor:
                                FlutterFlowTheme.of(context).primary,
                            tileColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Text('Biometría',
                                style: GoogleFonts.outfit(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 16)),
                            subtitle: Text('FaceID o Huella digital.',
                                style: GoogleFonts.outfit(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 13)),
                            secondary: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .alternate
                                        .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(Icons.fingerprint_rounded,
                                    color:
                                        FlutterFlowTheme.of(context).primary)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 32),
          // Devices Full Width
          _buildSectionTitle('Dispositivos'),
          Container(
            decoration: _cardDecoration,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.laptop_mac_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText),
                  title: Text('Sesión Actual',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primaryText)),
                  subtitle: Text('Online • Ahora',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primary,
                          fontSize: 12)),
                  trailing: Icon(Icons.circle,
                      size: 8, color: FlutterFlowTheme.of(context).success),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Mobile Layout
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Password Section
        _buildSectionTitle('Contraseña'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.mark_email_read_outlined,
                      color: FlutterFlowTheme.of(context).primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Correo Vinculado',
                            style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 12)),
                        Text(currentUserEmail,
                            style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: FlutterFlowTheme.of(context).alternate),
              const SizedBox(height: 20),
              Text(
                'Para cambiar tu contraseña, te enviaremos un enlace seguro a tu correo.',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 14),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (currentUserEmail.isEmpty) return;
                    await authManager.resetPassword(email: currentUserEmail);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Enlace enviado a $currentUserEmail'),
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                      ));
                    }
                  },
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Enviar Correo de Restablecimiento'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: FlutterFlowTheme.of(context).primaryText,
                    side: BorderSide(
                        color: FlutterFlowTheme.of(context)
                            .primary
                            .withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // 2. Advanced Security
        _buildSectionTitle('Protección Adicional'),
        Container(
          decoration: _cardDecoration,
          child: Column(
            children: [
              SwitchListTile(
                value: _is2FAEnabled,
                onChanged: (val) => _toggleSetting('is2FAEnabled', val),
                activeThumbColor: FlutterFlowTheme.of(context).primary,
                tileColor: FlutterFlowTheme.of(context).secondaryBackground,
                title: Text('Autenticación en Dos Pasos (2FA)',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16)),
                subtitle: Text(
                    'Solicita un código extra al iniciar sesión en dispositivos nuevos.',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 13)),
                secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .alternate
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.security_rounded,
                        color: FlutterFlowTheme.of(context).info)),
              ),
              Divider(color: FlutterFlowTheme.of(context).alternate, height: 1),
              SwitchListTile(
                value: _isBiometricEnabled,
                onChanged: (val) => _toggleSetting('isBiometricEnabled', val),
                activeThumbColor: FlutterFlowTheme.of(context).primary,
                tileColor: FlutterFlowTheme.of(context).secondaryBackground,
                title: Text('Desbloqueo Biométrico',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16)),
                subtitle: Text('Usa FaceID o Huella para acceder rápidamente.',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 13)),
                secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .alternate
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.fingerprint_rounded,
                        color: FlutterFlowTheme.of(context).primary)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // 3. Devices
        _buildSectionTitle('Dispositivos'),
        Container(
          decoration: _cardDecoration,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.laptop_mac_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText),
                title: Text('Sesión Actual',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText)),
                subtitle: Text('Online • Ahora',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 12)),
                trailing: Icon(Icons.circle,
                    size: 8, color: FlutterFlowTheme.of(context).success),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  // ===========================================================================
  // 🔓 MODE 2: GUEST FORGOT PASSWORD
  // ===========================================================================
  Widget _buildForgotPasswordForm() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recuperar Contraseña',
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ingresa el correo electrónico asociado a tu cuenta y te enviaremos un enlace para restablecerla.',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 16),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: _cardDecoration,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _model.emailAddressTextController,
                      focusNode: _model.emailAddressFocusNode,
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primaryText),
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        labelStyle: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        prefixIcon: Icon(Icons.email_outlined,
                            color: FlutterFlowTheme.of(context).secondaryText),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_model.emailAddressTextController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Ingresa tu correo')));
                            return;
                          }
                          await authManager.resetPassword(
                            email: _model.emailAddressTextController.text,
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Correo enviado. Revisa tu bandeja.')));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Enviar Enlace',
                          style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).tertiary),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- Helpers ---
  BoxDecoration get _cardDecoration => BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      );

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2),
      ),
    );
  }
}
