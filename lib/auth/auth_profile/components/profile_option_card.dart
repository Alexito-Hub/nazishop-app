import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ProfileOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileOptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 60.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: const [
              BoxShadow(
                blurRadius: 3.0,
                color: Color(0x33000000),
                offset: Offset(0.0, 1.0),
              )
            ],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  icon,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                  child: Text(
                    title,
                    style: FlutterFlowTheme.of(context).labelLarge.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelLarge
                                .fontWeight,
                          ),
                        ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: const AlignmentDirectional(0.9, 0.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
