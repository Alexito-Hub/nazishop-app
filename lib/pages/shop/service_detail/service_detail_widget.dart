import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

// Necesario para ImageFilter

import 'package:nazi_shop/models/service_model.dart';
import 'package:nazi_shop/models/offer_model.dart';
import '/flutter_flow/safe_image.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'package:nazi_shop/backend/favorites_service.dart';
import 'package:nazi_shop/utils/color_utils.dart';
import '../../../components/smart_back_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ServiceDetailWidget extends StatefulWidget {
  final Service service;

  const ServiceDetailWidget({super.key, required this.service});

  @override
  State<ServiceDetailWidget> createState() => _ServiceDetailWidgetState();
}

class _ServiceDetailWidgetState extends State<ServiceDetailWidget> {
  int _selectedOfferIndex = 0;
  bool _isFavorite = false;

  List<Offer> get _allOffers => [
        ...(widget.service.individualOffers ?? []),
        ...(widget.service.packageOffers ?? []),
      ];

  // Get visual tags from the first available offer or fallback
  List<DisplayTag> get _bestTags {
    if (_allOffers.isEmpty) return [];
    // Prioritize offers with defined displayTags
    final withTags =
        _allOffers.where((o) => o.uiData?.displayTags?.isNotEmpty ?? false);
    if (withTags.isNotEmpty) return withTags.first.uiData!.displayTags!;
    return [];
  }

  // Punto de quiebre responsivo estándar
  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    // Simple check: fetch all and see if this service is in list
    // In a real app, optimize this with a local cache or user object check
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

  Future<void> _handlePurchase(Offer offer) async {
    context.pushNamed(
      'checkout',
      extra: {
        'service': widget.service,
        'selectedOffer': offer,
      },
    );
  }

