import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_model.dart';
import '/pages/admin/admin_auth_guard.dart';
import '/auth/nazishop_auth/auth_util.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'admin_model.dart';
export 'admin_model.dart';

import 'components/admin_header.dart';
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
    return AdminAuthGuard(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const AdminHeader(),
                  AdminStatsGrid(
                    stats: _model.getStatsMap(),
                    isLoading: _model.isLoadingStats,
                  ),
                  const AdminManagementGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
