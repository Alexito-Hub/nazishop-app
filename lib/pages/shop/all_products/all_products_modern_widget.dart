import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AllProductsModernWidget extends StatefulWidget {
  const AllProductsModernWidget({super.key});

  @override
  State<AllProductsModernWidget> createState() =>
      _AllProductsModernWidgetState();
}

class _AllProductsModernWidgetState extends State<AllProductsModernWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Text(
                  'Todos los Productos',
                  style: FlutterFlowTheme.of(context).headlineMedium,
                ),
              ),
              // Lista de productos
            ],
          ),
        ),
      ),
    );
  }
}
