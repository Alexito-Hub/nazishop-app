import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AllProductsWidget extends StatefulWidget {
  const AllProductsWidget({super.key});

  @override
  State<AllProductsWidget> createState() => _AllProductsWidgetState();
}

class _AllProductsWidgetState extends State<AllProductsWidget> {
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
