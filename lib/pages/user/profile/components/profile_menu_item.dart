import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final bool isDesktop;
  final bool isHighlight;
  final Color? color;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.isDesktop = false,
    this.isHighlight = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return _buildDesktop(context);
    }
    return _buildMobile(context);
  }

  Widget _buildMobile(BuildContext context) {
    return ListTile(
      onTap: isSwitch ? null : onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color?.withValues(alpha: 0.1) ??
              FlutterFlowTheme.of(context).accent1,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color ?? FlutterFlowTheme.of(context).primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: FlutterFlowTheme.of(context)
            .bodyLarge
            .override(fontWeight: FontWeight.w500),
      ),
      trailing: isSwitch
          ? Switch.adaptive(
              value: switchValue,
              onChanged: onSwitchChanged,
              activeThumbColor: FlutterFlowTheme.of(context).primary,
              activeTrackColor:
                  FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
            )
          : Icon(
              Icons.chevron_right,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20,
            ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: isHighlight
            ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1)
            : FlutterFlowTheme.of(context)
                .secondaryBackground
                .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlight
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context)
                  .secondaryBackground
                  .withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: FlutterFlowTheme.of(context).transparent,
        child: InkWell(
          onTap: isSwitch ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          hoverColor: FlutterFlowTheme.of(context)
              .secondaryBackground
              .withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isHighlight
                        ? FlutterFlowTheme.of(context)
                            .primary
                            .withValues(alpha: 0.1)
                        : FlutterFlowTheme.of(context)
                            .secondaryBackground
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isHighlight
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryText,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          color: isHighlight
                              ? FlutterFlowTheme.of(context).primaryText
                              : FlutterFlowTheme.of(context)
                                  .secondaryText
                                  .withValues(alpha: 0.1),
                          fontWeight:
                              isHighlight ? FontWeight.bold : FontWeight.w500,
                          font: GoogleFonts.outfit(),
                        ),
                  ),
                ),
                if (isSwitch)
                  Switch(
                    value: switchValue,
                    onChanged: onSwitchChanged,
                    activeThumbColor: FlutterFlowTheme.of(context).primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
