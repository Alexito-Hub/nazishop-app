import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class CurrencyHeader extends StatelessWidget {
  final VoidCallback onSave;

  const CurrencyHeader({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 30),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gestión de Divisas',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Define el valor de 1 USD en moneda local para pasarelas regionales',
                    style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: FlutterFlowTheme.of(context).secondaryText),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).primary,
                      FlutterFlowTheme.of(context).secondary
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    fixedSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.save_rounded,
                      color: Colors.white, size: 20),
                  label: Text(
                    'Guardar Cambios',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
