import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class DeviceSessionCard extends StatelessWidget {
  final Map<String, dynamic> session;
  final VoidCallback? onRevoke;

  const DeviceSessionCard({
    super.key,
    required this.session,
    this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bool isCurrent = session['isCurrent'] ?? false;
    final String deviceType = session['deviceType'] ?? 'web';
    final String deviceName = session['deviceName'] ?? 'Unknown Device';
    final String os = session['os'] ?? 'Unknown OS';
    final String ipAddress = session['ipAddress'] ?? 'Unknown IP';
    // final String lastActive = session['lastActive'] ?? 'Now'; // Assuming this might be available later

    IconData deviceIcon = Icons.language_rounded;
    if (deviceType == 'mobile') deviceIcon = Icons.smartphone_rounded;
    if (deviceType == 'desktop') deviceIcon = Icons.laptop_rounded;
    if (deviceType == 'tablet') deviceIcon = Icons.tablet_mac_rounded;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent ? theme.primary : theme.alternate,
          width: isCurrent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCurrent
                  ? theme.primary.withValues(alpha: 0.1)
                  : theme.alternate.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              deviceIcon,
              color: isCurrent ? theme.primary : theme.secondaryText,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      deviceName,
                      style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: theme.primary.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          'ACTUAL',
                          style: GoogleFonts.outfit(
                            color: theme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$os • $ipAddress',
                  style: GoogleFonts.outfit(
                    color: theme.secondaryText,
                    fontSize: 13,
                  ),
                ),
                // if (!isCurrent)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 4),
                //     child: Text(
                //       'Last active: $lastActive',
                //       style: GoogleFonts.outfit(
                //         color: theme.secondaryText,
                //         fontSize: 12,
                //         fontStyle: FontStyle.italic,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
          if (!isCurrent && onRevoke != null)
            IconButton(
              onPressed: onRevoke,
              icon: Icon(Icons.delete_outline_rounded, color: theme.error),
              tooltip: 'Cerrar sesión',
              style: IconButton.styleFrom(
                backgroundColor: theme.error.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
