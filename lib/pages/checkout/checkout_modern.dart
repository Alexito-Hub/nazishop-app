import 'package:flutter/material.dart';
import '/models/service_model.dart';
import '/models/offer_model.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class CheckoutModernWidget extends StatefulWidget {
  final Service? service;
  final Offer? selectedOffer;

  const CheckoutModernWidget({
    super.key,
    this.service,
    this.selectedOffer,
  });

  @override
  State<CheckoutModernWidget> createState() => _CheckoutModernWidgetState();
}

class _CheckoutModernWidgetState extends State<CheckoutModernWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen de Compra',
                      style: FlutterFlowTheme.of(context).headlineMedium,
                    ),
                    const SizedBox(height: 24),
                    if (widget.service != null)
                      Text(
                        'Servicio: ${widget.service!.name}',
                        style: FlutterFlowTheme.of(context).bodyLarge,
                      ),
                    const SizedBox(height: 8),
                    if (widget.selectedOffer != null)
                      Text(
                        'Oferta: ${widget.selectedOffer!.title}',
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                    // Más detalles de pago...
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
