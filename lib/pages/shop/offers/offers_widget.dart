import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/catalog_service.dart';
import '/models/service_model.dart';
import '/components/smart_back_button.dart';

import 'offers_model.dart';
import 'components/offers_banner.dart';
import 'components/offer_grid.dart';

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
                child: FutureBuilder<List<Service>>(
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
                        // Modular Banner
                        OffersBanner(isDesktop: isDesktop),

                        const SizedBox(height: 32),

                        // Grid de productos en oferta
                        OfferGrid(
                          products: products,
                          isDesktop: isDesktop,
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
}
