import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/models/listing_model.dart';

class DeliveryInfoCard extends StatelessWidget {
  final Listing selectedListing;

  const DeliveryInfoCard({super.key, required this.selectedListing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline,
                  color: FlutterFlowTheme.of(context).secondaryText, size: 20),
              const SizedBox(width: 8),
              Text('Información de entrega',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16 * FlutterFlowTheme.fontSizeFactor,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            selectedListing.delivery?.type == 'full_account'
                ? 'Recibirás un correo electrónico con las credenciales de acceso (usuario y contraseña) inmediatamente después del pago.'
                : selectedListing.delivery?.type == 'profile_access'
                    ? 'Recibirás los datos de acceso a tu perfil asignado. Es importante respetar el perfil asignado.'
                    : selectedListing.delivery?.type == 'domain'
                        ? (selectedListing.delivery?.domainType == 'own_domain'
                            ? 'Se solicitarán las credenciales de tu dominio al finalizar la compra para realizar la activación.'
                            : 'Recibirás una cuenta con el producto activado lista para usar.')
                        : 'Recibirás tu código de licencia inmediatamente en tu correo y en el historial de compras.',
            style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 13 * FlutterFlowTheme.fontSizeFactor,
                height: 1.5),
          ),
        ],
      ),
    );
  }
}
