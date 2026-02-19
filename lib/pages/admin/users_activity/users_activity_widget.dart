import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'users_activity_model.dart';
import '../../../components/smart_back_button.dart';
import '../../admin/components/admin_section_container.dart';
import 'components/activity_stat_card.dart';
import 'components/activity_list_item.dart';
import 'components/top_user_item.dart';
import 'components/retention_item.dart';

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
                  color: FlutterFlowTheme.of(context)
                      .primary
                      .withValues(alpha: 0.15),
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
                  color: FlutterFlowTheme.of(context)
                      .primary
                      .withValues(alpha: 0.1),
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
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisExtent: 140, // Height for Stat Cards
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ActivityStatCard(
                        title: 'Total Usuarios',
                        value: '2,543',
                        icon: Icons.people_outline,
                        color: FlutterFlowTheme.of(context).primary),
                    ActivityStatCard(
                        title: 'Activos hoy',
                        value: '142',
                        icon: Icons.show_chart,
                        color: FlutterFlowTheme.of(context).secondary),
                    ActivityStatCard(
                        title: 'Nuevos (Mes)',
                        value: '85',
                        icon: Icons.person_add_outlined,
                        color: FlutterFlowTheme.of(context).tertiary),
                    ActivityStatCard(
                        title: 'Retención',
                        value: '87%',
                        icon: Icons.repeat,
                        color: FlutterFlowTheme.of(context).warning),
                  ],
                ),

                const SizedBox(height: 40),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recent Activity - 2 parts width
                    Expanded(
                      flex: 2,
                      child: AdminSectionContainer(
                        title: 'Actividad Reciente',
                        child: Column(
                          children: [
                            ActivityListItem(
                                name: 'Juan Pérez',
                                action: 'Completó una compra',
                                time: 'Hace 2 min',
                                icon: Icons.shopping_bag_outlined,
                                color: FlutterFlowTheme.of(context).secondary),
                            ActivityListItem(
                                name: 'María García',
                                action: 'Inició sesión',
                                time: 'Hace 5 min',
                                icon: Icons.login,
                                color: FlutterFlowTheme.of(context).primary),
                            ActivityListItem(
                                name: 'Carlos López',
                                action: 'Actualizó perfil',
                                time: 'Hace 12 min',
                                icon: Icons.edit_outlined,
                                color: FlutterFlowTheme.of(context).warning),
                            ActivityListItem(
                                name: 'Ana Smith',
                                action: 'Agregó favoritos',
                                time: 'Hace 25 min',
                                icon: Icons.favorite_border,
                                color: FlutterFlowTheme.of(context).tertiary),
                            ActivityListItem(
                                name: 'Pedro Diaz',
                                action: 'Consultó soporte',
                                time: 'Hace 1h',
                                icon: Icons.support_agent,
                                color: FlutterFlowTheme.of(context).info),
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
                          AdminSectionContainer(
                            title: 'Usuarios Top',
                            child: Column(
                              children: [
                                TopUserItem(
                                    position: 1,
                                    name: 'Roberto G.',
                                    stats: '150 compras',
                                    medalColor:
                                        FlutterFlowTheme.of(context).warning),
                                TopUserItem(
                                    position: 2,
                                    name: 'Laura M.',
                                    stats: '128 compras',
                                    medalColor: FlutterFlowTheme.of(context)
                                        .secondaryText),
                                TopUserItem(
                                    position: 3,
                                    name: 'Fernando T.',
                                    stats: '95 compras',
                                    medalColor:
                                        FlutterFlowTheme.of(context).tertiary),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          AdminSectionContainer(
                            title: 'Retención',
                            footer: 'Basado en últimos 90 días',
                            child: Column(
                              children: const [
                                RetentionItem(label: '1 día', value: '87%'),
                                RetentionItem(label: '7 días', value: '68%'),
                                RetentionItem(label: '30 días', value: '45%'),
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                mainAxisExtent: 140, // Height for Stat Cards
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ActivityStatCard(
                    title: 'Total Usuarios',
                    value: '2,543',
                    icon: Icons.people_outline,
                    color: FlutterFlowTheme.of(context).primary),
                ActivityStatCard(
                    title: 'Activos hoy',
                    value: '142',
                    icon: Icons.show_chart,
                    color: FlutterFlowTheme.of(context).secondary),
                ActivityStatCard(
                    title: 'Nuevos (Mes)',
                    value: '85',
                    icon: Icons.person_add_outlined,
                    color: FlutterFlowTheme.of(context).tertiary),
                ActivityStatCard(
                    title: 'Retención',
                    value: '87%',
                    icon: Icons.repeat,
                    color: FlutterFlowTheme.of(context).warning),
              ],
            ),

            const SizedBox(height: 24),

            AdminSectionContainer(
              title: 'Actividad Reciente',
              child: Column(
                children: [
                  ActivityListItem(
                      name: 'Juan Pérez',
                      action: 'Completó una compra',
                      time: 'Hace 2 min',
                      icon: Icons.shopping_bag_outlined,
                      color: FlutterFlowTheme.of(context).secondary),
                  ActivityListItem(
                      name: 'María García',
                      action: 'Inició sesión',
                      time: 'Hace 5 min',
                      icon: Icons.login,
                      color: FlutterFlowTheme.of(context).primary),
                  ActivityListItem(
                      name: 'Carlos López',
                      action: 'Actualizó perfil',
                      time: 'Hace 12 min',
                      icon: Icons.edit_outlined,
                      color: FlutterFlowTheme.of(context).warning),
                  ActivityListItem(
                      name: 'Ana Smith',
                      action: 'Agregó favoritos',
                      time: 'Hace 25 min',
                      icon: Icons.favorite_border,
                      color: FlutterFlowTheme.of(context).tertiary),
                ],
              ),
            ),

            const SizedBox(height: 24),

            AdminSectionContainer(
              title: 'Usuarios Top',
              child: Column(
                children: [
                  TopUserItem(
                      position: 1,
                      name: 'Roberto G.',
                      stats: '150 compras',
                      medalColor: FlutterFlowTheme.of(context).warning),
                  TopUserItem(
                      position: 2,
                      name: 'Laura M.',
                      stats: '128 compras',
                      medalColor: FlutterFlowTheme.of(context).secondaryText),
                  TopUserItem(
                      position: 3,
                      name: 'Fernando T.',
                      stats: '95 compras',
                      medalColor: FlutterFlowTheme.of(context).tertiary),
                ],
              ),
            ),

            const SizedBox(height: 24),

            AdminSectionContainer(
              title: 'Retención',
              child: Column(
                children: const [
                  RetentionItem(label: '1 día', value: '87%'),
                  RetentionItem(label: '7 días', value: '68%'),
                  RetentionItem(label: '30 días', value: '45%'),
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
            color: FlutterFlowTheme.of(context)
                .secondaryText
                .withValues(alpha: 0.7),
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
