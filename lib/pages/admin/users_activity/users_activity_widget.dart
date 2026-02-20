import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'users_activity_model.dart';
import '/components/design_system.dart';
import '/components/smart_back_button.dart';
import '../components/admin_section_container.dart';
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
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      body: Stack(
        children: [
          // Background glow blobs
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
                  color: theme.primary.withValues(alpha: 0.15),
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
                  color: theme.primary.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),

          // Responsive layout
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return _buildDesktopLayout(theme);
              } else {
                return _buildMobileLayout(theme);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(FlutterFlowTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar with back button
        Container(
          width: 80,
          height: double.infinity,
          decoration: BoxDecoration(
            color: theme.primaryBackground.withValues(alpha: 0.3),
            border: Border(right: BorderSide(color: theme.alternate)),
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      shape: BoxShape.circle,
                    ),
                    child: SmartBackButton(color: theme.primaryText),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Main content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 40),
                _buildStatsGrid(crossAxisExtent: 300, theme: theme),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildRecentActivity(theme)),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _buildTopUsersAndRetention(theme)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(FlutterFlowTheme theme) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const DSMobileAppBar(title: 'Actividad de Usuarios'),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatsGrid(crossAxisExtent: 250, theme: theme),
                const SizedBox(height: 24),
                _buildRecentActivity(theme),
                const SizedBox(height: 24),
                AdminSectionContainer(
                  title: 'Usuarios Top',
                  child: Column(
                    children: [
                      TopUserItem(
                          position: 1,
                          name: 'Roberto G.',
                          stats: '150 compras',
                          medalColor: theme.warning),
                      TopUserItem(
                          position: 2,
                          name: 'Laura M.',
                          stats: '128 compras',
                          medalColor: theme.secondaryText),
                      TopUserItem(
                          position: 3,
                          name: 'Fernando T.',
                          stats: '95 compras',
                          medalColor: theme.tertiary),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AdminSectionContainer(
                  title: 'Retención',
                  child: const Column(
                    children: [
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
        ),
      ],
    );
  }

  Widget _buildStatsGrid(
      {required double crossAxisExtent, required FlutterFlowTheme theme}) {
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: crossAxisExtent,
        mainAxisExtent: 140,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ActivityStatCard(
            title: 'Total Usuarios',
            value: '2,543',
            icon: Icons.people_outline,
            color: theme.primary),
        ActivityStatCard(
            title: 'Activos hoy',
            value: '142',
            icon: Icons.show_chart,
            color: theme.secondary),
        ActivityStatCard(
            title: 'Nuevos (Mes)',
            value: '85',
            icon: Icons.person_add_outlined,
            color: theme.tertiary),
        ActivityStatCard(
            title: 'Retención',
            value: '87%',
            icon: Icons.repeat,
            color: theme.warning),
      ],
    );
  }

  Widget _buildRecentActivity(FlutterFlowTheme theme) {
    return AdminSectionContainer(
      title: 'Actividad Reciente',
      child: Column(
        children: [
          ActivityListItem(
              name: 'Juan Pérez',
              action: 'Completó una compra',
              time: 'Hace 2 min',
              icon: Icons.shopping_bag_outlined,
              color: theme.secondary),
          ActivityListItem(
              name: 'María García',
              action: 'Inició sesión',
              time: 'Hace 5 min',
              icon: Icons.login,
              color: theme.primary),
          ActivityListItem(
              name: 'Carlos López',
              action: 'Actualizó perfil',
              time: 'Hace 12 min',
              icon: Icons.edit_outlined,
              color: theme.warning),
          ActivityListItem(
              name: 'Ana Smith',
              action: 'Agregó favoritos',
              time: 'Hace 25 min',
              icon: Icons.favorite_border,
              color: theme.tertiary),
          ActivityListItem(
              name: 'Pedro Diaz',
              action: 'Consultó soporte',
              time: 'Hace 1h',
              icon: Icons.support_agent,
              color: theme.secondary),
        ],
      ),
    );
  }

  Widget _buildTopUsersAndRetention(FlutterFlowTheme theme) {
    return Column(
      children: [
        AdminSectionContainer(
          title: 'Usuarios Top',
          child: Column(
            children: [
              TopUserItem(
                  position: 1,
                  name: 'Roberto G.',
                  stats: '150 compras',
                  medalColor: theme.warning),
              TopUserItem(
                  position: 2,
                  name: 'Laura M.',
                  stats: '128 compras',
                  medalColor: theme.secondaryText),
              TopUserItem(
                  position: 3,
                  name: 'Fernando T.',
                  stats: '95 compras',
                  medalColor: theme.tertiary),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AdminSectionContainer(
          title: 'Retención',
          footer: 'Basado en últimos 90 días',
          child: const Column(
            children: [
              RetentionItem(label: '1 día', value: '87%'),
              RetentionItem(label: '7 días', value: '68%'),
              RetentionItem(label: '30 días', value: '45%'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actividad de Usuarios',
          style: GoogleFonts.outfit(
            color: theme.primaryText,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Monitoreo en tiempo real del comportamiento de usuarios',
          style: GoogleFonts.outfit(
            color: theme.secondaryText.withValues(alpha: 0.7),
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
