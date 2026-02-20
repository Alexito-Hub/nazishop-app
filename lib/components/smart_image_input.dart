import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/components/safe_image.dart';

// Note: Actual file picking implementation might require additional packages like image_picker
// or file_picker. For now we structure the UI to support URL input and prepare for file picking hooks.

class SmartImageInput extends StatefulWidget {
  final String? initialUrl;
  final ValueChanged<String> onUrlChanged;
  final VoidCallback?
      onFilePick; // Callback for parent to handle file picking logic
  final String label;

  const SmartImageInput({
    super.key,
    this.initialUrl,
    required this.onUrlChanged,
    this.onFilePick,
    this.label = 'Imagen',
  });

  @override
  State<SmartImageInput> createState() => _SmartImageInputState();
}

class _SmartImageInputState extends State<SmartImageInput> {
  late TextEditingController _urlController;
  late String _currentUrl;
  bool _showPreview = true;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl ?? '';
    _urlController = TextEditingController(text: _currentUrl);
  }

  @override
  void didUpdateWidget(SmartImageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialUrl != oldWidget.initialUrl &&
        widget.initialUrl != null) {
      if (_urlController.text != widget.initialUrl) {
        _urlController.text = widget.initialUrl!;
        setState(() => _currentUrl = widget.initialUrl!);
      }
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.alternate),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Input Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _urlController,
                      style: GoogleFonts.outfit(color: theme.primaryText),
                      decoration: InputDecoration(
                        hintText: 'https://ejemplo.com/imagen.png',
                        hintStyle:
                            GoogleFonts.outfit(color: theme.secondaryText),
                        border: InputBorder.none,
                        isDense: true,
                        prefixIcon:
                            Icon(Icons.link, color: theme.secondaryText),
                      ),
                      onChanged: (val) {
                        setState(() => _currentUrl = val);
                        widget.onUrlChanged(val);
                      },
                    ),
                  ),
                  if (widget.onFilePick != null) ...[
                    Container(
                      height: 24,
                      width: 1,
                      color: theme.alternate,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    IconButton(
                        onPressed: widget.onFilePick,
                        tooltip: 'Subir archivo',
                        icon: Icon(Icons.upload_file_rounded,
                            color: theme.primary)),
                  ]
                ],
              ),

              if (_currentUrl.isNotEmpty && _showPreview) ...[
                const Divider(height: 24),
                // Preview Area
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: theme.alternate.withValues(alpha: 0.5)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: SafeImage(
                          _currentUrl,
                          fit: BoxFit.contain,
                        )),
                        // Clear button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: InkWell(
                            onTap: () {
                              _urlController.clear();
                              setState(() => _currentUrl = '');
                              widget.onUrlChanged('');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
