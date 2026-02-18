import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/category_model.dart';
import 'package:nazi_shop/utils/icon_utils.dart';
import 'package:go_router/go_router.dart';

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
          _categories = data.map((d) => Category.fromJson(d)).toList();
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
              : _buildCategoriesGrid(isDesktop: false),
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
                  : _buildCategoriesGrid(isDesktop: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid({required bool isDesktop}) {
    if (_categories.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Icon(Icons.category_outlined,
                  size: 64,
                  color: FlutterFlowTheme.of(context)
                      .primaryText
                      .withValues(alpha: 0.2)),
              const SizedBox(height: 16),
              Text(
                'No hay categorías creadas',
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
        mainAxisExtent: 240,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final category = _categories[index];
          return _buildCategoryCard(category);
        },
        childCount: _categories.length,
      ),
    );
  }

  Widget _buildCategoryCard(Category cat) {
    final primaryColor = FlutterFlowTheme.of(context).primary;

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context)
            .secondaryBackground
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background icon flair
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              IconUtils.parseIcon(cat.ui.icon),
              size: 120,
              color: primaryColor.withValues(alpha: 0.1),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await context.pushNamed(
                  'create_category',
                  extra: cat,
                );
                _loadCategories();
              },
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: primaryColor.withValues(alpha: 0.1)),
                          ),
                          child: Icon(
                            IconUtils.parseIcon(cat.ui.icon),
                            color: primaryColor,
                            size: 24,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: cat.isActive
                                ? FlutterFlowTheme.of(context)
                                    .success
                                    .withValues(alpha: 0.1)
                                : FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: cat.isActive
                                  ? FlutterFlowTheme.of(context)
                                      .success
                                      .withValues(alpha: 0.1)
                                  : FlutterFlowTheme.of(context).alternate,
                            ),
                          ),
                          child: Text(
                            cat.isActive ? 'ACTIVO' : 'INACTIVO',
                            style: GoogleFonts.outfit(
                              color: cat.isActive
                                  ? FlutterFlowTheme.of(context).success
                                  : FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      cat.name,
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat.description,
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'ID: ...${cat.id.substring(cat.id.length - 6)}',
                          style: GoogleFonts.robotoMono(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 11,
                          ),
                        ),
                        const Spacer(),
                        _buildIconButton(
                          Icons.edit_outlined,
                          FlutterFlowTheme.of(context).secondaryText,
                          () async {
                            await context.pushNamed(
                              'create_category',
                              extra: cat,
                            );
                            _loadCategories();
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildIconButton(
                          Icons.delete_outline_rounded,
                          primaryColor,
                          () => _deleteCategory(cat.id),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
