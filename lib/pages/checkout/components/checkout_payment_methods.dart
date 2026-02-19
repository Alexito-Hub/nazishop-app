import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class PaymentMethodItem {
  final String name;
  final IconData icon;
  final Color color;
  final bool isAvailable;

  PaymentMethodItem(this.name, this.icon, this.color, this.isAvailable);
}

class CheckoutPaymentMethods extends StatelessWidget {
  final List<PaymentMethodItem> methods;
  final int selectedIndex;
  final Function(int) onSelect;
  final bool showTitle;

  const CheckoutPaymentMethods({
    super.key,
    required this.methods,
    required this.selectedIndex,
    required this.onSelect,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text(
            'Método de pago',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
        ],
        ...List.generate(methods.length, (index) {
          final method = methods[index];
          final isSelected = selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: method.isAvailable ? () => onSelect(index) : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? FlutterFlowTheme.of(context).primary.withOpacity(0.05)
                      : FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).alternate,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: method.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(method.icon, color: method.color, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method.name,
                            style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 16 * FlutterFlowTheme.fontSizeFactor,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          if (!method.isAvailable)
                            Text(
                              'Próximamente',
                              style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 12 * FlutterFlowTheme.fontSizeFactor,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 24,
                      )
                    else
                      Icon(
                        Icons.circle_outlined,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
