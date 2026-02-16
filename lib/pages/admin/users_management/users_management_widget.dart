import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_snackbar.dart';
import '/auth/guards/super_admin_guard.dart';
import '/backend/admin_service.dart';
import '../../../../backend/security_manager.dart';
import '../../../components/smart_back_button.dart';
import '../components/security_check_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  List<Map<String, dynamic>> _users = [];
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

    // 2. If not, ask for OTP
    final authorized = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SecurityCheckDialog(),
    );

    if (authorized == true) {
      SecurityManager().recordVerification(); // Start new session
      if (mounted) {
        setState(() => _isAuthorized = true);
        _loadUsers();
      }
    } else {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _loadUsers() async {
    if (!_isAuthorized) return;
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final usersRaw = await AdminService.getUsers(role: _filterRole);

      if (mounted) {
        setState(() {
          _users = List<Map<String, dynamic>>.from(usersRaw).map((u) {
            return {
              ...u,
              'displayName': u['displayName'] ?? u['display_name'] ?? 'Usuario',
              'email': u['email'] ?? '',
              'photoUrl': u['photoUrl'] ?? u['photoURL'] ?? u['photo_url'],
              'isActive': u['isActive'] ?? u['is_active'] ?? true,
              'role': u['role'] ?? 'customer',
              'wallet_balance': (u['wallet_balance'] as num?)?.toDouble() ??
                  (u['wallet'] is Map
                      ? (u['wallet']['balance'] as num?)?.toDouble()
                      : 0.0),
              'totalSpent': (u['total_spent'] as num?)?.toDouble() ?? 0.0,
              'id': u['uid'] ?? u['id'] ?? u['_id'],
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading users: $e');
      if (mounted) {
        setState(() {
          _users = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuperAdminAuthGuard(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: LayoutBuilder(builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;
          return isDesktop ? _buildDesktopLayout() : _buildMobileLayout();
        }),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          surfaceTintColor: FlutterFlowTheme.of(context).transparent,
          pinned: true,
          floating: true,
          elevation: 0,
          leadingWidth: 70,
          leading:
              SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
          centerTitle: true,
          title: Text(
            'Usuarios',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh,
                  color: FlutterFlowTheme.of(context).primaryText),
              onPressed: _loadUsers,
            ),
          ],
        ),
        SliverToBoxAdapter(child: _buildFilters()),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: _buildUsersList(),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
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
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Administra roles, estados y saldos de usuarios',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.refresh,
                          color: FlutterFlowTheme.of(context).secondaryText),
                      onPressed: _loadUsers,
                      tooltip: 'Recargar',
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: _buildFilters())),
            SliverPadding(
              padding: const EdgeInsets.all(40),
              sliver: _buildUsersList(isDesktop: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip('Todos', _filterRole == null, () {
            setState(() => _filterRole = null);
            _loadUsers();
          }),
          const SizedBox(width: 8.0),
          _buildFilterChip('Clientes', _filterRole == 'customer', () {
            setState(() => _filterRole = 'customer');
            _loadUsers();
          }),
          const SizedBox(width: 8.0),
          _buildFilterChip('Admins', _filterRole == 'admin', () {
            setState(() => _filterRole = 'admin');
            _loadUsers();
          }),
          const SizedBox(width: 8.0),
          _buildFilterChip('Supers', _filterRole == 'superadmin', () {
            setState(() => _filterRole = 'superadmin');
            _loadUsers();
          }),
        ],
      ),
    );
  }

  Widget _buildUsersList({bool isDesktop = false}) {
    if (_isLoading) {
      return SliverFillRemaining(
        child: Center(
            child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primary)),
      );
    }

    if (_users.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline_rounded,
                  size: 64, color: FlutterFlowTheme.of(context).secondaryText),
              const SizedBox(height: 16),
              Text('No hay usuarios encontrados',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 450,
        mainAxisExtent: 250, // Increased to prevent overflow
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildUserCard(_users[index]),
        childCount: _users.length,
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context)
                  .secondaryBackground
                  .withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected
                ? Colors.white
                : FlutterFlowTheme.of(context).secondaryText,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final isActive = user['isActive'] as bool? ?? false;
    final role = user['role'] as String? ?? 'customer';
    final isSuperAdmin = role.toLowerCase() == 'superadmin';
    final isAdmin = role.toLowerCase() == 'admin';

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate),
                  ),
                  child: CircleAvatar(
                    radius: 24.0,
                    backgroundColor: FlutterFlowTheme.of(context).alternate,
                    backgroundImage: user['photoUrl'] != null
                        ? NetworkImage(user['photoUrl'])
                        : null,
                    child: user['photoUrl'] == null
                        ? Icon(Icons.person_outline_rounded,
                            size: 24.0,
                            color: FlutterFlowTheme.of(context).secondaryText)
                        : null,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user['displayName'] ?? 'Usuario',
                              style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isSuperAdmin) ...[
                            const SizedBox(width: 6.0),
                            Icon(Icons.stars_rounded,
                                color: FlutterFlowTheme.of(context).tertiary,
                                size: 16.0),
                          ] else if (isAdmin) ...[
                            const SizedBox(width: 6.0),
                            Icon(Icons.verified_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 16.0),
                          ],
                        ],
                      ),
                      Text(
                        user['email'] ?? 'No email',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: isActive
                        ? FlutterFlowTheme.of(context)
                            .success
                            .withValues(alpha: 0.1)
                        : FlutterFlowTheme.of(context)
                            .error
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isActive
                          ? FlutterFlowTheme.of(context)
                              .success
                              .withValues(alpha: 0.2)
                          : FlutterFlowTheme.of(context)
                              .error
                              .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    isActive ? 'Activo' : 'Inactivo',
                    style: GoogleFonts.outfit(
                      color: isActive
                          ? FlutterFlowTheme.of(context).success
                          : FlutterFlowTheme.of(context).error,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                _buildStatBadge(
                  Icons.shopping_bag_rounded,
                  '${user['totalPurchases'] ?? 0}',
                ),
                const SizedBox(width: 8.0),
                _buildStatBadge(
                  Icons.monetization_on_rounded,
                  '\$${(user['totalSpent'] ?? 0).toStringAsFixed(0)}',
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    isActive ? 'Bloquear' : 'Activar',
                    isActive ? Icons.block_rounded : Icons.check_circle_rounded,
                    isActive
                        ? FlutterFlowTheme.of(context).secondaryText
                        : FlutterFlowTheme.of(context).success,
                    () async {
                      final success = await AdminService.updateUser(
                          user['id'], {'is_active': !isActive});
                      if (success) {
                        _loadUsers();
                        if (mounted) {
                          CustomSnackBar.success(context, 'Estado actualizado');
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: PopupMenuButton<String>(
                    onSelected: (newRole) async {
                      final success = await AdminService.updateUser(
                          user['id'], {'role': newRole});
                      if (success) {
                        _loadUsers();
                        if (mounted) {
                          CustomSnackBar.success(context, 'Rol actualizado');
                        }
                      }
                    },
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    offset: const Offset(0, -120),
                    itemBuilder: (context) => [
                      _buildPopupItem(
                          'customer',
                          'Cliente',
                          Icons.person_rounded,
                          FlutterFlowTheme.of(context).primaryText),
                      _buildPopupItem('admin', 'Admin', Icons.verified_rounded,
                          FlutterFlowTheme.of(context).primary),
                      _buildPopupItem(
                          'superadmin',
                          'Superadmin',
                          Icons.stars_rounded,
                          FlutterFlowTheme.of(context).tertiary),
                    ],
                    child: _buildActionButton(
                      'Rol',
                      Icons.manage_accounts_rounded,
                      FlutterFlowTheme.of(context).tertiary,
                      null,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                _buildActionButton(
                  '',
                  Icons.add_card_rounded,
                  FlutterFlowTheme.of(context).primary,
                  () => _showAddBalanceDialog(user),
                  width: 44,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(
      String value, String label, IconData icon, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback? onTap,
      {double? width}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 40,
        width: width,
        padding:
            width == null ? const EdgeInsets.symmetric(horizontal: 12) : null,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).alternate,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 12.0, color: FlutterFlowTheme.of(context).secondaryText),
          const SizedBox(width: 6.0),
          Text(
            text,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBalanceDialog(Map<String, dynamic> user) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Cargar Saldo',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuario: ${user['displayName'] ?? user['email']}',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 13)),
            const SizedBox(height: 24.0),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText),
              decoration: InputDecoration(
                labelText: 'Monto a cargar',
                labelStyle: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText),
                prefixText: '\$ ',
                prefixStyle: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary)),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: noteController,
              maxLines: 2,
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText),
              decoration: InputDecoration(
                labelText: 'Referencia / Nota',
                labelStyle: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary)),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText)),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                final scaffoldContext = context;
                Navigator.pop(scaffoldContext);
                final success = await AdminService.addUserBalance(
                  user['id'],
                  amount,
                  noteController.text.isEmpty ? null : noteController.text,
                );
                if (success) {
                  _loadUsers();
                  // ignore: use_build_context_synchronously
                  CustomSnackBar.success(scaffoldContext, 'Saldo acreditado');
                } else {
                  // ignore: use_build_context_synchronously
                  CustomSnackBar.error(
                      scaffoldContext, 'Error al cargar saldo');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
