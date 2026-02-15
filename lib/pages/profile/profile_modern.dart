import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/safe_image.dart';
import 'package:nazi_shop/backend/wallet_service.dart';
import '/auth/nazishop_auth/auth_util.dart';
import '/backend/order_service.dart';
import '/backend/favorites_service.dart';

// No usamos FlutterFlowTheme para mantener consistencia con HomePageModern
// import '/flutter_flow/flutter_flow_theme.dart';

class ProfileModernWidget extends StatefulWidget {
  const ProfileModernWidget({super.key});

  @override
  State<ProfileModernWidget> createState() => _ProfileModernWidgetState();
}

class _ProfileModernWidgetState extends State<ProfileModernWidget> {
  // --- ESTADO ---
  final ScrollController _scrollController = ScrollController();
  int _orderCount = 0;
  int _favoriteCount = 0;
  double _balance = 0.0;
  String _currency = 'USD';
  bool _isLoadingStats = true; // Used?

  // --- COLORES ---
  static const Color kPrimaryColor = Color(0xFFE50914);

  // --- RESPONSIVE ---
  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    if (!mounted) return;
    // Don't set loading true here if we want to avoid full screen flicker,
    // maybe just update silently or have loaders on specific widgets.
    // But for now let's keep it simple.

    try {
      // Run in parallel for speed
      final results = await Future.wait([
        OrderService.getMyOrders(),
        FavoritesService.getFavorites(),
        WalletService.getBalance(currentUserUid),
      ]);

      if (mounted) {
        setState(() {
          _orderCount = (results[0] as List).length;
          _favoriteCount = (results[1] as List).length;
          final walletData = results[2] as Map<String, dynamic>;
          _balance = (walletData['balance'] as num?)?.toDouble() ?? 0.0;
          _currency = walletData['currency'] ?? 'USD';
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      print('Error loading stats: $e');
      if (mounted) setState(() => _isLoadingStats = false);
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final theme = FlutterFlowTheme.of(dialogContext);
        return AlertDialog(
          backgroundColor: theme.secondaryBackground,
          title: Text('Cerrar Sesión',
              style: GoogleFonts.outfit(color: theme.primaryText)),
          content: Text('¿Estás seguro de que quieres salir?',
              style: GoogleFonts.outfit(color: theme.secondaryText)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text('Cancelar',
                  style: GoogleFonts.outfit(color: theme.secondaryText)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text('Salir',
                  style: GoogleFonts.outfit(
                      color: kPrimaryColor, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await getAuthManager(context).signOut();
      if (mounted) context.goNamed('login');
    }
  }

  String get _userLevel {
    if (_orderCount == 0) return 'Nuevo';
    if (_orderCount < 3) return 'Bronce';
    if (_orderCount < 10) return 'Plata';
    return 'Oro';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: _isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  // ===========================================================================
  // 📱 MOBILE LAYOUT
  // ===========================================================================
  Widget _buildMobileLayout() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Header de Perfil
        SliverAppBar(
          expandedHeight:
              450, // Increased height to fit all content (Avatar, Text, Stats, Wallet)
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF0A0A0A)
              : FlutterFlowTheme.of(context).primaryBackground,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Fondo con gradiente
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kPrimaryColor.withOpacity(0.3),
                        Theme.of(context).brightness == Brightness.dark
                            ? FlutterFlowTheme.of(context).primaryBackground
                            : FlutterFlowTheme.of(context).primaryBackground,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Patrón decorativo
                Positioned(
                  right: -50,
                  top: -50,
                  child: Icon(Icons.person,
                      size: 250, color: Colors.white.withOpacity(0.05)),
                ),
                // Contenido del Perfil
                Center(
                  // Center places content in the middle, but if it's too tall it might overflow if constrained
                  child: SingleChildScrollView(
                    // Allow scrolling inside header if screen is very short horizontally (landscape) or just to be safe
                    physics:
                        const NeverScrollableScrollPhysics(), // Actually we don't want nested scroll, just fit content.
                    // Better to just ensure expandedHeight is enough.
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Wrap content
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40), // Top padding compensation
                        _buildAvatar(radius: 50),
                        const SizedBox(height: 16),
                        Text(
                          currentUserDisplayName != ''
                              ? currentUserDisplayName
                              : 'Usuario',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 24 * FlutterFlowTheme.fontSizeFactor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          currentUserEmail,
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 14 * FlutterFlowTheme.fontSizeFactor,
                          ),
                        ),
                        if (currentUser != null &&
                            (currentUser?.isAdmin ?? false))
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: FilledButton.icon(
                              onPressed: () => context.pushNamed('admin'),
                              style: FilledButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              icon: const Icon(
                                  Icons.admin_panel_settings_rounded,
                                  size: 20),
                              label: Text(
                                'Panel de Administrador',
                                style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        // Mobile Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildMobileStat("Pedidos", _orderCount.toString(),
                                isDark: Theme.of(context).brightness ==
                                    Brightness.dark),
                            Container(
                                height: 20,
                                width: 1,
                                color: Theme.of(context).dividerColor,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10)),
                            _buildMobileStat(
                                "Favoritos", _favoriteCount.toString(),
                                isDark: Theme.of(context).brightness ==
                                    Brightness.dark),
                            Container(
                                height: 20,
                                width: 1,
                                color: Theme.of(context).dividerColor,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10)),
                            _buildMobileStat("Nivel", _userLevel,
                                isDark: Theme.of(context).brightness ==
                                    Brightness.dark),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Wallet Card Mobile
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [kPrimaryColor, const Color(0xFFB00710)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: kPrimaryColor.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Saldo Disponible',
                                      style: GoogleFonts.outfit(
                                          color: Colors.white70, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${_balance.toStringAsFixed(2)} $_currency',
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child:
                                    const Icon(Icons.add, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Menu Options
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text('CUENTA', style: _sectionHeaderStyle),
              const SizedBox(height: 12),
              _buildMenuTile(
                icon: Icons.person_outline_rounded,
                title: 'Editar Perfil',
                onTap: () => context.pushNamed('auth_edit_profile'),
              ),
              _buildMenuTile(
                icon: Icons.favorite_border_rounded,
                title: 'Mis Favoritos',
                onTap: () => context.pushNamed('favorites'),
              ),
              _buildMenuTile(
                icon: Icons.history_rounded,
                title: 'Historial de Pedidos',
                onTap: () => context
                    .pushNamed('my_purchases'), // Unificado a Mis Compras
              ),
              const SizedBox(height: 24),
              Text('CONFIGURACIÓN', style: _sectionHeaderStyle),
              const SizedBox(height: 12),
              _buildMenuTile(
                icon: Icons.lock_outline_rounded,
                title: 'Seguridad',
                onTap: () => context.pushNamed('security'),
              ),
              _buildMenuTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notificaciones',
                onTap: () => context.pushNamed('notifications_user'),
              ),
              _buildMenuTile(
                icon: Icons.palette_outlined,
                title: 'Apariencia',
                onTap: () => context.pushNamed('appearance'),
              ),
              _buildMenuTile(
                icon: Icons.credit_card_rounded,
                title: 'Métodos de Pago',
                onTap: () => context.pushNamed('payment_methods_user'),
              ),
              const SizedBox(height: 24),
              _buildMenuTile(
                icon: Icons.logout_rounded,
                title: "Cerrar Sesión",
                color: Colors.red,
                isDestructive: true,
                onTap: _handleLogout,
              ),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 💻 DESKTOP COMPONENT EXTRACT
  // ===========================================================================
  Widget _buildProfileCard() {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        children: [
          _buildAvatar(radius: 50),
          const SizedBox(height: 16),
          Text(
            currentUserDisplayName.isNotEmpty
                ? currentUserDisplayName
                : 'Usuario',
            style: GoogleFonts.outfit(
                color: theme.primaryText,
                fontSize: 22,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            currentUserEmail,
            style: GoogleFonts.outfit(color: theme.secondaryText, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => context.pushNamed('auth_edit_profile'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.primaryText,
              side: BorderSide(color: theme.alternate),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child:
                Text('Editar Perfil', style: GoogleFonts.outfit(fontSize: 14)),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.05);
  }

  Widget _buildWalletCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor.withOpacity(0.9), const Color(0xFFB00710)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: kPrimaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.account_balance_wallet_rounded,
                  color: Colors.white.withOpacity(0.8), size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8)),
                child: Text('USD',
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text('Saldo Actual',
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13)),
          Text(
            '\$${_balance.toStringAsFixed(2)}',
            style: GoogleFonts.outfit(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {}, // Top up dialog
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('Recargar',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);
  }

  Widget _buildRightContent({required bool isNarrow}) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats Headers
        Row(
          children: [
            _buildDesktopStatCard(
                "Pedidos", _orderCount.toString(), Icons.shopping_bag_outlined),
            const SizedBox(width: 16),
            _buildDesktopStatCard("Favoritos", _favoriteCount.toString(),
                Icons.favorite_border_rounded),
            const SizedBox(width: 16),
            _buildDesktopStatCard(
                "Nivel", _userLevel, Icons.star_border_rounded),
          ],
        ),

        const SizedBox(height: 40),

        // Section: Configuration
        Text(
          "Configuración",
          style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: isNarrow ? 2 : 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isNarrow ? 2.5 : 1.8,
          children: [
            _buildCompactMenuCard(
              icon: Icons.credit_card_rounded,
              title: "Métodos de Pago",
              subtitle: "Tarjetas y facturación",
              onTap: () => context.pushNamed('payment_methods_user'),
            ),
            _buildCompactMenuCard(
              icon: Icons.lock_outline_rounded,
              title: "Seguridad",
              subtitle: "Contraseña",
              onTap: () => context.pushNamed('security'),
            ),
            _buildCompactMenuCard(
              icon: Icons.palette_outlined,
              title: "Apariencia",
              subtitle: "Tema oscuro/claro",
              onTap: () => context.pushNamed('appearance'),
            ),
          ],
        ),

        const SizedBox(height: 40),

        // Section: Danger Zone
        Text(
          "Sesión",
          style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 300,
          child: _buildCompactMenuCard(
            icon: Icons.logout_rounded,
            title: "Cerrar Sesión",
            subtitle: "Salir de tu cuenta",
            onTap: _handleLogout,
            isDestructive: true,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 💻 DESKTOP LAYOUT (More Compact & Denser)
  // ===========================================================================
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Si tenemos menos de 880px disponibles, usamos stack vertical (Tablet Layout)
              // (880px = 320px(Left) + 40px(Gap) + 520px(Min Right to look good))
              final bool isTabletMode = constraints.maxWidth < 880;

              if (isTabletMode) {
                return Column(
                  children: [
                    // Top: Profile & Wallet side-by-side if enough space, else stacked
                    if (constraints.maxWidth > 600)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildProfileCard()),
                          const SizedBox(width: 20),
                          Expanded(child: _buildWalletCard()),
                        ],
                      )
                    else
                      Column(children: [
                        _buildProfileCard(),
                        const SizedBox(height: 20),
                        _buildWalletCard()
                      ]),

                    const SizedBox(height: 40),
                    _buildRightContent(isNarrow: true),
                    const SizedBox(height: 60),
                  ],
                );
              }

              // Desktop Full Layout
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ====================
                  // LEFTSIDE (320px)
                  // ====================
                  SizedBox(
                    width: 320,
                    child: Column(
                      children: [
                        _buildProfileCard(),
                        const SizedBox(height: 20),
                        _buildWalletCard(),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),

                  // ====================
                  // RIGHT CONTENT
                  // ====================
                  Expanded(
                    child: _buildRightContent(isNarrow: false),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 🧩 COMPONENTES
  // ===========================================================================

  Widget _buildAvatar({required double radius}) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.secondaryBackground,
        border: Border.all(color: kPrimaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: currentUserPhoto.isNotEmpty
          ? ClipOval(
              child: SafeImage(
                currentUserPhoto,
                fit: BoxFit.cover,
                allowRemoteDownload: false,
                placeholder: Icon(Icons.person,
                    size: radius,
                    color: FlutterFlowTheme.of(context).primaryText),
              ),
            )
          : Icon(Icons.person,
              size: radius, color: FlutterFlowTheme.of(context).primaryText),
    );
  }

  Widget _buildStatItem(String label, String value) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            color: theme.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: theme.secondaryText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileStat(String label, String value, {bool isDark = true}) {
    // isDark param kept for signature compatibility but ignored
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 12 * FlutterFlowTheme.fontSizeFactor,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
    bool isDestructive = false,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDestructive
            ? Colors.red.withOpacity(0.1)
            : theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color:
                isDestructive ? Colors.red.withOpacity(0.2) : theme.alternate),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withOpacity(0.2)
                : theme.secondaryBackground,
            shape: BoxShape.circle,
            border: Border.all(color: theme.alternate),
          ),
          child: Icon(icon,
              color: isDestructive ? Colors.red : theme.primaryText, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            color: isDestructive ? Colors.red : theme.primaryText,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            color: theme.secondaryText, size: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildCompactMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withOpacity(0.05)
                : theme.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isDestructive ? Colors.red.withOpacity(0.3) : theme.alternate,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.red.withOpacity(0.1)
                      : kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon,
                    color: isDestructive ? Colors.red : kPrimaryColor,
                    size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: isDestructive ? Colors.red : theme.primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                          color: theme.secondaryText, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopStatCard(String label, String value, IconData icon) {
    final theme = FlutterFlowTheme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.alternate),
        ),
        child: Row(
          children: [
            Icon(icon, color: kPrimaryColor, size: 30),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 24 * FlutterFlowTheme.fontSizeFactor,
                        fontWeight: FontWeight.bold)),
                Text(label,
                    style: GoogleFonts.outfit(
                        color: theme.secondaryText,
                        fontSize: 12 * FlutterFlowTheme.fontSizeFactor)),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextStyle get _sectionHeaderStyle => GoogleFonts.outfit(
        color: FlutterFlowTheme.of(context).secondaryText,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      );
}