  String _getOfferDuration(Offer offer) {
    final commercial = offer.commercialData;
    if (commercial == null || commercial.duration == null) return '';
    final unit = commercial.timeUnit ?? 'mes';
    return '${commercial.duration} $unit${commercial.duration! > 1 ? 'es' : ''}';
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
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (widget.service.branding.bannerUrl != null)
                  SafeImage(
                    widget.service.branding.bannerUrl,
                    fit: BoxFit.cover,
                  ),
                // Gradiente para legibilidad
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).transparent,
                        (FlutterFlowTheme.of(context).primaryBackground)
                            .withValues(alpha: 0.0),
                        (FlutterFlowTheme.of(context).primaryBackground)
                            .withValues(alpha: 0.8),
                        FlutterFlowTheme.of(context).primaryBackground,
                      ],
                      stops: const [0.0, 0.3, 0.75, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate),
                            boxShadow: [
                              BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.2),
                                  blurRadius: 15)
                            ]),
                        child: widget.service.branding.logoUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SafeImage(
                                    widget.service.branding.logoUrl!,
                                    fit: BoxFit.cover),
                              )
                            : Icon(Icons.layers, color: primaryColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.service.name,
                              style: GoogleFonts.outfit(
                                fontSize: 24 * FlutterFlowTheme.fontSizeFactor,
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).primaryText,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _StatusBadge(isOpen: widget.service.isInStock),
                                if (widget.service.categoryName != null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.service.categoryName!,
                                    style: GoogleFonts.outfit(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 13 *
                                            FlutterFlowTheme.fontSizeFactor),
                                  ),
                                ]
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                if (_bestTags.isNotEmpty) ...[
                  _VisualTagsWidget(tags: _bestTags),
                  const SizedBox(height: 24),
                ],

                // Descripción
                if (widget.service.description.isNotEmpty) ...[
                  Text('Sobre el servicio', style: _headerStyle),
                  const SizedBox(height: 12),
                  Text(
                    widget.service.description,
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 15 * FlutterFlowTheme.fontSizeFactor,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Technical Info
                if (widget.service.technicalInfo != null) ...[
                  _TechnicalSpecsWidget(info: widget.service.technicalInfo!),
                  const SizedBox(height: 32),
                ],

                // Features
                if (widget.service.features?.isNotEmpty ?? false) ...[
                  Text('Incluido en el servicio', style: _headerStyle),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.service.features!
                        .map((f) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .alternate
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate),
                              ),
                              child: Text(f,
                                  style: GoogleFonts.outfit(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 13 *
                                          FlutterFlowTheme.fontSizeFactor)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                ],

                // Offers
                Text('Planes Disponibles', style: _headerStyle),
                const SizedBox(height: 16),
                if (_allOffers.isEmpty)
                  _NoStockWidget()
                else
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _allOffers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, index) => _OfferCard(
                      offer: _allOffers[index],
                      isSelected: _selectedOfferIndex == index,
                      primaryColor: primaryColor,
                      onTap: () => setState(() => _selectedOfferIndex = index),
                      onPurchase: () => _handlePurchase(_allOffers[index]),
                      durationText: _getOfferDuration(_allOffers[index]),
                    ).animate().fadeIn(delay: (50 * index).ms).slideX(),
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

                    // Title & Logo Header
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate),
                          ),
                          child: widget.service.branding.logoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                      widget.service.branding.logoUrl!),
                                )
                              : Icon(Icons.rocket_launch,
                                  color: primaryColor, size: 40),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(widget.service.name,
                                      style: GoogleFonts.outfit(
                                          fontSize: 42 *
                                              FlutterFlowTheme.fontSizeFactor,
                                          fontWeight: FontWeight.bold,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText)),
                                  const SizedBox(width: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate
                                          .withValues(alpha: 0.3),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _isFavorite
                                            ? FlutterFlowTheme.of(context)
                                                .error
                                                .withValues(alpha: 0.5)
                                            : FlutterFlowTheme.of(context)
                                                .alternate,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        _isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: _isFavorite
                                            ? FlutterFlowTheme.of(context).error
                                            : FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        size: 28,
                                      ),
                                      onPressed: _toggleFavorite,
                                      tooltip: _isFavorite
                                          ? "Quitar de favoritos"
                                          : "Añadir a favoritos",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _StatusBadge(
                                      isOpen: widget.service.isInStock),
                                  const SizedBox(width: 12),
                                  if (widget.service.categoryName != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate
                                            .withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate),
                                      ),
                                      child: Text(widget.service.categoryName!,
                                          style: GoogleFonts.outfit(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14 *
                                                  FlutterFlowTheme
                                                      .fontSizeFactor)),
                                    ),
                                ],
                              ),
                              if (_bestTags.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                _VisualTagsWidget(tags: _bestTags),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Banner Image
                    if (widget.service.branding.bannerUrl != null)
                      Container(
                        height: 350,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: primaryColor.withValues(alpha: 0.15),
                                blurRadius: 40,
                                offset: const Offset(0, 10)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: SafeImage(widget.service.branding.bannerUrl,
                              fit: BoxFit.cover),
                        ),
                      ),

                    const SizedBox(height: 40),

                    // Description
                    Text("Sobre el servicio",
                        style: GoogleFonts.outfit(
                            fontSize: 24 * FlutterFlowTheme.fontSizeFactor,
                            fontWeight: FontWeight.bold,
                            color: FlutterFlowTheme.of(context).primaryText)),
                    const SizedBox(height: 16),
                    Text(
                      widget.service.description,
                      style: GoogleFonts.outfit(
                          fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          height: 1.6),
                    ),

                    if (widget.service.technicalInfo != null) ...[
                      const SizedBox(height: 40),
                      _TechnicalSpecsWidget(
                          info: widget.service.technicalInfo!),
                    ],

                    const SizedBox(height: 40),

                    // Grid Features (Mejorado para Desktop)
                    if (widget.service.features?.isNotEmpty ?? false) ...[
                      Text("Características",
                          style: GoogleFonts.outfit(
                              fontSize: 24 * FlutterFlowTheme.fontSizeFactor,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText)),
                      const SizedBox(height: 20),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          mainAxisExtent: 80,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: widget.service.features!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? FlutterFlowTheme.of(context).alternate
                                      : FlutterFlowTheme.of(context).alternate),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: primaryColor, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: Text(widget.service.features![index],
                                        style: GoogleFonts.outfit(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 14 *
                                                FlutterFlowTheme
                                                    .fontSizeFactor))),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),

              const SizedBox(width: 60),

              // COLUMNA DERECHA: SIDEBAR FLOTANTE
              // Usamos un ancho fijo para el sidebar
              SizedBox(
                width: 400,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? FlutterFlowTheme.of(context).alternate
                              : FlutterFlowTheme.of(context)
                                  .alternate
                                  .withValues(alpha: 0.4),
                        ),
                        boxShadow: [
                          if (Theme.of(context).brightness == Brightness.light)
                            BoxShadow(
                              color: FlutterFlowTheme.of(context)
                                  .primaryText
                                  .withValues(alpha: 0.04),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(Icons.verified_outlined,
                                    color: primaryColor, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Text("Elige una opción",
                                  style: GoogleFonts.outfit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          if (_allOffers.isEmpty)
                            _NoStockWidget()
                          else
                            ..._allOffers.asMap().entries.map((entry) =>
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _OfferCard(
                                    offer: entry.value,
                                    isSelected:
                                        _selectedOfferIndex == entry.key,
                                    primaryColor: primaryColor,
                                    onTap: () => setState(
                                        () => _selectedOfferIndex = entry.key),
                                    onPurchase: () =>
                                        _handlePurchase(entry.value),
                                    durationText:
                                        _getOfferDuration(entry.value),
                                  ),
                                )),
                          const SizedBox(height: 16),
                          Divider(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? FlutterFlowTheme.of(context).alternate
                                  : FlutterFlowTheme.of(context)
                                      .alternate
                                      .withValues(alpha: 0.4)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shield_outlined,
                                  size: 16,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText),
                              const SizedBox(width: 8),
                              Text("Garantía de reembolso de 7 días",
                                  style: GoogleFonts.outfit(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    ).animate().slideX(begin: 0.1, duration: 400.ms).fadeIn(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _headerStyle => GoogleFonts.outfit(
      fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
      fontWeight: FontWeight.bold,
      color: FlutterFlowTheme.of(context).primaryText);
}

// ===========================================================================
// 🧩 WIDGETS REUTILIZABLES (Componentes limpios)
// ===========================================================================

class _StatusBadge extends StatelessWidget {
  final bool isOpen;
  const _StatusBadge({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen
            ? FlutterFlowTheme.of(context).success.withValues(alpha: 0.2)
            : FlutterFlowTheme.of(context).error.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isOpen
              ? FlutterFlowTheme.of(context).success.withValues(alpha: 0.5)
              : FlutterFlowTheme.of(context).error.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        isOpen ? 'DISPONIBLE' : 'AGOTADO',
        style: GoogleFonts.outfit(
          color: isOpen
              ? FlutterFlowTheme.of(context).success
              : FlutterFlowTheme.of(context).error,
          fontSize: 11 * FlutterFlowTheme.fontSizeFactor,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final Offer offer;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;
  final VoidCallback onPurchase;
  final String durationText;

  const _OfferCard({
    required this.offer,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
    required this.onPurchase,
    required this.durationText,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = offer.discountPercent > 0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.04)
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.25)
                : FlutterFlowTheme.of(context).alternate,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: primaryColor.withValues(alpha: 0.1),
                      blurRadius: 10)
                ]
              : [],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Radio Button Custom
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isSelected
                            ? primaryColor
                            : FlutterFlowTheme.of(context).alternate,
                        width: 2),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: primaryColor, shape: BoxShape.circle)))
                      : null,
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          // Limpiamos el título si hay duración abajo para evitar redundancia
                          // ej: "Netflix (1 Mes)" -> "Netflix"
                          offer.title,
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontWeight: FontWeight.w600,
                              fontSize: 15 * FlutterFlowTheme.fontSizeFactor)),
                      if (durationText.isNotEmpty)
                        Text(durationText,
                            style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize:
                                    12 * FlutterFlowTheme.fontSizeFactor)),
                      if (offer.dataDeliveryType != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .alternate
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            offer.dataDeliveryType == 'full_account'
                                ? 'Cuenta Completa'
                                : offer.dataDeliveryType == 'profile_access'
                                    ? 'Perfil Individual'
                                    : 'Licencia Digital',
                            style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 10 * FlutterFlowTheme.fontSizeFactor),
                          ),
                        )
                      ]
                    ],
                  ),
                ),

                // Pricing
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (hasDiscount)
                      Text("\$${offer.originalPrice.toStringAsFixed(2)}",
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12 * FlutterFlowTheme.fontSizeFactor)),
                    Text("\$${offer.discountPrice.toStringAsFixed(2)}",
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 18 * FlutterFlowTheme.fontSizeFactor)),
                  ],
                )
              ],
            ),

            // Botón de compra expandible
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: isSelected ? null : 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: offer.inStock ? onPurchase : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: FlutterFlowTheme.of(context).tertiary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        offer.inStock ? 'Comprar Ahora' : 'Sin Stock',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoStockWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        children: [
          Icon(Icons.production_quantity_limits,
              size: 40, color: FlutterFlowTheme.of(context).secondaryText),
          const SizedBox(height: 12),
          Text("No disponible",
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * FlutterFlowTheme.fontSizeFactor)),
          const SizedBox(height: 4),
          Text("Este servicio no tiene planes activos.",
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 12 * FlutterFlowTheme.fontSizeFactor),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _VisualTagsWidget extends StatelessWidget {
  final List<DisplayTag> tags;
  const _VisualTagsWidget({required this.tags});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        final color = tag.color != null
            ? ColorUtils.parseColor(context, tag.color!)
            : FlutterFlowTheme.of(context).info;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tag.icon != null) ...[
                Icon(_getIconData(tag.icon!), size: 12, color: color),
                const SizedBox(width: 4),
              ],
              Text(
                tag.text ?? '',
                style: GoogleFonts.outfit(
                  color: color,
                  fontSize: 11 * FlutterFlowTheme.fontSizeFactor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'flash_on':
        return Icons.flash_on;
      case 'verified':
        return Icons.verified;
      case 'lock':
        return Icons.lock;
      case 'public':
        return Icons.public;
      default:
        return Icons.star;
    }
  }
}

