import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import 'dart:ui';
import 'inventory_details_model.dart';
export 'inventory_details_model.dart';

class InventoryDetailsWidget extends StatefulWidget {
  const InventoryDetailsWidget({
    super.key,
    this.service,
    this.plan,
    this.available,
    this.total,
    this.price,
  });

  final String? service;
  final String? plan;
  final String? available;
  final String? total;
  final String? price;

  static String routeName = 'inventory_details';
  static String routePath = '/inventoryDetails';

  @override
  State<InventoryDetailsWidget> createState() => _InventoryDetailsWidgetState();
}

class _InventoryDetailsWidgetState extends State<InventoryDetailsWidget> {
  late InventoryDetailsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InventoryDetailsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            // Background Elements
            Positioned(
              top: -100,
              right: -100,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 1100) {
                  return _buildDesktopLayout();
                } else {
                  return _buildMobileLayout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          expandedHeight: 80, // Reduced from 120 since no gradient
          pinned: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SmartBackButton(
                color: FlutterFlowTheme.of(context).primaryText),
          ),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
            title: Text(
              'Detalles de Stock',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildMetricCard(isDesktop: false),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 800), // Smaller for a detail card
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: FlutterFlowTheme.of(context).alternate),
                ),
                child:
                    BackButton(color: FlutterFlowTheme.of(context).primaryText),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildMetricCard(isDesktop: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({required bool isDesktop}) {
    int availableCount = int.tryParse(widget.available ?? '0') ?? 0;
    int totalCount = int.tryParse(widget.total ?? '1') ?? 1;
    if (totalCount == 0) totalCount = 1;
    double percentage = (availableCount / totalCount) * 100;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 48.0 : 24.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        boxShadow: [
          BoxShadow(
            color:
                FlutterFlowTheme.of(context).primaryText.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color:
                  FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 48.0,
              color: FlutterFlowTheme.of(context).primary,
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            widget.service ?? 'Servicio',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.plan != null && widget.plan!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.plan!,
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 48.0),
          _buildDetailRow('Precio', widget.price ?? '\$0'),
          Divider(height: 32.0, color: FlutterFlowTheme.of(context).alternate),
          _buildDetailRow('Stock Total', widget.total ?? '0'),
          Divider(height: 32.0, color: FlutterFlowTheme.of(context).alternate),
          _buildDetailRow('Disponibles', widget.available ?? '0'),
          Divider(height: 32.0, color: FlutterFlowTheme.of(context).alternate),
          _buildDetailRow('Vendidos', (totalCount - availableCount).toString()),
          const SizedBox(height: 48.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Disponibilidad',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: GoogleFonts.outfit(
                      color: percentage >= 50
                          ? FlutterFlowTheme.of(context).success
                          : percentage >= 20
                              ? FlutterFlowTheme.of(context).warning
                              : FlutterFlowTheme.of(context).error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: availableCount / totalCount,
                  backgroundColor: FlutterFlowTheme.of(context).alternate,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage >= 50
                        ? FlutterFlowTheme.of(context).success
                        : percentage >= 20
                            ? FlutterFlowTheme.of(context).warning
                            : FlutterFlowTheme.of(context).error,
                  ),
                  minHeight: 12.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Keep original weirdness but maybe clearer
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  content: Text(
                    'Para añadir stock, usa la gestión de ofertas principal.',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).info),
                  ),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                foregroundColor: FlutterFlowTheme.of(context).primaryText,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                side: BorderSide(color: FlutterFlowTheme.of(context).alternate),
              ),
              child: Text('Gestionar Stock',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
              fontSize: 14.0,
              color: FlutterFlowTheme.of(context).secondaryText),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
              fontSize: 16.0,
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
