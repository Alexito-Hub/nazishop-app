import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/models/service_model.dart';
import '../../../../components/service_card.dart';

class OfferGrid extends StatelessWidget {
  final List<Service> products;
  final bool isDesktop;

  const OfferGrid({
    super.key,
    required this.products,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: isDesktop ? 80 : 60,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay ofertas disponibles',
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 2 : 1,
        childAspectRatio: isDesktop ? 3.5 : 4.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final service = products[index];
        return ServiceCard(
          service: service,
          isDesktop: isDesktop,
        );
      },
    );
  }
}
