import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/category_model.dart';
import 'package:go_router/go_router.dart';
import 'components/category_grid.dart';

class AdminCategoriesWidget extends StatefulWidget {
  const AdminCategoriesWidget({super.key});

  static String routeName = 'admin_categories';

  @override
  AdminCategoriesWidgetState createState() => AdminCategoriesWidgetState();
}

class AdminCategoriesWidgetState extends State<AdminCategoriesWidget> {
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    try {
      final data = await AdminService.getCategories();
      if (mounted) {
        setState(() {
          _categories = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading categories: $e',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText)),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  Future<void> _deleteCategory(String id) async {
    final confirm = await showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  title: Text('Confirmar Eliminación',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.bold)),
                  content: Text(
                      '¿Estás seguro? Esto podría afectar servicios vinculados.',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: Text('Cancelar',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).primaryText)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(c, true),
                      child: Text('Eliminar',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).primary,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                )) ??
        false;

    if (!confirm) return;

    try {
      final res = await AdminService.deleteCategory(id);
      if (res['status'] == true) {
        _loadCategories();
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

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
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
                  await context.pushNamed('create_category');
                  _loadCategories();
                },
                backgroundColor: FlutterFlowTheme.of(context).transparent,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                icon: Icon(Icons.category,
                    color: FlutterFlowTheme.of(context).tertiary),
                label: Text(
                  'Nueva Categoría',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).tertiary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
            ),
    );
  }

  Widget _buildMobileLayout() {
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
                  .primaryBackground
                  .withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(
                color: FlutterFlowTheme.of(context).primaryText),
          ),
          centerTitle: true,
          title: Text(
            'Categorías',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.w900,
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
              : CategoryGrid(
                  categories: _categories,
                  onDelete: _deleteCategory,
                  onRefresh: _loadCategories,
                  isDesktop: false,
                ),
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
                          'Categorías',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gestiona las agrupaciones de tus servicios',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 16),
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
                          await context.pushNamed('create_category');
                          _loadCategories();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              FlutterFlowTheme.of(context).transparent,
                          shadowColor: FlutterFlowTheme.of(context).transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        icon: Icon(Icons.add_circle_outline,
                            color: FlutterFlowTheme.of(context).tertiary,
                            size: 20),
                        label: Text(
                          'Nueva Categoría',
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
                  : CategoryGrid(
                      categories: _categories,
                      onDelete: _deleteCategory,
                      onRefresh: _loadCategories,
                      isDesktop: true,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
