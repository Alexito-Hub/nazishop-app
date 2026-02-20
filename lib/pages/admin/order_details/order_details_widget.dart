import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_details_model.dart';
import '/components/design_system.dart';
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
    final theme = FlutterFlowTheme.of(context);
    switch (widget.status) {
      case 'pending':
        return theme.warning;
      case 'processing':
        return theme.primary;
      case 'completed':
        return theme.success;
      default:
        return theme.secondaryText;
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
    final theme = FlutterFlowTheme.of(context);
    final statusColor = _getStatusColor();
    final statusText = _getStatusText();
    final statusIcon = _getStatusIcon();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const DSMobileAppBar(title: 'Detalles de Orden'),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                        'ID de Orden', widget.orderId ?? '#0000', Icons.tag),
                    const Divider(height: 24.0),
                    _buildInfoRow('Cliente', widget.customer ?? 'Desconocido',
                        Icons.person),
                    const Divider(height: 24.0),
                    _buildInfoRow('Producto', widget.product ?? 'N/A',
                        Icons.shopping_bag),
                    const Divider(height: 24.0),
                    _buildInfoRow(
                        'Monto', widget.amount ?? '\$0', Icons.attach_money),
                    const Divider(height: 24.0),
                    _buildInfoRow(
                        'Hora', widget.time ?? 'N/A', Icons.access_time),
                    const SizedBox(height: 32.0),
                    Text(
                      'Estado:',
                      style: GoogleFonts.outfit(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryText,
                      ),
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
                            style: GoogleFonts.outfit(
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
                        style: GoogleFonts.outfit(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children: [
                          if (widget.status == 'pending')
                            _buildActionChip(
                                'Procesar', Icons.play_arrow, theme.primary),
                          if (widget.status != 'completed')
                            _buildActionChip(
                                'Completar', Icons.check, theme.success),
                          _buildActionChip(
                              'Cancelar', Icons.cancel, theme.error),
                        ],
                      ),
                    ],
                    const SizedBox(height: 32.0),
                    if (widget.status != 'completed')
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'La orden ha sido marcada como completada exitosamente'),
                                backgroundColor: theme.success,
                              ),
                            );
                            context.pop();
                          },
                          icon: Icon(Icons.check_circle_outline,
                              color: theme.tertiary),
                          label: Text(
                            'Completar Orden',
                            style: GoogleFonts.outfit(
                              color: theme.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.success,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    if (widget.status == 'completed')
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => context.pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Text(
                            'Cerrar',
                            style: GoogleFonts.outfit(
                              color: theme.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      children: [
        Icon(icon, size: 24.0, color: theme.primary),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12.0,
                  color: theme.secondaryText,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryText,
                ),
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
            style: GoogleFonts.outfit(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
