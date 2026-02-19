import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:nazi_shop/models/domain.dart';

class DomainCard extends StatelessWidget {
  final Domain domain;
  final VoidCallback onTap;

  const DomainCard({
    super.key,
    required this.domain,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      domain.productSnapshot?.title ?? 'Domain Product',
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      domain.desiredCredentials.email,
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(context, domain.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _statusText(domain.status),
                  style: GoogleFonts.outfit(
                    color: _statusColor(context, domain.status),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('dd MMM yyyy HH:mm').format(domain.createdAt),
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Ver Detalles',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'pending':
        return FlutterFlowTheme.of(context).warning;
      case 'in_progress':
        return FlutterFlowTheme.of(context).tertiary;
      case 'completed':
        return FlutterFlowTheme.of(context).success;
      case 'cancelled':
        return FlutterFlowTheme.of(context).error;
      default:
        return FlutterFlowTheme.of(context).secondaryText;
    }
  }

  String _statusText(String status) {
    switch (status) {
      case 'pending':
        return 'PENDIENTE';
      case 'in_progress':
        return 'EN PROCESO';
      case 'completed':
        return 'COMPLETADO';
      case 'cancelled':
        return 'CANCELADO';
      default:
        return status.toUpperCase();
    }
  }
}
