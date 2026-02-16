import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../backend/icon_helper.dart';
import '../../../backend/currency_service.dart';
import 'package:go_router/go_router.dart';

class PurchaseCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const PurchaseCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status & styling
    final status = order['status'] ?? 'pending';
    final isDelivered = status == 'delivered';
    final isPaid = status == 'paid';

    // Status Display
    String statusText = 'Pendiente';
    Color statusColor = const Color(0xFFFF5963);
    if (isDelivered) {
      statusText = 'Entregado';
      statusColor = const Color(0xFF39D2C0);
    } else if (isPaid) {
      statusText = 'Pagado';
      statusColor = const Color(0xFF4B39EF);
    } else if (status == 'cancelled') {
      statusText = 'Cancelado';
      statusColor = Colors.grey;
    }

    // Product Data
    final product = order['product'] ?? {};
    final serviceName = product['name'] ?? 'Producto desconocida';
    final totalPrice =
        double.tryParse(order['totalPrice']?.toString() ?? '0') ?? 0;
    final price = CurrencyService.formatFromUSD(totalPrice);
    final createdAt = _formatDate(order['createdAt'] ?? '');

    // Icon & Color
    final iconCode = product['iconCode'];
    final colorVal = product['colorValue'];
    final color = colorVal != null
        ? Color(colorVal)
        : FlutterFlowTheme.of(context).primary;
    final icon =
        iconCode != null ? IconHelper.getIcon(iconCode) : Icons.shopping_bag;

    // Delivery Check
    final deliveredCodes = order['deliveredCodes'] as List?;
    final hasCodes = deliveredCodes != null && deliveredCodes.isNotEmpty;

    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.alternate,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: FlutterFlowTheme.of(context).transparent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52.0,
                      height: 52.0,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(
                          color: color.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 26.0,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceName,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Orden #${order['orderId'] ?? order['id'] ?? '...'}',
                            style: GoogleFonts.outfit(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        statusText.toUpperCase(),
                        style: GoogleFonts.outfit(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: theme.alternate,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FECHA',
                          style: GoogleFonts.outfit(
                            color: theme.secondaryText,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          createdAt,
                          style: GoogleFonts.outfit(
                            color: theme.primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'TOTAL',
                          style: GoogleFonts.outfit(
                            color: theme.secondaryText,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          price,
                          style: GoogleFonts.outfit(
                            color: theme.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (hasCodes || (isPaid && !isDelivered)) ...[
                  const SizedBox(height: 24.0),
                  if (hasCodes)
                    Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            FlutterFlowTheme.of(context).primary,
                            FlutterFlowTheme.of(context)
                                .primary
                                .withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final codeObj = deliveredCodes[0];
                          final code = codeObj['code'] ?? 'CODE-ERROR';
                          context.pushNamed(
                            'view_gift_code',
                            queryParameters: {
                              'serviceName': serviceName,
                              'code': code.toString(),
                              'instructions':
                                  'Copia este código y canjéalo en el sitio oficial.',
                            },
                          );
                        },
                        icon: const Icon(Icons.qr_code_rounded, size: 20),
                        label: Text(
                          'VER CÓDIGO',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              FlutterFlowTheme.of(context).transparent,
                          foregroundColor: Colors.white,
                          shadowColor: FlutterFlowTheme.of(context).transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    )
                  else if (isPaid && !isDelivered)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.orangeAccent.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'PROCESANDO ENTREGA...',
                            style: GoogleFonts.outfit(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return months[month - 1];
  }
}