class _TechnicalSpecsWidget extends StatelessWidget {
  final ServiceTechnicalInfo info;
  const _TechnicalSpecsWidget({required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Especificaciones Técnicas',
            style: GoogleFonts.outfit(
                fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primaryText)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: FlutterFlowTheme.of(context).alternate),
          ),
          child: Column(
            children: [
              if (info.platform != null)
                _buildRow(context, 'Plataforma', info.platform!),
              if (info.region != 'GLOBAL')
                _buildRow(context, 'Región', info.region),
              if (info.deviceLimit != null)
                _buildRow(context, 'Límite de dispositivos',
                    '${info.deviceLimit} Pantalla(s)'),
              if (info.website != null)
                _buildRow(context, 'Sitio web', info.website!),
              if (info.requirements.isNotEmpty) ...[
                const SizedBox(height: 8),
                Divider(color: FlutterFlowTheme.of(context).alternate),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Requisitos:',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 13 * FlutterFlowTheme.fontSizeFactor)),
                ),
                const SizedBox(height: 4),
                ...info.requirements.map((req) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.circle,
                              size: 4,
                              color:
                                  FlutterFlowTheme.of(context).secondaryText),
                          const SizedBox(width: 8),
                          Text(req,
                              style: GoogleFonts.outfit(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize:
                                      13 * FlutterFlowTheme.fontSizeFactor)),
                        ],
                      ),
                    )),
              ]
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 14 * FlutterFlowTheme.fontSizeFactor)),
          Text(value,
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 14 * FlutterFlowTheme.fontSizeFactor,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
