import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/offer_model.dart';
import 'package:go_router/go_router.dart';
import '/pages/admin/inventory/admin_inventory_page.dart';

class AdminOffersPage extends StatefulWidget {
  const AdminOffersPage({super.key});

  static String routeName = 'admin_listings';

  @override
  AdminOffersPageState createState() => AdminOffersPageState();
}

class AdminOffersPageState extends State<AdminOffersPage> {
  List<Offer> _offers = [];
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
          _offers = data.map((d) => Offer.fromJson(d)).toList();
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
                      '¿Estás seguro? Esto eliminará el listing del catálogo.',
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
                              color: FlutterFlowTheme.of(context).error,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                )) ??
        false;

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
          // Fondo degradado sutil global
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: FlutterFlowTheme.of(context)
                    .primary
                    .withValues(alpha: 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child:
                    Container(color: FlutterFlowTheme.of(context).transparent),
              ),
            ),
          ),

          isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
        ],
      ),
      floatingActionButton: isDesktop
          ? null
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).tertiary
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
                  await context.pushNamed('create_listing');
                  _loadOffers();
                },
                backgroundColor: FlutterFlowTheme.of(context).transparent,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                icon: Icon(Icons.local_offer,
                    color: FlutterFlowTheme.of(context).info),
                label: Text(
                  'Nuevo Listing',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).info,
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
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          pinned: true,
          floating: true,
          elevation: 0,
          leadingWidth: 70,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(
                color: FlutterFlowTheme.of(context).primaryText),
          ),
          centerTitle: true,
          title: Text(
            'Listings',
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
              : _buildOffersGrid(isDesktop: false),
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
                          'Listings',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gestiona los listings de servicios activos',
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
                            FlutterFlowTheme.of(context).tertiary
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
                          await context.pushNamed('create_listing');
                          _loadOffers();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        icon: Icon(Icons.add_circle_outline,
                            color: FlutterFlowTheme.of(context).info, size: 20),
                        label: Text(
                          'Nuevo Listing',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).info,
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
                  : _buildOffersGrid(isDesktop: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersGrid({required bool isDesktop}) {
    if (_offers.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Icon(Icons.local_offer_outlined,
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
        mainAxisExtent: 310,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final offer = _offers[index];
          return _buildOfferCard(offer);
        },
        childCount: _offers.length,
      ),
    );
  }

  Widget _buildOfferCard(Offer offer) {
    final primaryColor = FlutterFlowTheme.of(context).primary;

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background flair
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.local_offer_rounded,
              size: 80,
              color: primaryColor.withValues(alpha: 0.1),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await context.pushNamed(
                  'create_listing',
                  extra: offer,
                );
                _loadOffers();
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.flash_on_rounded,
                              color: primaryColor, size: 20),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: offer.isActive
                                ? FlutterFlowTheme.of(context)
                                    .success
                                    .withValues(alpha: 0.1)
                                : FlutterFlowTheme.of(context)
                                    .secondaryText
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: offer.isActive
                                  ? FlutterFlowTheme.of(context)
                                      .success
                                      .withValues(alpha: 0.1)
                                  : FlutterFlowTheme.of(context)
                                      .secondaryText
                                      .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            offer.isActive ? 'ACTIVO' : 'INACTIVO',
                            style: GoogleFonts.outfit(
                              color: offer.isActive
                                  ? FlutterFlowTheme.of(context).success
                                  : FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      offer.title,
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${offer.discountPrice}',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (offer.originalPrice > offer.discountPrice)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '\$${offer.originalPrice}',
                              style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${offer.discountPercent}% OFF',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).info,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildIconButton(
                          Icons.edit_outlined,
                          FlutterFlowTheme.of(context).secondaryText,
                          () async {
                            await context.pushNamed(
                              'create_listing',
                              extra: offer,
                            );
                            _loadOffers();
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildIconButton(
                          Icons.inventory_2_rounded,
                          FlutterFlowTheme.of(context).info,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminInventoryPage(
                                listingId: offer.id,
                                listingTitle: offer.title,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildIconButton(
                          Icons.delete_outline_rounded,
                          primaryColor,
                          () => _deleteOffer(offer.id),
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
