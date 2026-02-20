import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';

import '/models/service_model.dart';
import '/models/listing_model.dart';
import '/backend/favorites_service.dart';
import '/utils/color_utils.dart';
import '../../../components/smart_back_button.dart';

// Modular Components
import 'components/service_info.dart';
import 'components/service_reviews.dart';
import 'components/service_pricing.dart';
import 'components/service_header_desktop.dart';
import 'components/service_mobile_header_background.dart';
import 'components/purchase_sidebar.dart';

class ServiceDetailWidget extends StatefulWidget {
  final Service service;

  const ServiceDetailWidget({super.key, required this.service});

  @override
  State<ServiceDetailWidget> createState() => _ServiceDetailWidgetState();
}

class _ServiceDetailWidgetState extends State<ServiceDetailWidget> {
  int _selectedListingIndex = 0;
  bool _isFavorite = false;

  List<Listing> get _allListings => widget.service.listings ?? [];

  // Punto de quiebre responsivo estándar
  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final favorites = await FavoritesService.getFavorites();
    if (mounted) {
      setState(() {
        _isFavorite = favorites.any((s) => s.id == widget.service.id);
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final success = await FavoritesService.toggleFavorite(widget.service.id);
    if (success && mounted) {
      setState(() => _isFavorite = !_isFavorite);
    }
  }

  Future<void> _handlePurchase(Listing listing) async {
    context.pushNamed(
      'checkout',
      extra: {
        'service': widget.service,
        'selectedListing': listing,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        ColorUtils.parseColor(context, widget.service.branding.primaryColor);

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (_isDesktop) {
            return _buildDesktopLayout(context, primaryColor);
          } else {
            return _buildMobileLayout(context, primaryColor);
          }
        },
      ),
    );
  }

  // ===========================================================================
  // 📱 MOBILE LAYOUT
  // ===========================================================================
  Widget _buildMobileLayout(BuildContext context, Color primaryColor) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          pinned: true,
          stretch: true,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context)
                  .secondaryBackground
                  .withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child:
                SmartBackButton(color: FlutterFlowTheme.of(context).tertiary),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context)
                    .secondaryBackground
                    .withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite
                      ? FlutterFlowTheme.of(context).error
                      : FlutterFlowTheme.of(context).tertiary,
                ),
                onPressed: _toggleFavorite,
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: ServiceMobileHeaderBackground(
              service: widget.service,
              primaryColor: primaryColor,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ServiceInfo(
                  service: widget.service,
                  tags: [], // Tags handling updated
                ),
                Text(
                  'Planes Disponibles',
                  style: GoogleFonts.outfit(
                    fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                const SizedBox(height: 16),
                ServicePricing(
                  listings: _allListings,
                  selectedIndex: _selectedListingIndex,
                  primaryColor: primaryColor,
                  onSelect: (index) =>
                      setState(() => _selectedListingIndex = index),
                  onPurchase: _handlePurchase,
                ),
                const SizedBox(height: 40),
                ServiceReviews(
                  serviceId: widget.service.id,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 💻 DESKTOP LAYOUT
  // ===========================================================================
  Widget _buildDesktopLayout(BuildContext context, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COLUMNA IZQUIERDA: INFORMACIÓN
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button styled
                    InkWell(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.goNamed('home'),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText),
                            const SizedBox(width: 8),
                            Text("Volver al catálogo",
                                style: GoogleFonts.outfit(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize:
                                        16 * FlutterFlowTheme.fontSizeFactor)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    ServiceHeaderDesktop(
                      service: widget.service,
                      isFavorite: _isFavorite,
                      onToggleFavorite: _toggleFavorite,
                      primaryColor: primaryColor,
                      tags: [], // Tags handling updated
                    ),

                    const SizedBox(height: 40),

                    ServiceInfo(
                      service: widget.service,
                      tags: [],
                    ),

                    const SizedBox(height: 40),

                    ServiceReviews(
                      serviceId: widget.service.id,
                      primaryColor: primaryColor,
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),

              const SizedBox(width: 60),

              // COLUMNA DERECHA: SIDEBAR FLOTANTE
              PurchaseSidebar(
                listings: _allListings,
                selectedIndex: _selectedListingIndex,
                primaryColor: primaryColor,
                onSelect: (index) =>
                    setState(() => _selectedListingIndex = index),
                onPurchase: _handlePurchase,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
