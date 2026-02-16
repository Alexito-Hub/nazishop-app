import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/models/service_model.dart';
import '/backend/favorites_service.dart';
// import 'package:flutter_animate/flutter_animate.dart';

class ServiceCardModern extends StatefulWidget {
  final Service service;
  final Color primaryColor;

  const ServiceCardModern({
    super.key,
    required this.service,
    required this.primaryColor,
  });

  @override
  State<ServiceCardModern> createState() => _ServiceCardModernState();
}

class _ServiceCardModernState extends State<ServiceCardModern> {
  bool _isHovered = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Optimistic check or load if needed.
    // For now, we start generic. Real app might want to check status.
  }

  Future<void> _toggleFavorite() async {
    setState(() => _isFavorite = !_isFavorite);
    // Call backend
    await FavoritesService.toggleFavorite(widget.service.id);
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = _isHovered
        ? widget.primaryColor.withValues(alpha: 0.5)
        : FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.3);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/service/${widget.service.id}',
            extra: widget.service),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translateByDouble(0.0, _isHovered ? -8.0 : 0.0, 0.0, 1.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.primaryColor.withValues(alpha: 0.25),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. HEADER IMAGEN
                Expanded(
                  flex: 10,
                  child: Stack(
                    children: [
                      // Fondo Imagen
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        child: (widget.service.branding.logoUrl
                                    ?.startsWith('http') ??
                                false)
                            ? Image.network(
                                widget.service.branding.logoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildPlaceholder(),
                                loadingBuilder: (ctx, child, progress) {
                                  if (progress == null) return child;
                                  return Center(
                                      child: CircularProgressIndicator(
                                          color: widget.primaryColor,
                                          strokeWidth: 2));
                                },
                              )
                            : _buildPlaceholder(),
                      ),

                      // Gradiente Overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.6)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Top Row (Badges & Actions)
                      Positioned(
                        top: 12,
                        left: 12,
                        right: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left: Stock & Offer Badges
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Stock Badge (Solid, Clean)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: widget.service.isInStock
                                        ? FlutterFlowTheme.of(context).success
                                        : FlutterFlowTheme.of(context).error,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.service.isInStock
                                            ? 'DISPONIBLE'
                                            : 'AGOTADO',
                                        style: GoogleFonts.outfit(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.service.packageOffers != null &&
                                    widget
                                        .service.packageOffers!.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          FlutterFlowTheme.of(context).warning,
                                          FlutterFlowTheme.of(context).warning,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: FlutterFlowTheme.of(context)
                                              .warning
                                              .withValues(alpha: 0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.star_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            size: 10),
                                        const SizedBox(width: 4),
                                        Text(
                                          'OFERTA',
                                          style: GoogleFonts.outfit(
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            // Right: Favorite Button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _isFavorite
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context).tertiary,
                                  size: 18,
                                ),
                                onPressed: _toggleFavorite,
                                tooltip: _isFavorite
                                    ? 'Quitar de favoritos'
                                    : 'Añadir a favoritos',
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(8),
                                style: IconButton.styleFrom(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. INFO CONTENT (45%)
                Expanded(
                  flex: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top: Title + Rating + Description
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.service.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 15 * FlutterFlowTheme.fontSizeFactor,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Star Rating
                            _buildRatingStars(),
                            const SizedBox(height: 4),
                            Text(
                              widget.service.description.isNotEmpty
                                  ? widget.service.description
                                  : 'Servicio premium disponible para entrega inmediata.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize:
                                      12 * FlutterFlowTheme.fontSizeFactor,
                                  height: 1.3),
                            ),
                          ],
                        ),
                        const Expanded(child: SizedBox()),

                        // Footer: Precio y Botón
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '\$${widget.service.price.toStringAsFixed(2)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.w900,
                                  fontSize:
                                      18 * FlutterFlowTheme.fontSizeFactor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _isHovered
                                      ? [
                                          widget.primaryColor,
                                          widget.primaryColor
                                              .withValues(alpha: 0.8)
                                        ]
                                      : [
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                          FlutterFlowTheme.of(context).alternate
                                        ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: _isHovered
                                    ? FlutterFlowTheme.of(context).tertiary
                                    : FlutterFlowTheme.of(context)
                                        .secondaryText,
                                size: 20,
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
      ),
    );
  }

  Widget _buildRatingStars() {
    // Generate mock rating based on service ID hash for consistency
    final hash = widget.service.id.hashCode.abs();
    final rating = 4.5 + ((hash % 5) / 10); // Generates 4.5-4.9

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            if (index < rating.floor()) {
              // Full star
              return Icon(
                Icons.star_rounded,
                color: FlutterFlowTheme.of(context).warning,
                size: 14,
              );
            } else if (index < rating) {
              // Half star
              return Icon(
                Icons.star_half_rounded,
                color: FlutterFlowTheme.of(context).warning,
                size: 14,
              );
            } else {
              // Empty star
              return Icon(
                Icons.star_outline_rounded,
                color: FlutterFlowTheme.of(context)
                    .secondaryText
                    .withValues(alpha: 0.3),
                size: 14,
              );
            }
          }),
        ),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 12 * FlutterFlowTheme.fontSizeFactor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          image: DecorationImage(
              image: const NetworkImage(
                  "https://www.transparenttextures.com/patterns/cubes.png"),
              colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.8), BlendMode.dstATop),
              fit: BoxFit.cover)),
      child: Center(
        child: Icon(Icons.layers_outlined,
            size: 40, color: widget.primaryColor.withValues(alpha: 0.3)),
      ),
    );
  }
}
