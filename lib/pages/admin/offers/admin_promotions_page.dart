import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import '../admin_auth_guard.dart';
import '/backend/admin_service.dart';
import '/flutter_flow/custom_snackbar.dart';

class AdminPromotionsPage extends StatefulWidget {
  const AdminPromotionsPage({super.key});

  @override
  State<AdminPromotionsPage> createState() => _AdminPromotionsPageState();
}

class _AdminPromotionsPageState extends State<AdminPromotionsPage> {
  List<Map<String, dynamic>> _promotions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPromotions();
  }

  Future<void> _loadPromotions() async {
    setState(() => _isLoading = true);
    try {
      final data = await AdminService.getPromotions();
      if (mounted) {
        setState(() {
          _promotions = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        CustomSnackBar.error(context, 'Error al cargar promociones: $e');
      }
    }
  }

  Future<void> _editPromotion(Map<String, dynamic> promo) async {
    final titleController = TextEditingController(text: promo['title']);
    final descController = TextEditingController(text: promo['description']);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Promoción'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result == true && titleController.text.isNotEmpty) {
      try {
        await AdminService.updatePromotion({
          '_id': promo['id'] ?? promo['_id'],
          'title': titleController.text,
          'description': descController.text,
        });
        _loadPromotions();
        if (mounted) {
          CustomSnackBar.success(context, 'Promoción actualizada');
        }
      } catch (e) {
        if (mounted) {
          CustomSnackBar.error(context, 'Error al actualizar: $e');
        }
      }
    }
  }

  Future<void> _createPromotion() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Promoción'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (result == true && titleController.text.isNotEmpty) {
      try {
        await AdminService.createPromotion({
          'title': titleController.text,
          'description': descController.text,
          'isActive': true,
        });
        _loadPromotions();
        if (mounted) {
          CustomSnackBar.success(context, 'Promoción creada');
        }
      } catch (e) {
        if (mounted) {
          CustomSnackBar.error(context, 'Error al crear: $e');
        }
      }
    }
  }

  Future<void> _deletePromotion(String id) async {
    try {
      await AdminService.deletePromotion(id);
      _loadPromotions();
      if (mounted) {
        CustomSnackBar.success(context, 'Promoción eliminada');
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.error(context, 'Error al eliminar: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminAuthGuard(
      title: 'Gestión de Promociones',
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            // Fondo degradado sutil global
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: FlutterFlowTheme.of(context)
                      .primary
                      .withValues(alpha: 0.05),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Promociones y Ofertas',
                              style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Crea paquetes, descuentos por tiempo limitado y promociones sobre Listings existentes.',
                              style: GoogleFonts.readexPro(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _createPromotion,
                        icon: const Icon(Icons.add),
                        label: const Text('Nueva Promoción'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                          foregroundColor: FlutterFlowTheme.of(context).info,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _promotions.isEmpty
                            ? Center(
                                child: Text(
                                  'No hay promociones aún',
                                  style: GoogleFonts.outfit(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _promotions.length,
                                itemBuilder: (context, index) {
                                  final promo = _promotions[index];
                                  return Card(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: ListTile(
                                      title: Text(
                                        promo['title'] ?? 'Sin título',
                                        style: GoogleFonts.outfit(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        promo['description'] ??
                                            'Sin descripción',
                                        style: GoogleFonts.outfit(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () =>
                                                _editPromotion(promo),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () => _deletePromotion(
                                                promo['id'] ?? promo['_id']),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
