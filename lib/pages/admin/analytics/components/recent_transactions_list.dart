import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<dynamic> transactions;

  const RecentTransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Últimos Movimientos',
            style: GoogleFonts.outfit(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.alternate),
            ),
            child: transactions.isNotEmpty
                ? Column(
                    children: List.generate(transactions.length, (index) {
                      final transaction = transactions[index];
                      // Handle both map (new backend) or strict model if we typed it
                      // Using dynamic access for now as recentTransactions is List<dynamic>
                      final amount =
                          (transaction['amount'] as num?)?.toDouble() ?? 0.0;
                      final isPositive = amount > 0;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                            backgroundColor:
                                theme.primary.withValues(alpha: 0.1),
                            child: Icon(
                                isPositive
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: theme.primary,
                                size: 18)),
                        title: Text(
                            transaction['description'] ??
                                transaction['type'] ??
                                'Transacción',
                            style:
                                GoogleFonts.outfit(color: theme.primaryText)),
                        subtitle: Text(
                            transaction['created_at'] != null
                                ? 'Fecha: ${transaction['created_at'].toString().split('T')[0]}'
                                : 'Reciente',
                            style:
                                GoogleFonts.outfit(color: theme.secondaryText)),
                        trailing: Text(
                            '${isPositive ? '+' : ''}\$${amount.toStringAsFixed(2)}',
                            style: GoogleFonts.outfit(
                                color: isPositive ? theme.success : theme.error,
                                fontWeight: FontWeight.bold)),
                      );
                    }),
                  )
                : Center(
                    child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('No hay movimientos recientes',
                        style: GoogleFonts.outfit(color: theme.secondaryText)),
                  ))),
      ],
    );
  }
}
