import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/components/app_product_card.dart';

class PurchaseCard extends StatefulWidget {
  final Map<String, dynamic> order;
  const PurchaseCard({super.key, required this.order});

  @override
  State<PurchaseCard> createState() => _PurchaseCardState();
}

class _PurchaseCardState extends State<PurchaseCard> {
  @override
  Widget build(BuildContext context) {
    final status = widget.order['status']?.toLowerCase() ?? '';
    final serviceName = widget.order['serviceName'] ?? 'Servicio';
    final price = (widget.order['totalAmount'] ?? 0.0).toDouble();
    final rawOrderId = widget.order['_id']?.toString() ?? '';
    final dateStr = widget.order['createdAt'];
    final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
    final formattedDate = date != null ? DateFormat('dd MMM').format(date) : '';

    // Extract logo from order items
    final items = widget.order['items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty ? items[0] : null;
    final listingSnapshot = firstItem?['listingSnapshot'];
    final branding = listingSnapshot?['branding'];
    final logoUrl = branding?['logoUrl'];

    // Primary color from branding
    final String? colorString = branding?['primaryColor'];
    Color primaryColor = FlutterFlowTheme.of(context).primary;
    if (colorString != null) {
      try {
        String hex = colorString.replaceAll('#', '');
        if (hex.length == 6) hex = 'FF$hex';
        primaryColor = Color(int.parse(hex, radix: 16));
      } catch (_) {}
    }

    // Status Config
    final theme = FlutterFlowTheme.of(context);
    Color statusColor;
    String statusText;
    IconData statusIcon;
    switch (status) {
      case 'paid':
      case 'completed':
        statusColor = theme.success;
        statusText = 'COMPLETADO';
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = theme.warning;
        statusText = 'PENDIENTE';
        statusIcon = Icons.access_time_filled;
        break;
      default:
        statusColor = theme.error;
        statusText = 'CANCELADO';
        statusIcon = Icons.cancel;
    }

    // Mock rating for consistency with original design
    final hash = rawOrderId.hashCode.abs();
    final rating = 4.5 + ((hash % 5) / 10);

    return AppProductCard(
      variant: AppProductCardVariant.purchase,
      title: serviceName,
      imageUrl: logoUrl,
      price: price,
      primaryColor: primaryColor,
      statusText: statusText,
      statusColor: statusColor,
      statusIcon: statusIcon,
      subtitle: 'ID: $rawOrderId',
      dateText: formattedDate,
      rating: rating,
      onTap: () {
        if (status == 'paid' || status == 'completed') {
          context.pushNamed(
            'view_credentials',
            queryParameters: {'orderId': rawOrderId},
          );
        }
      },
    );
  }
}
