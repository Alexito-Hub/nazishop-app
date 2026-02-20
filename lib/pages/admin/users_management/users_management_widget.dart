import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_model.dart';

import '/backend/admin_service.dart';
import '../../../../backend/security_manager.dart';
import '/components/design_system.dart';
import '../components/security_check_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/models/user_model.dart';
import 'components/user_card.dart';

import 'users_management_model.dart';
export 'users_management_model.dart';

class UsersManagementWidget extends StatefulWidget {
  const UsersManagementWidget({super.key});

  static String routeName = 'users_management';
  static String routePath = '/admin/users';

  @override
  State<UsersManagementWidget> createState() => _UsersManagementWidgetState();
}

class _UsersManagementWidgetState extends State<UsersManagementWidget> {
  // Local state management to ensure reliability
  bool _isLoading = true;
  bool _isAuthorized = false;
  List<User> _users = [];
  String? _filterRole;

  // Use model only for logic reuse if needed, or deprecate it
  late UsersManagementModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UsersManagementModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSecurity());
  }

  Future<void> _checkSecurity() async {
    // 1. Check if we already have a valid session
    if (SecurityManager().isSessionValid) {
      if (mounted) {
        setState(() {
          _isAuthorized = true;
          _isLoading =
              true; // Ensure loading starts immediately if auth is pre-approved
        });
        _loadUsers();
      }
      return;
    }

    // 2. If not, show security dialog
    final authorized = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SecurityCheckDialog(),
    );

    if (mounted) {
      if (authorized == true) {
        setState(() {
          _isAuthorized = true;
          _isLoading = true;
        });
        _loadUsers();
      } else {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _loadUsers() async {
    try {
      final users = await AdminService.getUsers();
      if (mounted) {
        setState(() {
          _users = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error cargando usuarios: $e',
              style: TextStyle(color: FlutterFlowTheme.of(context).primaryText),
            ),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  List<User> get _filteredUsers {
    if (_filterRole == null) return _users;
    return _users.where((u) => u.role == _filterRole).toList();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthorized) {
      return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final theme = FlutterFlowTheme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body:
            isDesktop ? _buildDesktopLayout(theme) : _buildMobileLayout(theme),
      ),
    );
  }

  // --- MOBILE LAYOUT ---
  Widget _buildMobileLayout(FlutterFlowTheme theme) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        DSMobileAppBar(
          title: 'Gestión de Usuarios',
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: theme.primaryText),
              onPressed: _loadUsers,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Todos', null, theme),
                const SizedBox(width: 8),
                _buildFilterChip('Admins', 'admin', theme),
                const SizedBox(width: 8),
                _buildFilterChip('Soporte', 'support', theme),
                const SizedBox(width: 8),
                _buildFilterChip('Usuarios', 'user', theme),
              ],
            ),
          ),
        ),
        if (_isLoading)
          SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: theme.primary),
            ),
          )
        else if (_filteredUsers.isEmpty)
          SliverFillRemaining(child: _buildEmptyState(theme))
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final user = _filteredUsers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UserCard(
                    user: user,
                    onUpdate: _loadUsers,
                  ),
                );
              }, childCount: _filteredUsers.length),
            ),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }

  // --- DESKTOP LAYOUT ---
  Widget _buildDesktopLayout(FlutterFlowTheme theme) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gestión de Usuarios',
                          style: GoogleFonts.outfit(
                            color: theme.primaryText,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Administra permisos, roles y saldos de usuarios',
                          style: GoogleFonts.outfit(
                            color: theme.secondaryText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Filters & Refresh
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFilterChip('Todos', null, theme),
                        const SizedBox(width: 12),
                        _buildFilterChip('Admins', 'admin', theme),
                        const SizedBox(width: 12),
                        _buildFilterChip('Soporte', 'support', theme),
                        const SizedBox(width: 12),
                        _buildFilterChip('Usuarios', 'user', theme),
                        const SizedBox(width: 24),
                        // Refresh Button
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.alternate),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.refresh, color: theme.primaryText),
                            onPressed: _loadUsers,
                            tooltip: 'Recargar',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: theme.primary),
                ),
              )
            else if (_filteredUsers.isEmpty)
              SliverFillRemaining(child: _buildEmptyState(theme))
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 80),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 220, // Adjusted for User Card content
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return UserCard(
                      user: _filteredUsers[index],
                      onUpdate: _loadUsers,
                    );
                  }, childCount: _filteredUsers.length),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(FlutterFlowTheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              shape: BoxShape.circle,
              border: Border.all(color: theme.alternate),
            ),
            child: Icon(
              Icons.people_outline,
              size: 40,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron usuarios',
            style: GoogleFonts.outfit(color: theme.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? role, FlutterFlowTheme theme) {
    final isSelected = _filterRole == role;
    return InkWell(
      onTap: () => setState(() => _filterRole = role),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : theme.secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.primary : theme.alternate,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? theme.primaryText : theme.secondaryText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
