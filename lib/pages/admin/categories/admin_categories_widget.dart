import '/flutter_flow/flutter_flow_theme.dart';
import '/components/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/admin_service.dart';
import '/models/category_model.dart';
import 'package:go_router/go_router.dart';
import '/components/design_system.dart';
import 'components/category_grid.dart';
import '/components/app_responsive_layout.dart';

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
    final confirm = await DSDeleteConfirmDialog.show(
      context,
      title: 'Confirmar Eliminación',
      message: '¿Estás seguro? Esto podría afectar servicios vinculados.',
    );

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
    return AppResponsiveLayout(
      mobileBody: _buildMobileLayout(),
      desktopBody: _buildDesktopLayout(),
      mobileFab: DSGradientFab(
        label: 'Nueva Categoría',
        icon: Icons.category,
        onPressed: () async {
          await context.pushNamed('create_category');
          _loadCategories();
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const DSMobileAppBar(title: 'Categorías'),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: _isLoading
              ? SliverToBoxAdapter(
                  child: Center(
                      child: LoadingIndicator(
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
                child: DSAdminPageHeader(
                  title: 'Categorías',
                  subtitle: 'Gestiona las agrupaciones de tus servicios',
                  actionLabel: 'Nueva Categoría',
                  actionIcon: Icons.add_circle_outline,
                  onAction: () async {
                    await context.pushNamed('create_category');
                    _loadCategories();
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              sliver: _isLoading
                  ? SliverToBoxAdapter(
                      child: Center(
                          child: LoadingIndicator(
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
