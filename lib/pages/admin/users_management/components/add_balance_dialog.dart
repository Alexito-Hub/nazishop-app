import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/components/app_dialog.dart';
import '/flutter_flow/custom_snackbar.dart';
import '/backend/admin_service.dart';
import '/models/user_model.dart';

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

    final theme = FlutterFlowTheme.of(context);
    return AppDialog(
      title: 'Cargar Saldo',
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add_card_rounded, color: theme.primary, size: 24),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Usuario: ${user.displayName}',
              style:
                  GoogleFonts.outfit(color: theme.secondaryText, fontSize: 13)),
          const SizedBox(height: 24.0),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.outfit(color: theme.primaryText),
            decoration: InputDecoration(
              labelText: 'Monto a cargar',
              labelStyle: GoogleFonts.outfit(color: theme.secondaryText),
              prefixText: '\$ ',
              prefixStyle: GoogleFonts.outfit(
                  color: theme.primary, fontWeight: FontWeight.bold),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.alternate)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.primary)),
              filled: true,
              fillColor: theme.secondaryBackground,
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: noteController,
            maxLines: 2,
            style: GoogleFonts.outfit(color: theme.primaryText),
            decoration: InputDecoration(
              labelText: 'Referencia / Nota',
              labelStyle: GoogleFonts.outfit(color: theme.secondaryText),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.alternate)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.primary)),
              filled: true,
              fillColor: theme.secondaryBackground,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar',
              style: GoogleFonts.outfit(color: theme.secondaryText)),
        ),
        const SizedBox(width: 8),
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
            backgroundColor: theme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(
            'Confirmar',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
