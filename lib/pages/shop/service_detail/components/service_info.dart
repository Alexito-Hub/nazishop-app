import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../models/service_model.dart';
import '../../../../models/offer_model.dart';

class ServiceInfo extends StatelessWidget {
  final Service service;
  final List<DisplayTag> tags;

  const ServiceInfo({
    super.key,
    required this.service,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tags
        if (tags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) => _buildTag(context, tag)).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Description
        if (service.description.isNotEmpty) ...[
          Text(
            'Sobre el servicio',
            style: GoogleFonts.outfit(
              fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            service.description,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 15 * FlutterFlowTheme.fontSizeFactor,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
        ],

        // Technical Info
        if (service.technicalInfo != null) ...[
          _TechnicalSpecsWidget(info: service.technicalInfo!),
          const SizedBox(height: 32),
        ],

        // Features
        if (service.features?.isNotEmpty ?? false) ...[
          Text(
            'Características',
            style: GoogleFonts.outfit(
              fontSize: 18 * FlutterFlowTheme.fontSizeFactor,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: service.features!
                .map((f) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .alternate
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate),
                      ),
                      child: Text(f,
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 13 * FlutterFlowTheme.fontSizeFactor)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 32),
        ],
      ],
    );
  }

  Widget _buildTag(BuildContext context, DisplayTag tag) {
    final color =
        _parseColor(tag.color) ?? FlutterFlowTheme.of(context).primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        tag.text ?? '',
        style: GoogleFonts.outfit(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return null;
    }
  }
}

class _TechnicalSpecsWidget extends StatelessWidget {
  final ServiceTechnicalInfo info;
  const _TechnicalSpecsWidget({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline,
                  size: 18, color: FlutterFlowTheme.of(context).primary),
              const SizedBox(width: 8),
              Text(
                "Especificaciones Técnicas",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (info.platform != null)
            _buildRow(context, "Plataforma", info.platform!),
          if (info.website != null)
            _buildRow(context, "Website", info.website!),
          _buildRow(context, "Región", info.region),
          if (info.deviceLimit != null)
            _buildRow(context, "Dispositivos", info.deviceLimit.toString()),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText)),
          Text(value,
              style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primaryText)),
        ],
      ),
    );
  }
}
