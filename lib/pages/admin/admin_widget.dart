import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_model.dart';
import '/pages/admin/admin_auth_guard.dart';
import '/auth/nazishop_auth/auth_util.dart';
import '../../components/smart_back_button.dart';

import 'package:flutter/material.dart';

import 'admin_model.dart';
export 'admin_model.dart';

import 'package:google_fonts/google_fonts.dart';

import 'components/admin_stats_grid.dart';
import 'components/admin_management_grid.dart';

class AdminWidget extends StatefulWidget {
  const AdminWidget({super.key});

  static String routeName = 'admin';
  static String routePath = '/admin';

  @override
  State<AdminWidget> createState() => _AdminWidgetState();
}

class _AdminWidgetState extends State<AdminWidget> {
  late AdminModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminModel());

    _model.onDataChanged = () {
      if (mounted) setState(() {});
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loggedIn && (currentUser?.isAdmin ?? false)) {
        _model.loadDashboardStats();
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check for desktop width
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final theme = FlutterFlowTheme.of(context);

    return AdminAuthGuard(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: theme.primaryBackground,
          body: SafeArea(
            child: isDesktop
                ? _buildDesktopLayout(context)
                : _buildMobileLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: theme.primaryBackground,
          surfaceTintColor: theme.primaryBackground,
          pinned: true,
          floating: true,
          elevation: 0,
          leadingWidth: 70,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              shape: BoxShape.circle,
              border: Border.all(color: theme.alternate, width: 1),
            ),
            child: SmartBackButton(color: theme.primaryText),
          ),
          centerTitle: true,
          title: Text(
            'Panel de Control',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 12),
                AdminStatsGrid(
                  stats: _model.getStatsMap(),
                  isLoading: _model.isLoadingStats,
                ),
                const SizedBox(height: 24),
                const AdminManagementGrid(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
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
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Panel de Control',
                              style: GoogleFonts.outfit(
                                color: theme.primaryText,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bienvenido al centro de administración',
                              style: GoogleFonts.outfit(
                                color: theme.secondaryText,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    AdminStatsGrid(
                      stats: _model.getStatsMap(),
                      isLoading: _model.isLoadingStats,
                    ),
                    const SizedBox(height: 40),
                    // AdminManagementGrid removed for desktop as it's in the sidebar
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
