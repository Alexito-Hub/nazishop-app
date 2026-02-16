import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_details_model.dart';
import '../../../components/smart_back_button.dart';
export 'order_details_model.dart';

class OrderDetailsWidget extends StatefulWidget {
  const OrderDetailsWidget({
    super.key,
    this.orderId,
    this.customer,
    this.product,
    this.amount,
    this.status,
    this.time,
  });

  final String? orderId;
  final String? customer;
  final String? product;
  final String? amount;
  final String? status;
  final String? time;

  static String routeName = 'order_details';
  static String routePath = '/orderDetails';

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  late OrderDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderDetailsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    switch (widget.status) {
      case 'pending':
        return FlutterFlowTheme.of(context).warning;
      case 'processing':
        return FlutterFlowTheme.of(context).primary;
      case 'completed':
        return FlutterFlowTheme.of(context).success;
      default:
        return FlutterFlowTheme.of(context).secondaryText;
    }
  }

  String _getStatusText() {
    switch (widget.status) {
      case 'pending':
        return 'Pendiente';
      case 'processing':
        return 'En Proceso';
      case 'completed':
        return 'Completado';
      default:
        return 'Desconocido';
    }
  }

  IconData _getStatusIcon() {
    switch (widget.status) {
      case 'pending':
        return Icons.pending;
      case 'processing':
        return Icons.autorenew;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusText = _getStatusText();
    final statusIcon = _getStatusIcon();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).tertiary,
          automaticallyImplyLeading: false,
          leading: const SmartBackButton(color: Colors.white),
          title: Text(
            'Detalles de Orden',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.inter(),
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                    'ID de Orden', widget.orderId ?? '#0000', Icons.tag),
                const Divider(height: 24.0),
                _buildInfoRow(
                    'Cliente', widget.customer ?? 'Desconocido', Icons.person),
                const Divider(height: 24.0),
                _buildInfoRow(
                    'Producto', widget.product ?? 'N/A', Icons.shopping_bag),
                const Divider(height: 24.0),
                _buildInfoRow(
                    'Monto', widget.amount ?? '\$0', Icons.attach_money),
                const Divider(height: 24.0),
                _buildInfoRow('Hora', widget.time ?? 'N/A', Icons.access_time),
                const SizedBox(height: 32.0),
                Text(
                  'Estado:',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText),
                ),
                const SizedBox(height: 12.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: statusColor, width: 2.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 28.0),
                      const SizedBox(width: 12.0),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.status != 'completed') ...[
                  const SizedBox(height: 24.0),
                  Text(
                    'Acciones disponibles:',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: FlutterFlowTheme.of(context).primaryText),
                  ),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: [
                      if (widget.status == 'pending')
                        _buildActionChip('Procesar', Icons.play_arrow,
                            FlutterFlowTheme.of(context).primary),
                      if (widget.status != 'completed')
                        _buildActionChip('Completar', Icons.check,
                            FlutterFlowTheme.of(context).success),
                      _buildActionChip('Cancelar', Icons.cancel,
                          FlutterFlowTheme.of(context).error),
                    ],
                  ),
                ],
                const SizedBox(height: 32.0),
                if (widget.status != 'completed')
                  FFButtonWidget(
                    onPressed: () {
                      CustomSnackBar.success(
                        context,
                        'La orden ha sido marcada como completada exitosamente',
                        title: 'Orden Completada',
                      );
                      context.pop();
                    },
                    text: 'Completar Orden',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      color: FlutterFlowTheme.of(context).success,
                      textStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                if (widget.status == 'completed')
                  FFButtonWidget(
                    onPressed: () => context.pop(),
                    text: 'Cerrar',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      color: FlutterFlowTheme.of(context).tertiary,
                      textStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24.0, color: FlutterFlowTheme.of(context).tertiary),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 12.0,
                    color: FlutterFlowTheme.of(context).secondaryText),
              ),
              const SizedBox(height: 4.0),
              Text(
                value,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: FlutterFlowTheme.of(context).primaryText),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.0, color: color),
          const SizedBox(width: 8.0),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
