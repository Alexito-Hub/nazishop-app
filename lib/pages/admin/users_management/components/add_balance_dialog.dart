import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/custom_snackbar.dart';
import '/backend/admin_service.dart';
import 'package:nazi_shop/models/user_model.dart';

class AddBalanceDialog extends StatelessWidget {
  final User user;
  final VoidCallback onUpdate;

  const AddBalanceDialog({
    super.key,
    required this.user,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    return AlertDialog(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text('Cargar Saldo',
          style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Usuario: ${user.displayName}',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 13)),
          const SizedBox(height: 24.0),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText),
            decoration: InputDecoration(
              labelText: 'Monto a cargar',
              labelStyle: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText),
              prefixText: '\$ ',
              prefixStyle: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primary,
                  fontWeight: FontWeight.bold),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: FlutterFlowTheme.of(context).primary)),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: noteController,
            maxLines: 2,
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText),
            decoration: InputDecoration(
              labelText: 'Referencia / Nota',
              labelStyle: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: FlutterFlowTheme.of(context).primary)),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText)),
        ),
        ElevatedButton(
          onPressed: () async {
            final amount = double.tryParse(amountController.text);
            if (amount != null && amount > 0) {
              Navigator.pop(context);
              final success = await AdminService.addUserBalance(
                user.id,
                amount,
                noteController.text.isEmpty ? null : noteController.text,
              );

              if (success) {
                onUpdate();
                if (context.mounted) {
                  CustomSnackBar.success(context, 'Saldo acreditado');
                }
              } else {
                if (context.mounted) {
                  CustomSnackBar.error(context, 'Error al cargar saldo');
                }
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
