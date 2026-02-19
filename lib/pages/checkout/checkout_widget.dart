import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/models/service_model.dart';
import '/models/offer_model.dart';
import '/utils/color_utils.dart';
import '../../components/safe_image.dart';
import '../../backend/order_service.dart';
import '../../auth/nazishop_auth/auth_util.dart';
import '../../backend/wallet_service.dart';
import '../../components/smart_back_button.dart';

import 'components/checkout_product_card.dart';
import 'components/checkout_payment_methods.dart';
import 'components/checkout_balance_card.dart';
import 'components/checkout_price_summary.dart';
import 'components/checkout_header.dart';
import 'components/delivery_info_card.dart';
import 'components/checkout_terms.dart';
import 'components/pay_button.dart';

class CheckoutWidget extends StatefulWidget {
  final Service service;
  final Offer selectedOffer;

  const CheckoutWidget({
    super.key,
    required this.service,
    required this.selectedOffer,
  });

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  int _selectedPaymentMethod = 0;
  bool _isProcessing = false;
  bool _acceptedTerms = false;
  bool _isLoadingBalance = true;

  double _accountBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    if (currentUserUid.isEmpty) {
      if (mounted) setState(() => _isLoadingBalance = false);
      return;
    }

    final walletData = await WalletService.getBalance(currentUserUid);
    if (mounted) {
      setState(() {
        _accountBalance = (walletData['balance'] as num).toDouble();
        _isLoadingBalance = false;
      });
    }
  }

  late final List<PaymentMethodItem> _paymentMethods = [
    PaymentMethodItem('Saldo de cuenta', Icons.account_balance_wallet_rounded,
        FlutterFlowTheme.of(context).primary, true),
    PaymentMethodItem(
        'PayPal', Icons.payments_rounded, const Color(0xFF0070BA), false),
    PaymentMethodItem('Tarjeta de crédito', Icons.credit_card_rounded,
        const Color(0xFF1A1F71), false),
    PaymentMethodItem('Criptomonedas', Icons.currency_bitcoin_rounded,
        const Color(0xFFF7931A), false),
    PaymentMethodItem('Transferencia', Icons.account_balance_rounded,
        FlutterFlowTheme.of(context).success, false),
  ];

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  Color get _primaryColor =>
      ColorUtils.parseColor(context, widget.service.branding.primaryColor);

  bool get _hasEnoughBalance =>
      _accountBalance >= widget.selectedOffer.discountPrice;

  Future<void> _processPayment() async {
    if (!_acceptedTerms) {
      _showErrorSnackbar('Debes aceptar los términos y condiciones');
      return;
    }

    if (_selectedPaymentMethod != 0) {
      _showErrorSnackbar('Este método de pago aún no está disponible');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final response = await OrderService.createOrder(
        widget.selectedOffer.id,
        paymentMethod: 'wallet',
      );

      if (response['status'] == true) {
        if (mounted) {
          setState(() => _isProcessing = false);

          final orderData = response['data'];
          final orderId = orderData['_id'] ?? 'UNKNOWN';

          if (widget.selectedOffer.domainType == 'own_domain') {
            context.go('/customer_info?orderId=$orderId');
          } else {
            context.go(
                '/purchaseSuccess?serviceName=${Uri.encodeComponent(widget.service.name)}&orderId=$orderId');
          }
        }
      } else {
        if (mounted) {
          setState(() => _isProcessing = false);
          _showErrorSnackbar(response['msg'] ?? 'Error al procesar el pago');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showErrorSnackbar('Error de conexión: $e');
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.outfit()),
        backgroundColor: FlutterFlowTheme.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (_isDesktop) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  // ===================== MOBILE LAYOUT =====================
  Widget _buildMobileLayout() {
    return Stack(
      children: [
        CustomScrollView(
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
                      .primaryBackground
                      .withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: SmartBackButton(
                    color: FlutterFlowTheme.of(context).primaryText),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .success
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: FlutterFlowTheme.of(context)
                              .success
                              .withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_rounded,
                            color: FlutterFlowTheme.of(context).success,
                            size: 12),
                        const SizedBox(width: 4),
                        Text('Pago Seguro',
                            style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).success,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (widget.service.branding.bannerUrl != null)
                      SafeImage(
                        imageUrl: widget.service.branding.bannerUrl,
                        fit: BoxFit.cover,
                        fallbackColor: _primaryColor,
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _primaryColor.withOpacity(0.3),
                              _primaryColor.withOpacity(0.1)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            FlutterFlowTheme.of(context).primaryBackground,
                            FlutterFlowTheme.of(context)
                                .primaryBackground
                                .withOpacity(0.0),
                            FlutterFlowTheme.of(context)
                                .primaryBackground
                                .withOpacity(0.8),
                            FlutterFlowTheme.of(context).primaryBackground,
                          ],
                          stops: const [0.0, 0.2, 0.7, 1.0],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
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
                                  color:
                                      FlutterFlowTheme.of(context).alternate),
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryColor.withOpacity(0.2),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: widget.service.branding.logoUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      widget.service.branding.logoUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(Icons.shopping_bag_rounded,
                                    color: _primaryColor, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Confirmar Pedido',
                                  style: GoogleFonts.outfit(
                                    fontSize:
                                        24 * FlutterFlowTheme.fontSizeFactor,
                                    fontWeight: FontWeight.bold,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.service.name,
                                  style: GoogleFonts.outfit(
                                    fontSize:
                                        13 * FlutterFlowTheme.fontSizeFactor,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckoutProductCard(
                        service: widget.service,
                        selectedOffer: widget.selectedOffer),
                    const SizedBox(height: 16),
                    DeliveryInfoCard(selectedOffer: widget.selectedOffer),
                    const SizedBox(height: 32),
                    CheckoutPaymentMethods(
                      methods: _paymentMethods,
                      selectedIndex: _selectedPaymentMethod,
                      onSelect: (index) =>
                          setState(() => _selectedPaymentMethod = index),
                    ),
                    const SizedBox(height: 24),
                    CheckoutBalanceCard(
                        balance: _accountBalance, isLoading: _isLoadingBalance),
                    const SizedBox(height: 24),
                    CheckoutTerms(
                      accepted: _acceptedTerms,
                      onChanged: (v) => setState(() => _acceptedTerms = v),
                      activeColor: _primaryColor,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildMobileBottomBar(),
        ),
      ],
    );
  }

  // ===================== DESKTOP LAYOUT =====================
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CheckoutHeader(),
                    const SizedBox(height: 40),
                    CheckoutProductCard(
                      service: widget.service,
                      selectedOffer: widget.selectedOffer,
                      isDesktop: true,
                    ),
                    const SizedBox(height: 24),
                    DeliveryInfoCard(selectedOffer: widget.selectedOffer),
                    const SizedBox(height: 40),
                    CheckoutPaymentMethods(
                      methods: _paymentMethods,
                      selectedIndex: _selectedPaymentMethod,
                      onSelect: (index) =>
                          setState(() => _selectedPaymentMethod = index),
                      showTitle: true,
                    ),
                    const SizedBox(height: 100),
                  ],
                ).animate().fadeIn(duration: 400.ms),
              ),
              const SizedBox(width: 60),
              SizedBox(
                width: 400,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Resumen de orden',
                              style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryText)),
                          const SizedBox(height: 24),
                          CheckoutBalanceCard(
                              balance: _accountBalance,
                              isLoading: _isLoadingBalance),
                          const SizedBox(height: 32),
                          CheckoutPriceSummary(
                            originalPrice: widget.selectedOffer.originalPrice,
                            discountPrice: widget.selectedOffer.discountPrice,
                            discountPercent:
                                widget.selectedOffer.discountPercent.toDouble(),
                          ),
                          const SizedBox(height: 24),
                          Divider(
                              color: FlutterFlowTheme.of(context).alternate),
                          const SizedBox(height: 16),
                          CheckoutTerms(
                            accepted: _acceptedTerms,
                            onChanged: (v) =>
                                setState(() => _acceptedTerms = v),
                            activeColor: _primaryColor,
                          ),
                          const SizedBox(height: 36),
                          PayButton(
                            isProcessing: _isProcessing,
                            onPressed: _processPayment,
                            color: _primaryColor,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.security,
                                  size: 16,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText),
                              const SizedBox(width: 8),
                              Text('Pagos seguros & encriptados',
                                  style: GoogleFonts.outfit(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 12)),
                            ],
                          ),
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

  Widget _buildMobileBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckoutPriceSummary(
              originalPrice: widget.selectedOffer.originalPrice,
              discountPrice: widget.selectedOffer.discountPrice,
              discountPercent: widget.selectedOffer.discountPercent.toDouble(),
            ),
            const SizedBox(height: 20),
            PayButton(
              isProcessing: _isProcessing,
              onPressed: _processPayment,
              color: _primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
