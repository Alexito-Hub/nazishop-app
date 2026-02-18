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
  // String _currency = 'USD';

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    // Si no hay usuario logueado, usar balance 0
    // En auth_util currentUserUid puede ser null o vacío si no está auth
    if (currentUserUid.isEmpty) {
      if (mounted) setState(() => _isLoadingBalance = false);
      return;
    }

    final walletData = await WalletService.getBalance(currentUserUid);
    if (mounted) {
      setState(() {
        _accountBalance = (walletData['balance'] as num).toDouble();
        // _currency = walletData['currency'] ?? 'USD';
        _isLoadingBalance = false;
      });
    }
  }

  late final List<_PaymentMethod> _paymentMethods = [
    _PaymentMethod('Saldo de cuenta', Icons.account_balance_wallet_rounded,
        FlutterFlowTheme.of(context).primary, true),
    _PaymentMethod(
        'PayPal', Icons.payments_rounded, const Color(0xFF0070BA), false),
    _PaymentMethod('Tarjeta de crédito', Icons.credit_card_rounded,
        const Color(0xFF1A1F71), false),
    _PaymentMethod('Criptomonedas', Icons.currency_bitcoin_rounded,
        const Color(0xFFF7931A), false),
    _PaymentMethod('Transferencia', Icons.account_balance_rounded,
        FlutterFlowTheme.of(context).success, false),
  ];

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  Color get _primaryColor =>
      ColorUtils.parseColor(context, widget.service.branding.primaryColor);

  bool get _hasEnoughBalance =>
      _accountBalance >= widget.selectedOffer.discountPrice;

  String _getOfferDuration() {
    final commercial = widget.selectedOffer.commercialData;
    if (commercial == null || commercial.duration == null) return '';
    final unit = commercial.timeUnit ?? 'mes';
    return '${commercial.duration} $unit${commercial.duration! > 1 ? 'es' : ''}';
  }

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
      // Llamada real al backend para crear la orden
      final response = await OrderService.createOrder(
        widget.selectedOffer.id,
        paymentMethod: 'wallet',
      );

      if (response['status'] == true) {
        if (mounted) {
          setState(() => _isProcessing = false);

          final orderData = response['data'];
          final orderId = orderData['_id'] ?? 'UNKNOWN';

          // Navigate to success or customer info page
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
                      .withValues(alpha: 0.5),
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
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: FlutterFlowTheme.of(context)
                              .success
                              .withValues(alpha: 0.5)),
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
                              _primaryColor.withValues(alpha: 0.3),
                              _primaryColor.withValues(alpha: 0.1)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    // Gradiente agresivo para legibilidad
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            FlutterFlowTheme.of(context).primaryBackground,
                            FlutterFlowTheme.of(context)
                                .primaryBackground
                                .withValues(alpha: 0.0),
                            FlutterFlowTheme.of(context)
                                .primaryBackground
                                .withValues(alpha: 0.8),
                            FlutterFlowTheme.of(context).primaryBackground,
                          ],
                          stops: const [0.0, 0.2, 0.7, 1.0],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    // Header con logo y título
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
                                  color: _primaryColor.withValues(alpha: 0.2),
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
                    _buildProductCard(),
                    const SizedBox(height: 16),
                    _buildDeliveryInfo(),
                    const SizedBox(height: 32),
                    _buildPaymentMethodsSection(),
                    const SizedBox(height: 24),
                    _buildBalanceCard(), // Mover balance después de métodos de pago
                    const SizedBox(height: 24),
                    _buildTermsRow(),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
            ),
          ],
        ),
        // Bottom bar fijo
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
              // Left side - Details & Payment Selection
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDesktopHeader(),
                    const SizedBox(height: 40),
                    _buildDesktopProductCard(),
                    const SizedBox(height: 24),
                    _buildDeliveryInfo(), // Added delivery info
                    const SizedBox(height: 40),
                    Text(
                      'Método de pago',
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildPaymentMethodsSection(showTitle: false),
                    const SizedBox(height: 40),
                    if (widget.service.features != null &&
                        widget.service.features!.isNotEmpty)
                      _buildFeaturesSection(),
                    const SizedBox(height: 100),
                  ],
                ).animate().fadeIn(duration: 400.ms),
              ),
              const SizedBox(width: 60),
              // Right side - Summary & Action (Fixed Width 400)
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
                            color: Colors.black.withValues(alpha: 0.5),
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
                          _buildBalanceCard(),
                          const SizedBox(height: 32),
                          _buildPriceSummary(),
                          const SizedBox(height: 24),
                          Divider(
                              color: FlutterFlowTheme.of(context).alternate),
                          const SizedBox(height: 16),
                          _buildTermsRow(),
                          const SizedBox(height: 36),
                          _buildPayButton(),
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

  Widget _buildDesktopHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button styled igual que service_detail
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back,
                    color: FlutterFlowTheme.of(context).secondaryText),
                const SizedBox(width: 8),
                Text('Volver al servicio',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context)
                    .success
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_rounded,
                      color: FlutterFlowTheme.of(context).success, size: 14),
                  const SizedBox(width: 6),
                  Text('Pago seguro',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).success,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Finalizar compra',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 36,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Revisa los detalles antes de confirmar',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 15)),
      ],
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline,
                  color: FlutterFlowTheme.of(context).secondaryText, size: 20),
              const SizedBox(width: 8),
              Text('Información de entrega',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16 * FlutterFlowTheme.fontSizeFactor,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.selectedOffer.dataDeliveryType == 'full_account'
                ? 'Recibirás un correo electrónico con las credenciales de acceso (usuario y contraseña) inmediatamente después del pago.'
                : widget.selectedOffer.dataDeliveryType == 'profile_access'
                    ? 'Recibirás los datos de acceso a tu perfil asignado. Es importante respetar el perfil asignado.'
                    : widget.selectedOffer.dataDeliveryType == 'domain'
                        ? (widget.selectedOffer.domainType == 'own_domain'
                            ? 'Se solicitarán las credenciales de tu dominio al finalizar la compra para realizar la activación.'
                            : 'Recibirás una cuenta con el producto activado lista para usar.')
                        : 'Recibirás tu código de licencia inmediatamente en tu correo y en el historial de compras.',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 13 * FlutterFlowTheme.fontSizeFactor,
                height: 1.5),
          ),
        ],
      ),
    );
  }

  // ===================== SHARED WIDGETS =====================
  Widget _buildProductCard() {
    final duration = _getOfferDuration();
    final hasDiscount = widget.selectedOffer.discountPercent > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.service.branding.logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(widget.service.branding.logoUrl!,
                        fit: BoxFit.contain),
                  )
                : Icon(Icons.subscriptions, color: _primaryColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.service.name,
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 15 * FlutterFlowTheme.fontSizeFactor,
                        fontWeight: FontWeight.w600)),
                Text(widget.selectedOffer.title,
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12 * FlutterFlowTheme.fontSizeFactor)),
                if (duration.isNotEmpty)
                  Text(duration,
                      style: GoogleFonts.outfit(
                          color: _primaryColor,
                          fontSize: 11 * FlutterFlowTheme.fontSizeFactor,
                          fontWeight: FontWeight.w600)),
                if (widget.selectedOffer.dataDeliveryType != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .alternate
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.selectedOffer.dataDeliveryType == 'full_account'
                          ? 'Cuenta Completa'
                          : widget.selectedOffer.dataDeliveryType ==
                                  'profile_access'
                              ? 'Perfil Individual'
                              : 'Licencia Digital',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 10 * FlutterFlowTheme.fontSizeFactor),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (hasDiscount)
                Text(
                    '\$${widget.selectedOffer.originalPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12 * FlutterFlowTheme.fontSizeFactor,
                        decoration: TextDecoration.lineThrough)),
              Text('\$${widget.selectedOffer.discountPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopProductCard() {
    final duration = _getOfferDuration();
    final hasDiscount = widget.selectedOffer.discountPercent > 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color:
                  FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: widget.service.branding.logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(widget.service.branding.logoUrl!,
                        fit: BoxFit.contain),
                  )
                : Icon(Icons.subscriptions, color: _primaryColor, size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.service.name,
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.selectedOffer.title,
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14)),
                if (duration.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .alternate
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate),
                        ),
                        child: Text(duration,
                            style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                      if (widget.selectedOffer.dataDeliveryType != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .info
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .info
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Text(
                              widget.selectedOffer.dataDeliveryType ==
                                      'full_account'
                                  ? 'Cuenta Completa'
                                  : widget.selectedOffer.dataDeliveryType ==
                                          'profile_access'
                                      ? 'Perfil Individual'
                                      : 'Licencia Digital',
                              style: GoogleFonts.outfit(
                                  color: FlutterFlowTheme.of(context).info,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (hasDiscount) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        '\$${widget.selectedOffer.originalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 13,
                            decoration: TextDecoration.lineThrough)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .primary
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text('-${widget.selectedOffer.discountPercent}%',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              Text('\$${widget.selectedOffer.discountPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    if (_isLoadingBalance) {
      return Container(
          height: 60,
          alignment: Alignment.center,
          child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  strokeWidth: 2)));
    }

    final needsMore = widget.selectedOffer.discountPrice - _accountBalance;
    final successColor = FlutterFlowTheme.of(context).success;
    final warningColor = FlutterFlowTheme.of(context).warning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _hasEnoughBalance
            ? successColor.withValues(alpha: 0.08)
            : warningColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _hasEnoughBalance ? successColor : warningColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _hasEnoughBalance
                  ? successColor.withValues(alpha: 0.2)
                  : warningColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: _hasEnoughBalance ? successColor : warningColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tu saldo',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12 * FlutterFlowTheme.fontSizeFactor)),
                Text('\$${_accountBalance.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (_hasEnoughBalance)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: successColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: successColor.withValues(alpha: 0.5),
                ),
              ),
              child: Text('SUFICIENTE',
                  style: GoogleFonts.outfit(
                      color: successColor,
                      fontSize: 11 * FlutterFlowTheme.fontSizeFactor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5)),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Necesitas +\$${needsMore.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                        color: warningColor,
                        fontSize: 12 * FlutterFlowTheme.fontSizeFactor,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: warningColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('RECARGAR',
                      style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).tertiary,
                          fontSize: 11 * FlutterFlowTheme.fontSizeFactor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection({bool showTitle = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text('Método de pago',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
        ],
        ...List.generate(_paymentMethods.length, (index) {
          final method = _paymentMethods[index];
          final isSelected = _selectedPaymentMethod == index;
          final isAvailable = method.isAvailable;
          // Si el método no está disponible, mantenemos su color en opacidad baja pero gris
          final safeColor = isAvailable
              ? method.color
              : FlutterFlowTheme.of(context).secondaryText;

          return GestureDetector(
            onTap: isAvailable
                ? () => setState(() => _selectedPaymentMethod = index)
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected && isAvailable
                    ? safeColor.withValues(alpha: 0.08)
                    : FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected && isAvailable
                      ? safeColor
                      : FlutterFlowTheme.of(context).alternate,
                  width: isSelected && isAvailable ? 2 : 1,
                ),
                boxShadow: isSelected && isAvailable
                    ? [
                        BoxShadow(
                          color: safeColor.withValues(alpha: 0.1),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  // Radio
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isAvailable
                            ? (isSelected
                                ? safeColor
                                : FlutterFlowTheme.of(context).secondaryText)
                            : FlutterFlowTheme.of(context).alternate,
                        width: 2,
                      ),
                    ),
                    child: isSelected && isAvailable
                        ? Center(
                            child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: safeColor, shape: BoxShape.circle)))
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Icon(method.icon,
                      color: isAvailable
                          ? (isSelected
                              ? safeColor
                              : FlutterFlowTheme.of(context).secondaryText)
                          : FlutterFlowTheme.of(context).alternate,
                      size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          method.name,
                          style: GoogleFonts.outfit(
                            color: isAvailable
                                ? (isSelected
                                    ? FlutterFlowTheme.of(context).primaryText
                                    : FlutterFlowTheme.of(context)
                                        .secondaryText)
                                : FlutterFlowTheme.of(context).alternate,
                            fontSize: 14 * FlutterFlowTheme.fontSizeFactor,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        if (!isAvailable)
                          Text('Próximamente',
                              style: GoogleFonts.outfit(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  fontSize:
                                      11 * FlutterFlowTheme.fontSizeFactor)),
                      ],
                    ),
                  ),
                  if (!isAvailable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .alternate
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('SOON',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 9 * FlutterFlowTheme.fontSizeFactor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1)),
                    ),
                ],
              ),
            ),
          ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.02);
        }),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Incluido en el servicio',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.service.features!
              .map((f) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate),
                    ),
                    child: Text(f,
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 13 * FlutterFlowTheme.fontSizeFactor)),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    final hasDiscount = widget.selectedOffer.discountPercent > 0;
    final savings =
        widget.selectedOffer.originalPrice - widget.selectedOffer.discountPrice;
    final successColor = FlutterFlowTheme.of(context).success;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 13 * FlutterFlowTheme.fontSizeFactor)),
              Text('\$${widget.selectedOffer.originalPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 13 * FlutterFlowTheme.fontSizeFactor)),
            ],
          ),
          if (hasDiscount) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Descuento',
                    style: GoogleFonts.outfit(
                        color: successColor,
                        fontSize: 13 * FlutterFlowTheme.fontSizeFactor)),
                Text('-\$${savings.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                        color: successColor,
                        fontSize: 13 * FlutterFlowTheme.fontSizeFactor,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: FlutterFlowTheme.of(context).alternate)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 15 * FlutterFlowTheme.fontSizeFactor,
                      fontWeight: FontWeight.bold)),
              Text('\$${widget.selectedOffer.discountPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 22 * FlutterFlowTheme.fontSizeFactor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermsRow() {
    return GestureDetector(
      onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              gradient: _acceptedTerms
                  ? LinearGradient(colors: [
                      _primaryColor,
                      _primaryColor.withValues(alpha: 0.8)
                    ])
                  : null,
              color: _acceptedTerms
                  ? null
                  : FlutterFlowTheme.of(context).transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: _acceptedTerms
                      ? _primaryColor
                      : FlutterFlowTheme.of(context).secondaryText,
                  width: 2),
            ),
            child: _acceptedTerms
                ? Icon(Icons.check_rounded,
                    color: FlutterFlowTheme.of(context).tertiary, size: 15)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'Acepto los ',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 13 * FlutterFlowTheme.fontSizeFactor),
                children: [
                  TextSpan(
                      text: 'términos y condiciones',
                      style: TextStyle(
                          color: _primaryColor, fontWeight: FontWeight.w500)),
                  const TextSpan(text: ' del servicio'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 18,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        border: Border(
            top: BorderSide(color: FlutterFlowTheme.of(context).alternate)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total a pagar',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 11 * FlutterFlowTheme.fontSizeFactor)),
              Text('\$${widget.selectedOffer.discountPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 24 * FlutterFlowTheme.fontSizeFactor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(child: _buildPayButton()),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    final canPay = _selectedPaymentMethod == 0 && _hasEnoughBalance;

    return ElevatedButton(
      onPressed: _isProcessing ? null : _processPayment,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            canPay ? _primaryColor : FlutterFlowTheme.of(context).alternate,
        foregroundColor: FlutterFlowTheme.of(context).tertiary,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        disabledBackgroundColor: _primaryColor.withValues(alpha: 0.5),
        elevation: 0,
      ),
      child: _isProcessing
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).tertiary, strokeWidth: 2))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    canPay
                        ? Icons.check_circle_outline_rounded
                        : Icons.lock_outline_rounded,
                    size: 20),
                const SizedBox(width: 8),
                Text(
                  canPay ? 'Confirmar Pago' : 'Saldo insuficiente',
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 15 * FlutterFlowTheme.fontSizeFactor),
                ),
              ],
            ),
    );
  }
}

class _PaymentMethod {
  final String name;
  final IconData icon;
  final Color color;
  final bool isAvailable;

  _PaymentMethod(this.name, this.icon, this.color, this.isAvailable);
}
