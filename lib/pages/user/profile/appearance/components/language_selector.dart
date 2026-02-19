import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../flutter_flow/flutter_flow_theme.dart';

class LanguageSelector extends StatelessWidget {
  final bool isDesktop;
  final String currentLanguage;

  const LanguageSelector(
      {super.key, this.isDesktop = false, this.currentLanguage = 'Español'});

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: FlutterFlowTheme.of(context).alternate),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("🇪🇸  $currentLanguage",
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16)),
              const SizedBox(width: 8),
              Icon(Icons.arrow_drop_down,
                  color: FlutterFlowTheme.of(context).secondaryText),
            ],
          ),
        ),
      );
    } else {
      return _buildMobileTile(context);
    }
  }

  Widget _buildMobileTile(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final kPrimaryColor = theme.primary;
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration:
              BoxDecoration(color: theme.accent4, shape: BoxShape.circle),
          child: Icon(Icons.language, color: theme.secondaryText, size: 18),
        ),
        title:
            Text("Idioma", style: GoogleFonts.outfit(color: theme.primaryText)),
        subtitle: Text(currentLanguage,
            style: GoogleFonts.outfit(color: kPrimaryColor)),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            color: theme.secondaryText, size: 14),
        onTap: () {
          // Placeholder for language logic
        },
      ),
    );
  }
}
