import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../../components/smart_back_button.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  // static const Color kPrimaryColor = Color(0xFFE50914); // Removed for Theme
  List<User> _users = [];
  bool _isLoading = false;
  String _filter = 'all'; // all, admin, provider, blocked

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final res = await AdminService.getUsers();
      if (mounted) {
        setState(() {
          _users = res.map((e) => User.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleBlock(User user) async {
    // Optimistic update
    final idx = _users.indexWhere((u) => u.id == user.id);
    if (idx == -1) return;

    final oldVal = user.isBlocked;
    setState(() {
      _users[idx] = User(
        id: user.id,
        displayName: user.displayName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoUrl,
        role: user.role,
        balance: user.balance,
        currency: user.currency,
        isProvider: user.isProvider,
        createdAt: user.createdAt,
        lastLogin: user.lastLogin,
        isBlocked: !oldVal,
      );
    });

    try {
      await AdminService.updateUserStatus(user.id, !oldVal);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(!oldVal ? 'Usuario Bloqueado' : 'Usuario Desbloqueado'),
            backgroundColor: !oldVal ? Colors.red : Colors.green));
      }
    } catch (_) {
      // Revert on error
      if (mounted) {
        setState(() {
          _users[idx] = User(
            id: user.id,
            displayName: user.displayName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            photoUrl: user.photoUrl,
            role: user.role,
            balance: user.balance,
            currency: user.currency,
            isProvider: user.isProvider,
            createdAt: user.createdAt,
            lastLogin: user.lastLogin,
            isBlocked: oldVal,
          );
        });
      }
    }
  }

  List<User> get _filteredUsers {
    switch (_filter) {
      case 'admin':
        return _users
            .where((u) => u.role == 'admin' || u.role == 'superadmin')
            .toList();
      case 'provider':
        return _users.where((u) => u.isProvider).toList();
      case 'blocked':
        return _users.where((u) => u.isBlocked).toList();
      default:
        return _users;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      FlutterFlowTheme.of(context).primary.withOpacity(0.05)),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(color: Colors.transparent)),
            ),
          ),
          if (isDesktop) _buildDesktopLayout() else _buildMobileLayout(),
        ],
      ),
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
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Usuarios',
                            style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 32,
                                fontWeight: FontWeight.bold)),
                        Text('Gestiona cuentas, roles y permisos',
                            style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 16)),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _chip('Todos', 'all'),
                        _chip('Staff', 'admin'),
                        _chip('Vendedores', 'provider'),
                        _chip('Bloqueados', 'blocked'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              SliverFillRemaining(
                  child: Center(
                      child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary)))
            else if (_filteredUsers.isEmpty)
              SliverFillRemaining(
                  child: Center(
                      child: Text('No hay usuarios',
                          style: TextStyle(
                              color:
                                  FlutterFlowTheme.of(context).secondaryText))))
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            mainAxisExtent: 240,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16),
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _buildUserCard(_filteredUsers[i]),
                      childCount: _filteredUsers.length,
                    )),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading:
              SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
          title: Text('Usuarios',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          floating: true,
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _chip('Todos', 'all'),
                _chip('Staff', 'admin'),
                _chip('Apps', 'provider'), // "Vendedores" implies apps/sellers
                _chip('Bloqueados', 'blocked'),
              ],
            ),
          ),
        ),
        if (_isLoading)
          SliverFillRemaining(
              child: Center(
                  child: CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary)))
        else if (_filteredUsers.isEmpty)
          SliverFillRemaining(
              child: Center(
                  child: Text('No hay usuarios',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText))))
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final user = _filteredUsers[index];
                  return _buildUserCard(user)
                      .animate()
                      .fadeIn(delay: (30 * index).ms)
                      .slideY(begin: 0.1);
                },
                childCount: _filteredUsers.length,
              ),
            ),
          )
      ],
    );
  }

  Widget _chip(String label, String val) {
    final sel = _filter == val;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _filter = val),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: sel
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: sel
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).alternate),
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(
                color: sel
                    ? Colors.white
                    : FlutterFlowTheme.of(context).secondaryText,
                fontWeight: sel ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    final isStaff = user.role == 'admin' || user.role == 'superadmin';
    final isProvider = user.isProvider;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: user.isBlocked
                  ? Colors.red.withOpacity(0.3)
                  : FlutterFlowTheme.of(context).alternate),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4)),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: FlutterFlowTheme.of(context).primary,
                backgroundImage: user.photoUrl.isNotEmpty
                    ? NetworkImage(user.photoUrl)
                    : null,
                child: user.photoUrl.isEmpty
                    ? Text(
                        user.displayName.isNotEmpty
                            ? user.displayName[0].toUpperCase()
                            : 'U',
                        style:
                            TextStyle(color: FlutterFlowTheme.of(context).info))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.displayName,
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(user.email,
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              if (user.isBlocked)
                Icon(Icons.block,
                    color: FlutterFlowTheme.of(context).error, size: 20)
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (isStaff) _badge('Staff', FlutterFlowTheme.of(context).error),
              if (isProvider)
                _badge('Vendedor', FlutterFlowTheme.of(context).tertiary),
              if (!isStaff && !isProvider)
                _badge('Usuario', FlutterFlowTheme.of(context).secondaryText),
              const Spacer(),
              Text('Unido: ${DateFormat('MMM yyyy').format(user.createdAt)}',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12)),
            ],
          ),
          const Spacer(),
          Divider(color: FlutterFlowTheme.of(context).alternate),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Est. Balance',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 11)),
                  Text('${user.currency} \$${user.balance.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).success,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              IconButton(
                onPressed: () => _toggleBlock(user),
                icon: Icon(user.isBlocked ? Icons.lock_open : Icons.block,
                    color: user.isBlocked
                        ? FlutterFlowTheme.of(context).success
                        : FlutterFlowTheme.of(context).secondaryText),
                tooltip: user.isBlocked ? 'Desbloquear' : 'Bloquear',
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(text,
          style: GoogleFonts.outfit(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
