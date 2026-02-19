import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/auth/nazishop_auth/nazishop_auth_provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';

import '../backend/catalog_cache.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Layout wrapper que mantiene el sidebar de navegación consistente
/// en desktop para todas las páginas de la app
class AppLayout extends StatefulWidget {
  final Widget child;
  final String? currentRoute;
  final String? title;
  final bool showBackButton;

  const AppLayout({
    super.key,
    required this.child,
    this.currentRoute,
    this.title,
    this.showBackButton = true,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final _catalogCache = CatalogCache();

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    // Primero intentar mostrar caché inmediatamente si existe
    final cached = _catalogCache.cachedCategories;
    if (cached != null && mounted) {
      setState(() {
        // Categories loaded from cache
      });
    }

    // Luego cargar en background (usará caché si es válido)
    try {
      await _catalogCache.getCategories();
      if (mounted) {
        setState(() {
          // Categories loaded from API
        });
      }
    } catch (e) {
      // Silently fail - keep existing categories if any
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Bajamos el breakpoint a 900 para soportar tablets en landscape (iPad, etc)
    final isDesktop = screenWidth > 900;

    if (!isDesktop) {
      // En móvil, solo mostramos el child sin sidebar
      return widget.child;
    }

    // En desktop, mostramos el sidebar + contenido SIN Scaffold envolvente
    return Material(
      color: FlutterFlowTheme.of(context).primaryBackground,
      child: Row(
        children: [
          // Sidebar Navigation
          _buildSidebar(context),
          // Main Content
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(
          right: BorderSide(
            color: theme.alternate.withValues(alpha: 0.05), // Subtle border
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  'NAZI SHOP',
                  style: GoogleFonts.outfit(
                    color: theme.primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _SidebarItem(
                  icon: Icons.home_filled,
                  label: 'Inicio',
                  isActive: widget.currentRoute == '/' ||
                      widget.currentRoute == '/home',
                  onTap: () => context.go('/'),
                ),
                _SidebarItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Mis Compras',
                  isActive: widget.currentRoute == '/user/purchases',
                  onTap: () => context.goNamed('my_purchases'),
                ),
                _SidebarItem(
                  icon: Icons.favorite_border,
                  label: 'Favoritos',
                  isActive: widget.currentRoute == '/user/favorites',
                  onTap: () => context.goNamed('favorites'),
                ),
                _SidebarItem(
                  icon: Icons.notifications_none,
                  label: 'Notificaciones',
                  isActive: widget.currentRoute == '/user/notifications',
                  onTap: () => context.goNamed('notifications_user'),
                ),
                _SidebarItem(
                  icon: Icons.person_outline,
                  label: 'Perfil',
                  isActive: widget.currentRoute == '/user/profile',
                  onTap: () => context.goNamed('profile'),
                ),
                // Items removed: Ofertas, Soporte, Términos

                // ADMINISTRACIÓN
                if (_shouldShowAdminSection()) ...[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 24, bottom: 12),
                    child: Text(
                      'ADMINISTRACIÓN',
                      style: GoogleFonts.outfit(
                        color: theme.secondaryText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  _SidebarItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Panel General',
                    isActive: widget.currentRoute == '/admin' ||
                        widget.currentRoute?.startsWith('/admin/dashboard') ==
                            true,
                    onTap: () => context.goNamed('admin'),
                  ),
                  _SidebarItem(
                    icon: Icons.category_outlined,
                    label: 'Categorías',
                    isActive:
                        widget.currentRoute?.startsWith('/admin/categories') ==
                            true,
                    onTap: () => context.goNamed('admin_categories'),
                  ),
                  _SidebarItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Servicios',
                    isActive:
                        widget.currentRoute?.startsWith('/admin/services') ==
                            true,
                    onTap: () => context.goNamed('admin_services'),
                  ),
                  _SidebarItem(
                    icon: Icons.list_alt,
                    label: 'Listings',
                    isActive:
                        widget.currentRoute?.startsWith('/admin/listings') ==
                            true,
                    onTap: () => context.goNamed('admin_listings'),
                  ),
                  _SidebarItem(
                    icon: Icons.storage_outlined,
                    label: 'Inventario',
                    isActive:
                        widget.currentRoute?.startsWith('/admin/inventory') ==
                            true,
                    onTap: () => context.goNamed('admin_inventory'),
                  ),
                  _SidebarItem(
                    icon: Icons.local_offer_outlined,
                    label: 'Promociones',
                    isActive:
                        widget.currentRoute?.startsWith('/admin/promotions') ==
                            true,
                    onTap: () => context.goNamed('admin_promotions'),
                  ),
                  _SidebarItem(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Cupones',
                    isActive:
                        widget.currentRoute?.startsWith('/admin/coupons') ==
                            true,
                    onTap: () => context.goNamed('admin_coupons'),
                  ),
                  _SidebarItem(
                    icon: Icons.currency_exchange_rounded,
                    label: 'Divisas',
                    isActive: widget.currentRoute == '/admin/currency',
                    onTap: () => context.goNamed('currency_management'),
                  ),
                  _SidebarItem(
                    icon: Icons.notifications_active_outlined,
                    label: 'Push Notif.',
                    isActive: widget.currentRoute
                            ?.startsWith('/admin/notifications') ==
                        true,
                    onTap: () => context.goNamed('admin_notifications'),
                  ),
                  _SidebarItem(
                    icon: Icons.analytics_outlined,
                    label: 'Estadísticas',
                    isActive:
                        widget.currentRoute?.startsWith('/admin/analytics') ==
                            true,
                    onTap: () => context.goNamed('admin_analytics'),
                  ),
                  _SidebarItem(
                    icon: Icons.shopping_cart_outlined,
                    label: 'Órdenes',
                    isActive: widget.currentRoute == '/user/orders' ||
                        widget.currentRoute?.startsWith('/admin/orders') ==
                            true,
                    onTap: () => context.goNamed('orders_management'),
                  ),
                  _SidebarItem(
                    icon: Icons.people_outline,
                    label: 'Usuarios',
                    isActive:
                        widget.currentRoute?.startsWith('/admin/users') == true,
                    onTap: () => context.goNamed('users_management'),
                  ),
                  _SidebarItem(
                    icon: Icons.settings_outlined,
                    label: 'Configuración',
                    isActive:
                        widget.currentRoute?.startsWith('/admin/config') ==
                            true,
                    onTap: () => context.goNamed('admin_config'),
                  ),
                ],

                const SizedBox(height: 24),
                _SidebarItem(
                  icon: Icons.info_outline,
                  label: 'Acerca de',
                  isActive: widget.currentRoute == '/about',
                  onTap: () => context.goNamed('about'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowAdminSection() {
    try {
      final authProvider =
          Provider.of<NaziShopAuthProvider>(context, listen: false);
      return authProvider.currentUser?.isAdmin ?? false;
    } catch (e) {
      return false;
    }
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          hoverColor: theme.primaryText.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive
                  ? theme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(
                      color: theme.primary.withValues(alpha: 0.2),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? theme.primary : theme.secondaryText,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    color: isActive ? theme.primaryText : theme.secondaryText,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                if (isActive) ...[
                  const Spacer(),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
