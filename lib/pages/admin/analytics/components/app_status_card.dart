import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AppStatusCard extends StatelessWidget {
  final Map<String, dynamic> serverStats;

  const AppStatusCard({super.key, required this.serverStats});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Estado de la Aplicación',
            style: GoogleFonts.outfit(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.alternate),
          ),
          child: Column(
            children: [
              _buildStatusRow(
                  context, 'Version', serverStats['version'] ?? '1.0.0'),
              _buildStatusRow(
                  context, 'Node Version', serverStats['node_version'] ?? '-'),
              _buildStatusRow(context, 'Environment',
                  serverStats['environment'] ?? 'Production'),
              _buildStatusRow(
                  context, 'Database', serverStats['database'] ?? 'Connected',
                  isStatus: true, isOk: serverStats['database'] == 'Connected'),
              _buildStatusRow(
                  context, 'API Status', serverStats['status'] ?? 'Online',
                  isStatus: true, isOk: serverStats['status'] == 'Online'),
              _buildStatusRow(
                  context, 'Last Backup', serverStats['last_backup'] ?? '-'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context, String label, String value,
      {bool isStatus = false, bool isOk = true}) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(color: theme.secondaryText)),
          isStatus
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOk
                        ? theme.success.withValues(alpha: 0.1)
                        : theme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: isOk ? theme.success : theme.error),
                  ),
                  child: Text(value,
                      style: GoogleFonts.outfit(
                          color: isOk ? theme.success : theme.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                )
              : Text(value,
                  style: GoogleFonts.outfit(
                      color: theme.primaryText, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
