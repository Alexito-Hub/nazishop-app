import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../../components/smart_back_button.dart';
import 'user_profile_model.dart';
export 'user_profile_model.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({
    super.key,
    this.name,
    this.email,
    this.purchases,
    this.totalSpent,
    this.isActive,
    this.flag,
  });

  final String? name;
  final String? email;
  final String? purchases;
  final String? totalSpent;
  final String? isActive;
  final String? flag;

  static String routeName = 'user_profile';
  static String routePath = '/userProfile';

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  late UserProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserProfileModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            // Background Elements
            Positioned(
              top: -100,
              right: -100,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 1100) {
                  return _buildDesktopLayout();
                } else {
                  return _buildMobileLayout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: FlutterFlowTheme.of(context).transparent,
          expandedHeight: 120,
          pinned: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SmartBackButton(
                  color: FlutterFlowTheme.of(context).primaryText),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Perfil de Usuario',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                    FlutterFlowTheme.of(context).transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildProfileCard(isDesktop: false),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context)
                      .secondaryBackground
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: FlutterFlowTheme.of(context).alternate),
                ),
                child:
                    BackButton(color: FlutterFlowTheme.of(context).primaryText),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildProfileCard(isDesktop: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({required bool isDesktop}) {
    bool active = widget.isActive == 'true';
    return Container(
      padding: EdgeInsets.all(isDesktop ? 48 : 24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context)
            .secondaryBackground
            .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
                color:
                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.3),
                    width: 2)),
            child: Center(
              child: Text(
                (widget.name ?? 'U').substring(0, 1).toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.flag ?? '🌎',
                style: const TextStyle(fontSize: 24.0),
              ),
              const SizedBox(width: 12.0),
              Text(
                widget.name ?? 'Usuario',
                style: GoogleFonts.outfit(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Container(
            decoration: BoxDecoration(
                color: active
                    ? FlutterFlowTheme.of(context)
                        .success
                        .withValues(alpha: 0.1)
                    : FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                    color: active
                        ? FlutterFlowTheme.of(context)
                            .success
                            .withValues(alpha: 0.3)
                        : FlutterFlowTheme.of(context)
                            .primary
                            .withValues(alpha: 0.3))),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              active ? '● Activo' : '● Inactivo',
              style: GoogleFonts.outfit(
                color: active
                    ? FlutterFlowTheme.of(context).success
                    : FlutterFlowTheme.of(context).primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 48.0),
          _buildInfoRow(isDesktop),
          const SizedBox(height: 48.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actividad Reciente',
                style: GoogleFonts.outfit(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText),
              ),
              const SizedBox(height: 24.0),
              _buildActivityItem(
                  'Compró Netflix Premium', 'Hace 2 días', Icons.shopping_bag),
              _buildActivityItem(
                  'Actualizó su perfil', 'Hace 5 días', Icons.edit),
              _buildActivityItem(
                  'Agregó método de pago', 'Hace 1 semana', Icons.credit_card),
            ],
          ),
          const SizedBox(height: 48.0),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (active) {
                  CustomSnackBar.warning(
                    context,
                    'El usuario ha sido desactivado correctamente',
                    title: 'Usuario Desactivado',
                  );
                } else {
                  CustomSnackBar.success(
                    context,
                    'El usuario ha sido activado correctamente',
                    title: 'Usuario Activado',
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: active
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                active ? 'Desactivar Usuario' : 'Activar Usuario',
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(bool isDesktop) {
    List<Widget> cards = [
      Expanded(
          child: _buildInfoCard(
              'Email', widget.email ?? 'No disponible', Icons.email)),
      const SizedBox(width: 16, height: 16),
      Expanded(
          child: _buildInfoCard(
              'Total Gastado', widget.totalSpent ?? '\$0', Icons.attach_money)),
    ];

    if (isDesktop) {
      return Row(children: cards);
    } else {
      return Column(children: [
        _buildInfoCard('Email', widget.email ?? 'No disponible', Icons.email),
        const SizedBox(height: 16),
        _buildInfoCard(
            'Compras Totales', widget.purchases ?? '0', Icons.shopping_cart),
        const SizedBox(height: 16),
        _buildInfoCard(
            'Total Gastado', widget.totalSpent ?? '\$0', Icons.attach_money),
        const SizedBox(height: 16),
        _buildInfoCard('Registro', 'Hace 3 meses', Icons.calendar_today),
      ]);
    }
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context)
            .secondaryBackground
            .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24.0, color: FlutterFlowTheme.of(context).primary),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                      fontSize: 12.0,
                      color: FlutterFlowTheme.of(context).secondaryText),
                ),
                const SizedBox(height: 4.0),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).primaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context)
            .secondaryBackground
            .withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Row(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context)
                  .secondaryBackground
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                size: 20.0, color: FlutterFlowTheme.of(context).secondaryText),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: FlutterFlowTheme.of(context).primaryText),
                ),
                Text(
                  time,
                  style: GoogleFonts.outfit(
                      fontSize: 12.0,
                      color: FlutterFlowTheme.of(context).secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
