import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/components/safe_image.dart';

/// Handles image input: URL text field + file/gallery picker.
/// Shows a live preview once a URL or file is selected.
class SmartImageInput extends StatefulWidget {
  final String? initialUrl;
  final ValueChanged<String> onUrlChanged;
  final String label;

  const SmartImageInput({
    super.key,
    this.initialUrl,
    required this.onUrlChanged,
    this.label = 'IMAGEN',
  });

  @override
  State<SmartImageInput> createState() => _SmartImageInputState();
}

class _SmartImageInputState extends State<SmartImageInput> {
  late TextEditingController _urlController;
  late String _currentUrl;
  XFile? _pickedFile; // local file (non-web)
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl ?? '';
    _urlController = TextEditingController(text: _currentUrl);
  }

  @override
  void didUpdateWidget(SmartImageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialUrl != null &&
        widget.initialUrl != oldWidget.initialUrl &&
        _urlController.text != widget.initialUrl) {
      _urlController.text = widget.initialUrl!;
      setState(() {
        _currentUrl = widget.initialUrl!;
        _pickedFile = null;
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file != null) {
        setState(() {
          _pickedFile = file;
          _currentUrl = file.path; // local path for preview
          _urlController.text = file.path;
        });
        // Pass the path/name to the caller so it can upload to its backend.
        widget.onUrlChanged(file.path);
      }
    } catch (_) {
      // Swallow: user cancelled or permission denied.
    }
  }

  void _clearImage() {
    setState(() {
      _pickedFile = null;
      _currentUrl = '';
      _urlController.clear();
    });
    widget.onUrlChanged('');
  }

  bool get _hasContent => _currentUrl.isNotEmpty;
  bool get _isLocalFile =>
      _pickedFile != null && !_currentUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: GoogleFonts.outfit(
              color: theme.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Image preview / empty state
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: _hasContent ? _buildPreview(theme) : _buildDropZone(theme),
        ),

        const SizedBox(height: 10),

        // URL TextField
        TextFormField(
          controller: _urlController,
          style: GoogleFonts.outfit(color: theme.primaryText, fontSize: 14),
          cursorColor: theme.primary,
          decoration: InputDecoration(
            hintText: 'https://…',
            hintStyle: GoogleFonts.outfit(color: theme.secondaryText),
            prefixIcon: Icon(Icons.link, color: theme.secondaryText, size: 18),
            filled: true,
            fillColor: theme.primaryBackground,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.alternate),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.primary),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            isDense: true,
          ),
          onChanged: (val) {
            setState(() {
              _currentUrl = val;
              _pickedFile = null;
            });
            widget.onUrlChanged(val);
          },
        ),
      ],
    );
  }

  Widget _buildDropZone(FlutterFlowTheme theme) {
    return GestureDetector(
      onTap: _pickFromGallery,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.alternate,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                color: theme.secondaryText, size: 32),
            const SizedBox(height: 8),
            Text(
              kIsWeb ? 'Pegar URL o subir imagen' : 'Subir desde galería',
              style:
                  GoogleFonts.outfit(color: theme.secondaryText, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(FlutterFlowTheme theme) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 160,
            width: double.infinity,
            color: theme.primaryBackground,
            child: _isLocalFile && !kIsWeb
                ? Image.file(
                    File(_pickedFile!.path),
                    fit: BoxFit.cover,
                  )
                : SafeImage(
                    _currentUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 160,
                  ),
          ),
        ),
        // Top-right action row
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            children: [
              if (!kIsWeb)
                _iconChip(
                  icon: Icons.photo_library_outlined,
                  onTap: _pickFromGallery,
                ),
              const SizedBox(width: 6),
              _iconChip(
                icon: Icons.close,
                onTap: _clearImage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _iconChip({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
