import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'payment_methods_user_model.dart';
import '../../../components/smart_back_button.dart';
export 'payment_methods_user_model.dart';

class PaymentMethodsUserWidget extends StatefulWidget {
  const PaymentMethodsUserWidget({super.key});

  static String routeName = 'payment_methods_user';
  static String routePath = '/paymentMethodsUser';

  @override
  State<PaymentMethodsUserWidget> createState() =>
      _PaymentMethodsUserWidgetState();
}

class _PaymentMethodsUserWidgetState extends State<PaymentMethodsUserWidget> {
  late PaymentMethodsUserModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Consistencia de Diseño

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentMethodsUserModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      body: _isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildMobileLayout() {
    final theme = FlutterFlowTheme.of(context);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: theme.transparent,
          surfaceTintColor: theme.transparent,
          pinned: true,
          floating: true,
          elevation: 0,
          leadingWidth: 70,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.alternate,
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(
              color: theme.primaryText,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Métodos de Pago',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Métodos de Pago',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Builder(builder: (context) {
                        final theme = FlutterFlowTheme.of(context);
                        return Text(
                          'Administra tu saldo y opciones de pago',
                          style: GoogleFonts.outfit(
                              color: theme.secondaryText, fontSize: 16),
                        );
                      }),
                    ],
                  ),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              sliver: SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _buildContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saldo actual Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: theme.alternate,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SALDO DISPONIBLE',
                      style: GoogleFonts.outfit(
                        color: theme.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$0.00',
                      style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: theme.primary,
                    size: 32.0,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 40),

        Text(
          'OPCIONES DE RECARGA',
          style: GoogleFonts.outfit(
            color: theme.secondaryText,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        if (_isDesktop)
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              SizedBox(
                width: 320,
                child: _buildPaymentMethodCard(
                  context,
                  icon: Icons.credit_card,
                  title: 'Tarjeta de Crédito/Débito',
                  subtitle: 'Visa, Mastercard, American Express',
                  color: const Color(0xFF1976D2),
                  isEnabled: true,
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildPaymentMethodCard(
                  context,
                  icon: Icons.paypal,
                  title: 'PayPal',
                  subtitle: 'Paga de forma segura con PayPal',
                  color: const Color(0xFF0070BA),
                  isEnabled: true,
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildPaymentMethodCard(
                  context,
                  icon: Icons.account_balance,
                  title: 'Transferencia Bancaria',
                  subtitle: 'Transferencia directa a cuenta',
                  color: const Color(0xFF388E3C),
                  isEnabled: true,
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildPaymentMethodCard(
                  context,
                  icon: Icons.store,
                  title: 'Efectivo',
                  subtitle: 'Paga en puntos autorizados',
                  color: const Color(0xFFFF6F00),
                  isEnabled: false,
                ),
              ),
              SizedBox(
                width: 320,
                child: _buildPaymentMethodCard(
                  context,
                  icon: Icons.currency_bitcoin,
                  title: 'Criptomonedas',
                  subtitle: 'Bitcoin, Ethereum, USDT',
                  color: const Color(0xFFF7931A),
                  isEnabled: false,
                ),
              ),
            ],
          )
        else ...[
          // Tarjeta de Crédito/Débito
          _buildPaymentMethodCard(
            context,
            icon: Icons.credit_card,
            title: 'Tarjeta de Crédito/Débito',
            subtitle: 'Visa, Mastercard, American Express',
            color: const Color(0xFF1976D2),
            isEnabled: true,
          ),

          // PayPal
          _buildPaymentMethodCard(
            context,
            icon: Icons.paypal,
            title: 'PayPal',
            subtitle: 'Paga de forma segura con PayPal',
            color: const Color(0xFF0070BA),
            isEnabled: false,
          ),

          // Transferencia Bancaria
          _buildPaymentMethodCard(
            context,
            icon: Icons.account_balance,
            title: 'Transferencia Bancaria',
            subtitle: 'Transferencia directa a cuenta',
            color: const Color(0xFF388E3C),
            isEnabled: true,
          ),

          // Efectivo
          _buildPaymentMethodCard(
            context,
            icon: Icons.store,
            title: 'Efectivo',
            subtitle: 'Paga en puntos autorizados',
            color: const Color(0xFFFF6F00),
            isEnabled: false,
          ),

          // Criptomonedas
          _buildPaymentMethodCard(
            context,
            icon: Icons.currency_bitcoin,
            title: 'Criptomonedas',
            subtitle: 'Bitcoin, Ethereum, USDT',
            color: const Color(0xFFF7931A),
            isEnabled: false,
          ),
        ],

        const SizedBox(height: 24.0),

        // Nota informativa
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: theme.alternate,
              width: 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: theme.secondaryText,
                size: 20.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Los métodos marcados como "Habilitados" están activos. Contacta a soporte para más opciones.',
                  style: GoogleFonts.outfit(
                    color: theme.secondaryText,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Espacio para evitar corte en mobile scroll
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isEnabled,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: isEnabled ? theme.alternate : theme.transparent,
          width: 1.0,
        ),
      ),
      child: Material(
        color: theme.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: isEnabled ? () {} : null,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Icono
                Container(
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? color.withValues(alpha: 0.1)
                        : const Color(0xFF0F0F0F),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Icon(
                    icon,
                    color: isEnabled ? color : theme.secondaryText,
                    size: 28.0,
                  ),
                ),
                const SizedBox(width: 20.0),

                // Información
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          color: isEnabled
                              ? theme.primaryText
                              : theme.secondaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          color:
                              isEnabled ? theme.secondaryText : theme.accent3,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Estado
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? color.withValues(alpha: 0.1)
                        : theme.alternate.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: isEnabled
                          ? color.withValues(alpha: 0.2)
                          : theme.alternate,
                    ),
                  ),
                  child: Text(
                    isEnabled ? 'Habilitado' : 'Pronto',
                    style: GoogleFonts.outfit(
                      color: isEnabled ? color : theme.secondaryText,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
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
}
