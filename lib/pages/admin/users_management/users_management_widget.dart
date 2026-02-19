import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_model.dart';
import '/auth/guards/super_admin_guard.dart';
import '/backend/admin_service.dart';
import '../../../../backend/security_manager.dart';
import '../../../components/smart_back_button.dart';
import '../components/security_check_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/models/user_model.dart';
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          leading:
              SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
          title: Text(
            'Gestión de Usuarios',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh,
                  color: FlutterFlowTheme.of(context).primaryText),
              onPressed: _loadUsers,
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    _buildFilterChip('Todos', null),
                    _buildFilterChip('Admins', 'admin'),
                    _buildFilterChip('Soporte', 'support'),
                    _buildFilterChip('Usuarios', 'user'),
                  ],
                ),
              ),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredUsers.isEmpty
                        ? Center(
                            child: Text(
                              'No se encontraron usuarios',
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return UserCard(
                                user: user,
                                onUpdate: _loadUsers,
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? role) {
    final isSelected = _filterRole == role;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _filterRole = selected ? role : null;
          });
        },
        selectedColor: FlutterFlowTheme.of(context).primary,
        labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(),
              color: isSelected
                  ? Colors.white
                  : FlutterFlowTheme.of(context).primaryText,
            ),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      ),
    );
  }
}
