import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/backend/currency_service.dart';

class CheckoutBalanceCard extends StatelessWidget {
  final double balance;
  final bool isLoading;

  const CheckoutBalanceCard({
    super.key,
    required this.balance,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu saldo disponible',
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 12 * FlutterFlowTheme.fontSizeFactor,
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 60,
                  height: 20,
                  child: LinearProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).alternate,
                  ),
                )
              else
                Text(
                  CurrencyService.formatFromUSD(balance),
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16 * FlutterFlowTheme.fontSizeFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
