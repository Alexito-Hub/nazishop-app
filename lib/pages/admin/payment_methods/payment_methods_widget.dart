import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_snackbar.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import 'payment_methods_model.dart';
export 'payment_methods_model.dart';

class PaymentMethodsWidget extends StatefulWidget {
  const PaymentMethodsWidget({super.key});

  @override
  State<PaymentMethodsWidget> createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends State<PaymentMethodsWidget> {
  late PaymentMethodsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentMethodsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
          backgroundColor: FlutterFlowTheme.of(context).transparent,
          expandedHeight: 120,
          pinned: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context)
                    .primaryBackground
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SmartBackButton(
                  color: FlutterFlowTheme.of(context).primaryText),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Métodos de Pago',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                    FlutterFlowTheme.of(context).transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildContent(isDesktop: false),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context)
                      .primaryText
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: FlutterFlowTheme.of(context)
                          .primaryText
                          .withValues(alpha: 0.1)),
                ),
                child:
                    BackButton(color: FlutterFlowTheme.of(context).primaryText),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(48),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .primaryText
                          .withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                          color: FlutterFlowTheme.of(context)
                              .primaryText
                              .withValues(alpha: 0.1)),
                    ),
                    child: _buildContent(isDesktop: true),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent({required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDesktop) ...[
          Icon(Icons.payment,
              color: FlutterFlowTheme.of(context).primary, size: 48),
          const SizedBox(height: 16),
          Text(
            'Pasarelas de Pago Activas',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
        ] else
          Text(
            'PASARELAS ACTIVAS',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        const SizedBox(height: 24.0),
        if (isDesktop)
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              SizedBox(
                  width: 400,
                  child: _buildPaymentMethod(
                      'PayPal', 'Pagos internacionales', Icons.paypal, true)),
              SizedBox(
                  width: 400,
                  child: _buildPaymentMethod('Stripe', 'Tarjetas de crédito',
                      Icons.credit_card, true)),
              SizedBox(
                  width: 400,
                  child: _buildPaymentMethod(
                      'MercadoPago', 'Latinoamérica', Icons.store, true)),
              SizedBox(
                  width: 400,
                  child: _buildPaymentMethod('Transferencia Bancaria',
                      'Bancos locales', Icons.account_balance, false)),
              SizedBox(
                  width: 400,
                  child: _buildPaymentMethod(
                      'Efectivo', 'Pago en tienda', Icons.money, false)),
              SizedBox(
                  width: 400,
                  child: _buildPaymentMethod('Criptomonedas', 'Bitcoin, USDT',
                      Icons.currency_bitcoin, false)),
            ],
          )
        else ...[
          _buildPaymentMethod(
              'PayPal', 'Pagos internacionales', Icons.paypal, true),
          _buildPaymentMethod(
              'Stripe', 'Tarjetas de crédito', Icons.credit_card, true),
          _buildPaymentMethod(
              'MercadoPago', 'Latinoamérica', Icons.store, true),
          _buildPaymentMethod('Transferencia Bancaria', 'Bancos locales',
              Icons.account_balance, false),
          _buildPaymentMethod('Efectivo', 'Pago en tienda', Icons.money, false),
          _buildPaymentMethod(
              'Criptomonedas', 'Bitcoin, USDT', Icons.currency_bitcoin, false),
        ],
        if (!isDesktop) const SizedBox(height: 32),
        SizedBox(
          width: isDesktop ? 400 : double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              CustomSnackBar.success(
                context,
                'La configuración de métodos de pago se ha guardado correctamente',
                title: 'Configuración Guardada',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Guardar Cambios',
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(
      String name, String description, IconData icon, bool enabled) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryText.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
            color: enabled
                ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3)
                : FlutterFlowTheme.of(context)
                    .primaryText
                    .withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: enabled
                  ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1)
                  : FlutterFlowTheme.of(context)
                      .primaryText
                      .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Icon(icon,
                color: enabled
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).secondaryText,
                size: 28.0),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text(description,
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12)),
              ],
            ),
          ),
          Switch(
              value: enabled,
              onChanged: (val) {},
              activeThumbColor: FlutterFlowTheme.of(context).primary,
              activeTrackColor:
                  FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
              inactiveTrackColor: FlutterFlowTheme.of(context)
                  .primaryText
                  .withValues(alpha: 0.1),
              thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return FlutterFlowTheme.of(context).secondaryText;
                }
                return Colors.white38;
              })),
        ],
      ),
    );
  }
}
