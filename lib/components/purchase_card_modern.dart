import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import '../backend/currency_service.dart';
import '../backend/icon_helper.dart';

class PurchaseCardModern extends StatefulWidget {
  final Map<String, dynamic> order;

  const PurchaseCardModern({
    super.key,
    required this.order,
  });

  @override
  State<PurchaseCardModern> createState() => _PurchaseCardModernState();
}

class _PurchaseCardModernState extends State<PurchaseCardModern> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // 1. Data Parsing
    final order = widget.order;
    final status = order['status'] ?? 'pending';
    final product = order['product'] ?? {};
    final serviceName = product['name'] ?? 'Producto Desconocido';
    final totalPrice =
        double.tryParse(order['totalPrice']?.toString() ?? '0') ?? 0;
    final price = CurrencyService.formatFromUSD(totalPrice);

    // Status Logic
    String statusText = 'Pendiente';
    Color statusColor = const Color(0xFFFF5963); // Red/Orange
    IconData statusIcon = Icons.access_time_rounded;

    if (status == 'delivered') {
      statusText = 'Entregado';
      statusColor = const Color(0xFF39D2C0); // Cyan/Green
      statusIcon = Icons.check_circle_rounded;
    } else if (status == 'paid') {
      statusText = 'Pagado';
      statusColor = const Color(0xFF4B39EF); // Blue
      statusIcon = Icons.payment_rounded;
    } else if (status == 'cancelled') {
      statusText = 'Cancelado';
      statusColor = Colors.grey;
      statusIcon = Icons.cancel_rounded;
    }

    // Icon & Branding
    final iconCode = product['iconCode'];
    final colorVal = product['colorValue'];
    final brandColor =
        colorVal != null ? Color(colorVal) : const Color(0xFFE50914);
    final icon = iconCode != null
        ? IconHelper.getIcon(iconCode)
        : Icons.shopping_bag_outlined;

    // Actions
    final deliveredCodes = order['deliveredCodes'] as List?;
    final hasCodes = deliveredCodes != null && deliveredCodes.isNotEmpty;

    // Hover Border Color
    final borderColor = _isHovered
        ? brandColor.withOpacity(0.5)
        : Colors.white.withOpacity(0.08);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Navegar al detalle si es necesario, o expandir
          // Por ahora no hace nada o podría ir a un "OrderDetail"
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 16),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -4.0 : 0.0),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: brandColor.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                // Fondo decorativo sutil
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    icon,
                    size: 150,
                    color: brandColor.withOpacity(0.03),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Header Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon Box
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  brandColor.withOpacity(0.2),
                                  brandColor.withOpacity(0.05)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: brandColor.withOpacity(0.2)),
                            ),
                            child: Icon(icon, color: brandColor, size: 28),
                          ),
                          const SizedBox(width: 20),

                          // Info
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
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Orden #${order['orderId'] ?? order['id']?.toString().substring(0, 8) ?? '...'}',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white38,
                                    fontSize: 12,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: statusColor.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon, size: 14, color: statusColor),
                                const SizedBox(width: 6),
                                Text(
                                  statusText.toUpperCase(),
                                  style: GoogleFonts.outfit(
                                    color: statusColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      Divider(color: Colors.white.withOpacity(0.05), height: 1),
                      const SizedBox(height: 24),

                      // Footer Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFooterItem(
                              'FECHA', _formatDate(order['createdAt'])),
                          _buildFooterItem('TOTAL', price,
                              isValueBold: true, valueColor: Colors.white),

                          const Spacer(),

                          // Actions
                          if (hasCodes)
                            _buildActionButton(context,
                                label: 'VER CÓDIGO',
                                icon: Icons.qr_code_rounded,
                                color: brandColor, onTap: () {
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
                            })
                          else if (status == 'paid')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white54)),
                                  const SizedBox(width: 10),
                                  Text("Procesando...",
                                      style: GoogleFonts.outfit(
                                          color: Colors.white54, fontSize: 12))
                                ],
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterItem(String label, String value,
      {bool isValueBold = false, Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: valueColor ?? Colors.white70,
            fontSize: 14,
            fontWeight: isValueBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2), // Gradient bg could be better
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: color, // Make text same color as button
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr.toString());
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr.toString();
    }
  }
}
