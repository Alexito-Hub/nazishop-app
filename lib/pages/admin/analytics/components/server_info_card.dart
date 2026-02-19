import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ServerInfoCard extends StatelessWidget {
  final Map<String, dynamic> serverStats;

  const ServerInfoCard({super.key, required this.serverStats});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Información del Servidor',
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
              _buildProgressRow(
                context,
                'CPU Load',
                (serverStats['cpu'] as num?)?.toDouble() ?? 0.0,
                theme.primary,
              ),
              const SizedBox(height: 16),
              if (serverStats['cpu_model'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CPU Model',
                          style:
                              GoogleFonts.outfit(color: theme.secondaryText)),
                      const SizedBox(height: 4),
                      Text(serverStats['cpu_model'],
                          style: GoogleFonts.outfit(
                              color: theme.primaryText, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              _buildProgressRow(
                context,
                'Memory Usage',
                (serverStats['memory'] as num?)?.toDouble() ?? 0.0,
                theme.tertiary,
              ),
              const SizedBox(height: 16),
              _buildProgressRow(
                context,
                'Disk Space',
                (serverStats['disk'] as num?)?.toDouble() ?? 0.0,
                theme.secondary,
              ),
              const SizedBox(height: 20),
              Divider(color: theme.alternate),
              const SizedBox(height: 16),
              if (serverStats['platform'] != null)
                Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('OS Platform',
                              style: GoogleFonts.outfit(
                                  color: theme.secondaryText)),
                          Text(serverStats['platform'],
                              style: GoogleFonts.outfit(
                                  color: theme.primaryText,
                                  fontWeight: FontWeight.bold))
                        ])),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Uptime',
                      style: GoogleFonts.outfit(color: theme.secondaryText)),
                  Text(serverStats['uptime'] ?? '-',
                      style: GoogleFonts.outfit(
                          color: theme.primaryText,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow(
      BuildContext context, String label, double value, Color color) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.outfit(color: theme.secondaryText)),
            Text('${value.toStringAsFixed(1)}%',
                style: GoogleFonts.outfit(
                    color: theme.primaryText, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: color.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
