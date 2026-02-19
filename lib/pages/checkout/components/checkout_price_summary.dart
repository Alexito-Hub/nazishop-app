import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/backend/currency_service.dart';

class CheckoutPriceSummary extends StatelessWidget {
  final double originalPrice;
  final double discountPrice;
  final double discountPercent;

  const CheckoutPriceSummary({
    super.key,
    required this.originalPrice,
    required this.discountPrice,
    required this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(context, 'Subtotal', originalPrice),
        const SizedBox(height: 12),
        if (discountPercent > 0) ...[
          _buildRow(
            context,
            'Descuento ($discountPercent%)',
            -(originalPrice - discountPrice),
            isDiscount: true,
          ),
          const SizedBox(height: 12),
        ],
        Divider(color: FlutterFlowTheme.of(context).alternate),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total a pagar',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              CurrencyService.formatFromUSD(discountPrice),
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 22 * FlutterFlowTheme.fontSizeFactor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, String label, double amount,
      {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: isDiscount
                ? FlutterFlowTheme.of(context).success
                : FlutterFlowTheme.of(context).secondaryText,
            fontSize: 14 * FlutterFlowTheme.fontSizeFactor,
          ),
        ),
        Text(
          CurrencyService.formatFromUSD(amount),
          style: GoogleFonts.outfit(
            color: isDiscount
                ? FlutterFlowTheme.of(context).success
                : FlutterFlowTheme.of(context).primaryText,
            fontSize: 14 * FlutterFlowTheme.fontSizeFactor,
            fontWeight: isDiscount ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
