import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/admin_service.dart';
import '/models/service_model.dart';
import 'package:go_router/go_router.dart';
import '/components/design_system.dart';
import '/components/app_responsive_layout.dart';
import '/components/safe_image.dart';

class AdminServicesWidget extends StatefulWidget {
  const AdminServicesWidget({super.key});

  static String routeName = 'admin_services';

  @override
  AdminServicesWidgetState createState() => AdminServicesWidgetState();
}

class AdminServicesWidgetState extends State<AdminServicesWidget> {
  List<Service> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    try {
      final data = await AdminService.getServices();
      if (mounted) {
        setState(() {
          _services = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading services: $e',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText)),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  Future<void> _deleteService(String id) async {
    final confirm = await DSDeleteConfirmDialog.show(
      context,
      message: '¿Estás seguro? Esta acción es irreversible.',
    );

    if (!confirm) return;

    try {
      final res = await AdminService.deleteService(id);
      if (res['status'] == true) {
        _loadServices();
      } else {
        throw res['msg'] ?? 'Error desconocido';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al eliminar: $e',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText)),
              backgroundColor: FlutterFlowTheme.of(context).error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppResponsiveLayout(
      mobileBody: _buildMobileLayout(),
      desktopBody: _buildDesktopLayout(context),
      mobileFab: DSGradientFab(
        label: 'Nuevo Servicio',
        icon: Icons.design_services,
        onPressed: () async {
          await context.pushNamed('create_service');
          _loadServices();
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const DSMobileAppBar(title: 'Servicios'),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: _isLoading
              ? SliverToBoxAdapter(
                  child: Center(
                      child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary)))
              : _buildServicesGrid(isDesktop: false),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
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
                child: DSAdminPageHeader(
                  title: 'Servicios',
                  subtitle: 'Administra el catálogo de servicios ofrecidos',
                  actionLabel: 'Nuevo Servicio',
                  actionIcon: Icons.add_circle_outline,
                  onAction: () async {
                    await context.pushNamed('create_service');
                    _loadServices();
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              sliver: _isLoading
                  ? SliverToBoxAdapter(
                      child: Center(
                          child: CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primary)))
                  : _buildServicesGrid(isDesktop: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid({required bool isDesktop}) {
    if (_services.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Icon(Icons.inventory_2_outlined,
                  size: 64, color: FlutterFlowTheme.of(context).secondaryText),
              const SizedBox(height: 16),
              Text(
                'No hay servicios creados',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        childAspectRatio: 0.72,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final service = _services[index];
          return _buildServiceCard(service);
        },
        childCount: _services.length,
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    final theme = FlutterFlowTheme.of(context);
    final Color primaryColor = theme.primary;

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.alternate.withValues(alpha: 0.6),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: theme.transparent,
        child: InkWell(
          onTap: () async {
            await context.pushNamed(
              'create_service',
              extra: service,
            );
            _loadServices();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Image Header (60%)
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SafeImage(
                      service.imageUrl,
                      fit: BoxFit.cover,
                      fallbackIcon: Icons.design_services_outlined,
                      fallbackIconSize: 36,
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              theme.transparent,
                              Colors.black.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Status Badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: service.isActive
                              ? theme.success
                              : theme.secondaryText,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: (service.isActive
                                      ? theme.success
                                      : theme.secondaryText)
                                  .withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          service.isActive ? 'ACTIVO' : 'INACTIVO',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    // Action Buttons (Edit/Delete)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAdminActionButton(
                            icon: Icons.edit_rounded,
                            color: Colors.white,
                            onTap: () async {
                              await context.pushNamed(
                                'create_service',
                                extra: service,
                              );
                              _loadServices();
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildAdminActionButton(
                            icon: Icons.delete_outline_rounded,
                            color: theme.error,
                            onTap: () => _deleteService(service.id),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Info Content (40%)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                style: GoogleFonts.outfit(
                                  color: theme.primaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                service.description,
                                style: GoogleFonts.outfit(
                                  color: theme.secondaryText,
                                  fontSize: 11,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Footer: Category
                      Row(
                        children: [
                          Icon(Icons.category_rounded,
                              color: primaryColor, size: 12),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              service.categoryName ?? 'Sin categoría',
                              style: GoogleFonts.outfit(
                                color: theme.secondaryText,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color == Colors.white
              ? Colors.white.withValues(alpha: 0.2)
              : color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
