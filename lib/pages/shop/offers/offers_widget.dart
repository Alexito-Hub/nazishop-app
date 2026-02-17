import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/catalog_service.dart';
import '/backend/icon_helper.dart';
import 'package:nazi_shop/backend/currency_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'offers_model.dart';
import '../../../components/smart_back_button.dart';
export 'offers_model.dart';

class OffersWidget extends StatefulWidget {
  const OffersWidget({super.key});

  static String routeName = 'offers';
  static String routePath = '/offers';

  @override
  State<OffersWidget> createState() => _OffersWidgetState();
}

class _OffersWidgetState extends State<OffersWidget> {
  late OffersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OffersModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: isDesktop
            ? null
            : AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: false,
                leading: SmartBackButton(
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                title: Text(
                  'Ofertas Especiales',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 22.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                centerTitle: true,
                elevation: 2.0,
              ),
        body: SafeArea(
          top: true,
          child: Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
                child: FutureBuilder<List<dynamic>>(
                  future: CatalogService.getAllServices(limit: 5),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Error cargando ofertas: ${snapshot.error}'));
                    }

                    final products = snapshot.data ?? [];

                    // If no real products, show fallback for demo
                    // But in production we prefer empty state or just the products
                    final displayProducts = products.isEmpty ? [] : products;

                    return Column(
                      children: [
                        if (isDesktop)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  onPressed: () => context.pop(),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Ofertas Especiales',
                                  style: FlutterFlowTheme.of(context)
                                      .displaySmall
                                      .override(
                                        font: GoogleFonts.inter(),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        // Banner principal
                        Container(
                          width: double.infinity,
                          height: isDesktop ? 200.0 : 160.0,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4B39EF), Color(0xFFEE8B60)],
                              stops: [0.0, 1.0],
                              begin: AlignmentDirectional(-1.0, -1.0),
                              end: AlignmentDirectional(1.0, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4B39EF)
                                    .withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 24,
                                left: 24,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '🔥 OFERTAS ESPECIALES',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: isDesktop ? 24.0 : 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Descuentos exclusivos por tiempo limitado',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: isDesktop ? 16.0 : 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 24,
                                right: 24,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Hasta 50% OFF',
                                    style: TextStyle(
                                      color: Colors
                                          .white, // Keep white on colored badge
                                      fontSize: isDesktop ? 16.0 : 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Grid de productos en oferta
                        if (displayProducts.isNotEmpty)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isDesktop ? 2 : 1,
                              childAspectRatio: isDesktop ? 3.5 : 4.0,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: displayProducts.length,
                            itemBuilder: (context, index) {
                              final product = displayProducts[index];
                              return _buildOfferCard(product, isDesktop);
                            },
                          )
                        else
                          // Estado vacío
                          Container(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.local_offer_outlined,
                                  size: isDesktop ? 80 : 60,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No hay ofertas disponibles',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard(dynamic product, bool isDesktop) {
    // Determine if product is a Map (from API) or a Service object
    final bool isMap = product is Map<String, dynamic>;

    // Extract values safely
    final String serviceName =
        isMap ? (product['name'] ?? 'Servicio') : product.name;
    final String description =
        isMap ? (product['description'] ?? '') : product.description;
    final dynamic priceVal = isMap ? product['price'] : product.price;
    final dynamic colorVal =
        isMap ? product['color'] : product.branding?.primaryColor;
    final dynamic iconCode = isMap ? product['iconCode'] : product.iconCode;
    final serviceId =
        isMap ? (product['serviceId'] ?? product['id']) : product.id;

    final color =
        colorVal != null ? Color(colorVal) : FlutterFlowTheme.of(context).info;
    final icon =
        iconCode != null ? IconHelper.getIcon(iconCode) : Icons.local_offer;

    final priceStr = CurrencyService.formatFromUSD(priceVal is num
        ? priceVal.toDouble()
        : double.tryParse(priceVal.toString()) ?? 0);

    // Simulate an original price roughly 30% higher for "discount" visual
    final double originalPriceVal = (priceVal is num
            ? priceVal.toDouble()
            : (double.tryParse(priceVal.toString()) ?? 0)) *
        1.3;
    final originalPriceStr = CurrencyService.formatFromUSD(originalPriceVal);

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'service_detail',
            queryParameters: {
              'serviceId': serviceId,
              'serviceName': serviceName,
              'serviceIcon': icon.codePoint.toString(),
              'serviceColor': color.toARGB32().toString(),
            }.withoutNulls,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: isDesktop ? 32 : 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serviceName,
                              style: TextStyle(
                                fontSize: isDesktop ? 20 : 18,
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            if (description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: isDesktop ? 14 : 12,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Precios
                  Row(
                    children: [
                      Text(
                        originalPriceStr,
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 14,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        priceStr,
                        style: TextStyle(
                          fontSize: isDesktop ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const Spacer(),
                      FlutterFlowIconButton(
                        borderColor: color,
                        borderRadius: 12.0,
                        borderWidth: 2.0,
                        buttonSize: 44.0,
                        icon: Icon(
                          Icons.arrow_forward,
                          color: color,
                          size: 20.0,
                        ),
                        onPressed: () {
                          context.pushNamed(
                            'service_detail',
                            queryParameters: {
                              'serviceId': serviceId,
                              'serviceName': serviceName,
                              'serviceIcon': icon.codePoint.toString(),
                              'serviceColor': color.toARGB32().toString(),
                            }.withoutNulls,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Badge de descuento
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '30% OFF',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).tertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
