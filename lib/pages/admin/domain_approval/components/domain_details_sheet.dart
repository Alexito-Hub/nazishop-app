import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:nazi_shop/models/domain.dart';

class DomainDetailsSheet extends StatelessWidget {
  final Domain domain;
  final Function(String) onUpdate;

  const DomainDetailsSheet({
    super.key,
    required this.domain,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: ListView(
          controller: controller,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Detalles del Domain',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            const SizedBox(height: 24),
            _DetailRow('Producto', domain.productSnapshot?.title ?? 'N/A'),
            _DetailRow('Email', domain.desiredCredentials.email),
            if (domain.desiredCredentials.password.isNotEmpty)
              _DetailRow('Password', domain.desiredCredentials.password),
            if (domain.desiredCredentials.notes.isNotEmpty)
              _DetailRow('Notas del Cliente', domain.desiredCredentials.notes),
            _DetailRow('Estado', _statusText(domain.status)),
            _DetailRow('Fecha',
                DateFormat('dd/MM/yyyy HH:mm').format(domain.createdAt)),
            if (domain.adminNotes != null)
              _DetailRow('Notas Admin', domain.adminNotes!),
            const SizedBox(height: 24),
            if (domain.status != 'completed')
              Column(
                children: [
                  _ActionButton(
                    label: 'Marcar como En Proceso',
                    color: FlutterFlowTheme.of(context).tertiary,
                    onTap: () => onUpdate('in_progress'),
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    label: 'Completar',
                    color: FlutterFlowTheme.of(context).success,
                    onTap: () => onUpdate('completed'),
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    label: 'Cancelar',
                    color: FlutterFlowTheme.of(context).error,
                    onTap: () => onUpdate('cancelled'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'in_progress':
        return 'En Proceso';
      case 'completed':
        return 'Completado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
