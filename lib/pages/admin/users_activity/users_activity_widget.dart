import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'users_activity_model.dart';
import '../../../components/smart_back_button.dart';
export 'users_activity_model.dart';

class UsersActivityWidget extends StatefulWidget {
  const UsersActivityWidget({super.key});

  @override
  State<UsersActivityWidget> createState() => _UsersActivityWidgetState();
}

class _UsersActivityWidgetState extends State<UsersActivityWidget> {
  late UsersActivityModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UsersActivityModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.15),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),

          // Main Content
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return _buildDesktopLayout();
              } else {
                return _buildMobileLayout();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar placeholder or actual content if needed
        Container(
          width: 80,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context)
                .primaryBackground
                .withValues(alpha: 0.3),
            border: Border(
                right:
                    BorderSide(color: FlutterFlowTheme.of(context).alternate)),
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Back Button
                  SmartBackButton(
                      color: FlutterFlowTheme.of(context).secondaryText),
                ],
              ),
            ),
          ),
        ),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),

                // Stats Grid
                GridView(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisExtent: 140, // Height for Stat Cards
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard(
                        'Total Usuarios',
                        '2,543',
                        Icons.people_outline,
                        FlutterFlowTheme.of(context).primary),
                    _buildStatCard('Activos hoy', '142', Icons.show_chart,
                        FlutterFlowTheme.of(context).secondary),
                    _buildStatCard(
                        'Nuevos (Mes)',
                        '85',
                        Icons.person_add_outlined,
                        FlutterFlowTheme.of(context).tertiary),
                    _buildStatCard('Retención', '87%', Icons.repeat,
                        FlutterFlowTheme.of(context).warning),
                  ],
                ),

                const SizedBox(height: 40),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recent Activity - 2 parts width
                    Expanded(
                      flex: 2,
                      child: _buildSectionContainer(
                        title: 'Actividad Reciente',
                        child: Column(
                          children: [
                            _buildActivityItem(
                                'Juan Pérez',
                                'Completó una compra',
                                'Hace 2 min',
                                Icons.shopping_bag_outlined,
                                FlutterFlowTheme.of(context).secondary),
                            _buildActivityItem(
                                'María García',
                                'Inició sesión',
                                'Hace 5 min',
                                Icons.login,
                                FlutterFlowTheme.of(context).primary),
                            _buildActivityItem(
                                'Carlos López',
                                'Actualizó perfil',
                                'Hace 12 min',
                                Icons.edit_outlined,
                                FlutterFlowTheme.of(context).warning),
                            _buildActivityItem(
                                'Ana Smith',
                                'Agregó a favoritos',
                                'Hace 25 min',
                                Icons.favorite_border,
                                FlutterFlowTheme.of(context).tertiary),
                            _buildActivityItem(
                                'Pedro Diaz',
                                'Consultó soporte',
                                'Hace 1h',
                                Icons.support_agent,
                                FlutterFlowTheme.of(context).info),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 24),

                    // Top Users - 1 part width
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildSectionContainer(
                            title: 'Usuarios Top',
                            child: Column(
                              children: [
                                _buildTopUserItem(
                                    1,
                                    'Roberto G.',
                                    '150 compras',
                                    FlutterFlowTheme.of(context).warning),
                                _buildTopUserItem(2, 'Laura M.', '128 compras',
                                    FlutterFlowTheme.of(context).secondaryText),
                                _buildTopUserItem(
                                    3,
                                    'Fernando T.',
                                    '95 compras',
                                    FlutterFlowTheme.of(context).tertiary),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildSectionContainer(
                            title: 'Retención',
                            footer: 'Basado en últimos 90 días',
                            child: Column(
                              children: [
                                _buildRetentionItem('1 día', '87%'),
                                _buildRetentionItem('7 días', '68%'),
                                _buildRetentionItem('30 días', '45%'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).transparent,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).transparent,
        elevation: 0,
        leading:
            SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
        title: Text(
          'Actividad de Usuarios',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats Grid 2x2 for mobile
            GridView(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                mainAxisExtent: 140, // Height for Stat Cards
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard('Total Usuarios', '2,543', Icons.people_outline,
                    FlutterFlowTheme.of(context).primary),
                _buildStatCard('Activos hoy', '142', Icons.show_chart,
                    FlutterFlowTheme.of(context).secondary),
                _buildStatCard('Nuevos (Mes)', '85', Icons.person_add_outlined,
                    FlutterFlowTheme.of(context).tertiary),
                _buildStatCard('Retención', '87%', Icons.repeat,
                    FlutterFlowTheme.of(context).warning),
              ],
            ),

            const SizedBox(height: 24),

            _buildSectionContainer(
              title: 'Actividad Reciente',
              child: Column(
                children: [
                  _buildActivityItem(
                      'Juan Pérez',
                      'Completó una compra',
                      'Hace 2 min',
                      Icons.shopping_bag_outlined,
                      FlutterFlowTheme.of(context).secondary),
                  _buildActivityItem(
                      'María García',
                      'Inició sesión',
                      'Hace 5 min',
                      Icons.login,
                      FlutterFlowTheme.of(context).primary),
                  _buildActivityItem(
                      'Carlos López',
                      'Actualizó perfil',
                      'Hace 12 min',
                      Icons.edit_outlined,
                      FlutterFlowTheme.of(context).warning),
                  _buildActivityItem(
                      'Ana Smith',
                      'Agregó favoritos',
                      'Hace 25 min',
                      Icons.favorite_border,
                      FlutterFlowTheme.of(context).tertiary),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionContainer(
              title: 'Usuarios Top',
              child: Column(
                children: [
                  _buildTopUserItem(1, 'Roberto G.', '150 compras',
                      FlutterFlowTheme.of(context).warning),
                  _buildTopUserItem(2, 'Laura M.', '128 compras',
                      FlutterFlowTheme.of(context).secondaryText),
                  _buildTopUserItem(3, 'Fernando T.', '95 compras',
                      FlutterFlowTheme.of(context).tertiary),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionContainer(
              title: 'Retención',
              child: Column(
                children: [
                  _buildRetentionItem('1 día', '87%'),
                  _buildRetentionItem('7 días', '68%'),
                  _buildRetentionItem('30 días', '45%'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actividad de Usuarios',
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Monitoreo en tiempo real del comportamiento de usuarios',
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.7),
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionContainer(
      {required String title, required Widget child, String? footer}) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (footer != null)
                  Text(
                    footer,
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context)
                          .secondaryText
                          .withValues(alpha: 0.5),
                      fontSize: 12.0,
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: FlutterFlowTheme.of(context).alternate),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color:
            FlutterFlowTheme.of(context).secondaryBackground.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FlutterFlowTheme.of(context).secondaryBackground.withValues(alpha: 0.08),
            FlutterFlowTheme.of(context).secondaryBackground.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      String name, String action, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  action,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context)
                        .secondaryText
                        .withValues(alpha: 0.6),
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.outfit(
              color:
                  FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.4),
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUserItem(
      int position, String name, String stats, Color medalColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            FlutterFlowTheme.of(context).secondaryBackground.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: medalColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$position',
                style: GoogleFonts.outfit(
                  color: medalColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Text(
                  stats,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetentionItem(String label, String value) {
    // Simple bar visual
    final double percentage = double.tryParse(value.replaceAll('%', '')) ?? 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context)
                      .secondaryText
                      .withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 200 *
                    (percentage /
                        100), // Approximate width based on context constraints
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
