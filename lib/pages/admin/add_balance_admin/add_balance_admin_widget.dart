import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/smart_back_button.dart';
import 'add_balance_admin_model.dart';
export 'add_balance_admin_model.dart';

class AddBalanceAdminWidget extends StatefulWidget {
  const AddBalanceAdminWidget({super.key});

  static String routeName = 'add_balance_admin';
  static String routePath = '/addBalanceAdmin';

  @override
  State<AddBalanceAdminWidget> createState() => _AddBalanceAdminWidgetState();
}

class _AddBalanceAdminWidgetState extends State<AddBalanceAdminWidget> {
  late AddBalanceAdminModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddBalanceAdminModel());
    _model.searchController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();
    _model.amountController ??= TextEditingController();
    _model.amountFocusNode ??= FocusNode();
    _model.noteController ??= TextEditingController();
    _model.noteFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            // Background Elements
            Positioned(
              top: -100,
              right: -100,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 1100) {
                  return _buildDesktopLayout();
                } else {
                  return _buildMobileLayout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          expandedHeight: 120,
          pinned: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context)
                    .primaryBackground
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SmartBackButton(
                  color: FlutterFlowTheme.of(context).primaryText),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: FlutterFlowTheme.of(context).primaryBackground.withValues(
                  alpha:
                      0.2), // Simple overlay instead of blur if needed or Glass effect
            ),
            title: Text(
              'Agregar Saldo',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildUserSearch(),
                const SizedBox(height: 24),
                if (_model.selectedUser != null) ...[
                  _buildAmountInput(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
                const SizedBox(height: 40),
                _buildHistoryList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar placeholder (assuming distinct nav on desktop)
        Container(
          width: 250,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context)
                .primaryBackground
                .withValues(alpha: 0.3),
            border: Border(
                right: BorderSide(
                    color: FlutterFlowTheme.of(context)
                        .primaryText
                        .withValues(alpha: 0.1))),
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildUserSearch(),
                            const SizedBox(height: 24),
                            if (_model.selectedUser != null) ...[
                              _buildAmountInput(),
                              const SizedBox(height: 24),
                              _buildActionButtons(),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .primaryText
                                .withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .primaryText
                                    .withValues(alpha: 0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Últimas Recargas',
                                style: GoogleFonts.outfit(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: _buildHistoryList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agregar Saldo',
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Gestiona recargas manuales para usuarios',
          style: GoogleFonts.outfit(
            color: FlutterFlowTheme.of(context).secondaryText,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _buildUserSearch() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryText.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: FlutterFlowTheme.of(context)
                .primaryText
                .withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buscar Usuario',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _model.searchController,
            focusNode: _model.searchFocusNode,
            style: TextStyle(color: FlutterFlowTheme.of(context).primaryText),
            decoration: InputDecoration(
              labelText: 'Email o ID del usuario',
              labelStyle:
                  TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
              prefixIcon: Icon(Icons.search,
                  color: FlutterFlowTheme.of(context).primary),
              filled: true,
              fillColor: FlutterFlowTheme.of(context)
                  .primaryBackground
                  .withValues(alpha: 0.3),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context)
                        .primaryText
                        .withValues(alpha: 0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: FlutterFlowTheme.of(context).primary),
              ),
            ),
            onFieldSubmitted: (val) async {
              // Mock search Logic
              setState(() {
                // Simulate user found
                _model.selectedUser = 'User Found: $val';
              });
            },
          ),
          if (_model.selectedUser != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context)
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: FlutterFlowTheme.of(context).primary),
                    const SizedBox(width: 12),
                    Text(
                      _model.selectedUser ?? '',
                      style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryText.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: FlutterFlowTheme.of(context)
                .primaryText
                .withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalles de la Recarga',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _model.amountController,
            focusNode: _model.amountFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(color: FlutterFlowTheme.of(context).primaryText),
            decoration: InputDecoration(
              labelText: 'Monto a recargar',
              labelStyle:
                  TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
              prefixIcon: Icon(Icons.attach_money,
                  color: FlutterFlowTheme.of(context).success),
              filled: true,
              fillColor: FlutterFlowTheme.of(context)
                  .primaryBackground
                  .withValues(alpha: 0.3),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context)
                        .primaryText
                        .withValues(alpha: 0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: FlutterFlowTheme.of(context).success),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _model.noteController,
            focusNode: _model.noteFocusNode,
            style: TextStyle(color: FlutterFlowTheme.of(context).primaryText),
            decoration: InputDecoration(
              labelText: 'Nota Administrativa (Opcional)',
              labelStyle:
                  TextStyle(color: FlutterFlowTheme.of(context).secondaryText),
              prefixIcon: Icon(Icons.note,
                  color: FlutterFlowTheme.of(context).secondaryText),
              filled: true,
              fillColor: FlutterFlowTheme.of(context)
                  .primaryBackground
                  .withValues(alpha: 0.3),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context)
                        .primaryText
                        .withValues(alpha: 0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: FlutterFlowTheme.of(context).primaryText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: FFButtonWidget(
            onPressed: () {
              setState(() {
                _model.selectedUser = null;
                _model.amountController?.clear();
                _model.noteController?.clear();
              });
            },
            text: 'Cancelar',
            options: FFButtonOptions(
              height: 50,
              color: FlutterFlowTheme.of(context)
                  .primaryText
                  .withValues(alpha: 0.1),
              textStyle: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText),
              borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context)
                      .primaryText
                      .withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FFButtonWidget(
            onPressed: () async {
              // Logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saldo agregado exitosamente')),
              );
            },
            text: 'Confirmar Recarga',
            options: FFButtonOptions(
              height: 50,
              color: FlutterFlowTheme.of(context).primary,
              textStyle: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).info,
                  fontWeight: FontWeight.bold),
              borderRadius: BorderRadius.circular(12),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Mock data
      itemBuilder: (context, index) {
        return _buildHistoryItem(
          'Usuario Test ${index + 1}',
          '\$50.00',
          'Hace ${index * 2} min',
          'Recarga manual - Bono',
        );
      },
    );
  }

  Widget _buildHistoryItem(
      String userName, String amount, String date, String note) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              FlutterFlowTheme.of(context).primaryText.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: FlutterFlowTheme.of(context)
                  .primaryText
                  .withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    FlutterFlowTheme.of(context).success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_upward,
                  color: FlutterFlowTheme.of(context).success, size: 20),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    note,
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).success,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
