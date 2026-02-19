import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/safe_image.dart';
import '/models/service_model.dart';
import '/utils/color_utils.dart';
import '/backend/currency_service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final bool isDesktop;
  final Color? primaryColor;

  const ServiceCard({
    super.key,
    required this.service,
    this.isDesktop = false,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Use passed color or parse from service
    final cardColor = primaryColor ??
        ColorUtils.parseColor(context, service.branding.primaryColor);

    // Calculate prices
    final currentPrice = service.price;
    // Simulate original price for visual effect (30% higher)
    final originalPrice = currentPrice * 1.3;

    final priceStr = CurrencyService.formatFromUSD(currentPrice);
    final originalPriceStr = CurrencyService.formatFromUSD(originalPrice);

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'service_detail',
            extra: {'service': service},
            queryParameters: {
              'serviceId': service.id,
            },
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: isDesktop ? 56 : 48,
                        height: isDesktop ? 56 : 48,
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.alternate),
                        ),
                        child: service.branding.logoUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SafeImage(service.branding.logoUrl!,
                                    fit: BoxFit.cover),
                              )
                            : Icon(Icons.rocket_launch, color: cardColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.name,
                              style: TextStyle(
                                fontSize: isDesktop ? 20 : 18,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryText,
                              ),
                            ),
                            if (service.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                service.description,
                                style: TextStyle(
                                  fontSize: isDesktop ? 14 : 12,
                                  color: theme.secondaryText,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        originalPriceStr,
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 14,
                          color: theme.secondaryText,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        priceStr,
                        style: TextStyle(
                          fontSize: isDesktop ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: cardColor,
                        ),
                      ),
                      const Spacer(),
                      FlutterFlowIconButton(
                        borderColor: cardColor,
                        borderRadius: 12.0,
                        borderWidth: 2.0,
                        buttonSize: 44.0,
                        icon: Icon(
                          Icons.arrow_forward,
                          color: cardColor,
                          size: 20.0,
                        ),
                        onPressed: () {
                          context.pushNamed(
                            'service_detail',
                            extra: {'service': service},
                            queryParameters: {
                              'serviceId': service.id,
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // "Discount" Badge
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '30% OFF',
                  style: TextStyle(
                    color: theme.tertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
