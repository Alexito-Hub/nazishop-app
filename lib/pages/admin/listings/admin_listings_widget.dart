import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/admin_service.dart';
import '/models/listing_model.dart';
import 'package:go_router/go_router.dart';
import '/pages/admin/inventory/admin_inventory_widget.dart';
import '/components/design_system.dart';

class AdminListingsWidget extends StatefulWidget {
  const AdminListingsWidget({super.key});

  static String routeName = 'admin_listings';

  @override
  State<AdminListingsWidget> createState() => _AdminListingsWidgetState();
}

class _AdminListingsWidgetState extends State<AdminListingsWidget> {
  List<Listing> _listings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers() async {
    setState(() => _isLoading = true);
    try {
      final data = await AdminService.getListings();
      if (mounted) {
        setState(() {
          _listings = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading offers: $e',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText)),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  Future<void> _deleteOffer(String id) async {
    final confirm = await DSDeleteConfirmDialog.show(
      context,
      message: '¿Estás seguro? Esto eliminará el listing del catálogo.',
    );

    if (!confirm) return;

    try {
      final res = await AdminService.deleteListing(id);
      if (res['status'] == true) {
        _loadOffers();
      } else {
        throw res['msg'] ?? 'Error desconocido';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al eliminar: $e',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).info)),
              backgroundColor: FlutterFlowTheme.of(context).primary),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Stack(
        children: [
          isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
        ],
      ),
      floatingActionButton: isDesktop
          ? null
          : DSGradientFab(
              label: 'Nuevo Listing',
              icon: Icons.local_offer,
              onPressed: () async {
                await context.pushNamed('create_listing');
                _loadOffers();
              },
            ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const DSMobileAppBar(title: 'Listings'),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: _isLoading
              ? SliverToBoxAdapter(
                  child: Center(
                      child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary)))
              : _buildListingsGrid(isDesktop: false),
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
                  title: 'Listings',
                  subtitle: 'Gestiona los listings de servicios activos',
                  actionLabel: 'Nuevo Listing',
                  actionIcon: Icons.add_circle_outline,
                  onAction: () async {
                    await context.pushNamed('create_listing');
                    _loadOffers();
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
                  : _buildListingsGrid(isDesktop: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingsGrid({required bool isDesktop}) {
    if (_listings.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Icon(Icons.layers_outlined,
                  size: 64, color: FlutterFlowTheme.of(context).secondaryText),
              const SizedBox(height: 16),
              Text(
                'No hay listings disponibles',
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
          final listing = _listings[index];
          return _buildListingCard(listing);
        },
        childCount: _listings.length,
      ),
    );
  }

  Widget _buildListingCard(Listing listing) {
    final primaryColor = FlutterFlowTheme.of(context).primary;

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await context.pushNamed(
                  'create_listing',
                  extra: listing,
                );
                _loadOffers();
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: listing.isActive
                                ? FlutterFlowTheme.of(context)
                                    .success
                                    .withValues(alpha: 0.1)
                                : FlutterFlowTheme.of(context)
                                    .secondaryText
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            listing.isActive ? 'ACTIVO' : 'INACTIVO',
                            style: GoogleFonts.outfit(
                              color: listing.isActive
                                  ? FlutterFlowTheme.of(context).success
                                  : FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (listing.isFeatured)
                          Icon(Icons.star_rounded,
                              color: FlutterFlowTheme.of(context).warning,
                              size: 18),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      listing.title,
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${listing.price} ${listing.currency}',
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildIconButton(
                          Icons.inventory_2_rounded,
                          FlutterFlowTheme.of(context).info,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminInventoryWidget(
                                listingId: listing.id,
                                listingTitle: listing.title,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildIconButton(
                          Icons.delete_outline_rounded,
                          FlutterFlowTheme.of(context).error,
                          () => _deleteOffer(listing.id),
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
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
