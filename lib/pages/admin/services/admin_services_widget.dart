import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/service_model.dart';
import 'package:go_router/go_router.dart';
import '../../../components/smart_back_button.dart';

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
    final confirm = await showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  title: Text('Confirmar Eliminación',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.bold)),
                  content: Text('¿Estás seguro? Esta acción es irreversible.',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: Text('Cancelar',
                          style: GoogleFonts.outfit(
                              color:
                                  FlutterFlowTheme.of(context).secondaryText)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(c, true),
                      child: Text('Eliminar',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).error,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                )) ??
        false;

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
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(),
      floatingActionButton: isDesktop
          ? null
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).secondary,
                  ], // Red Gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  await context.pushNamed('create_service');
                  _loadServices();
                },
                backgroundColor: FlutterFlowTheme.of(context).transparent,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                icon: Icon(Icons.design_services,
                    color: FlutterFlowTheme.of(context).primaryText),
                label: Text(
                  'Nuevo Servicio',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
            ),
    );
  }

  Widget _buildMobileLayout() {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: FlutterFlowTheme.of(context).transparent,
          surfaceTintColor: FlutterFlowTheme.of(context).transparent,
          pinned: true,
          floating: true,
          elevation: 0,
          leadingWidth: 70,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context)
                  .secondaryBackground
                  .withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child:
                SmartBackButton(color: FlutterFlowTheme.of(context).tertiary),
          ),
          centerTitle: true,
          title: Text(
            'Servicios',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).tertiary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
          actions: [],
        ),
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
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Servicios',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Administra el catálogo de servicios ofrecidos',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            FlutterFlowTheme.of(context).primary,
                            FlutterFlowTheme.of(context).secondary
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await context.pushNamed('create_service');
                          _loadServices();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        icon: Icon(Icons.add_circle_outline,
                            color: FlutterFlowTheme.of(context).tertiary,
                            size: 20),
                        label: Text(
                          'Nuevo Servicio',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).tertiary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
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
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        mainAxisExtent: 280,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
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
    Color primaryColor = FlutterFlowTheme.of(context).primary;
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: FlutterFlowTheme.of(context).transparent,
        child: InkWell(
          onTap: () async {
            await context.pushNamed(
              'create_service',
              extra: service,
            );
            _loadServices();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Image/Banner
              Expanded(
                flex: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      service.imageUrl ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: FlutterFlowTheme.of(context).alternate,
                        child: Icon(Icons.image_not_supported_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 40),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            FlutterFlowTheme.of(context).transparent,
                            FlutterFlowTheme.of(context)
                                .primaryText
                                .withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: service.isActive
                              ? FlutterFlowTheme.of(context)
                                  .success
                                  .withValues(alpha: 0.9)
                              : FlutterFlowTheme.of(context)
                                  .primaryText
                                  .withValues(alpha: 0.54),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          service.isActive ? 'ACTIVO' : 'INACTIVO',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildIconButton(
                            Icons.edit_outlined,
                            FlutterFlowTheme.of(context).primaryText,
                            () async {
                              await context.pushNamed(
                                'create_service',
                                extra: service,
                              );
                              _loadServices();
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildIconButton(
                            Icons.delete_outline_rounded,
                            FlutterFlowTheme.of(context).error,
                            () => _deleteService(service.id),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Info
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.description,
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.category_rounded,
                              color: primaryColor, size: 14),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              service.categoryName ?? 'Sin categoría',
                              style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
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

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
