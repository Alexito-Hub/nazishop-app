import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/domain.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../../components/smart_back_button.dart';

class DomainApprovalPage extends StatefulWidget {
  const DomainApprovalPage({super.key});

  @override
  State<DomainApprovalPage> createState() => _DomainApprovalPageState();
}

class _DomainApprovalPageState extends State<DomainApprovalPage> {
  List<Domain> _domains = [];
  bool _isLoading = false;
  String _filter = 'pending';

  @override
  void initState() {
    super.initState();
    _loadDomains();
  }

  Future<void> _loadDomains() async {
    setState(() => _isLoading = true);
    try {
      final res = await AdminService.getDomains(
          status: _filter == 'all' ? null : _filter);
      if (mounted) {
        setState(() {
          _domains = res.map((e) => Domain.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String id, String newStatus) async {
    try {
      await AdminService.updateDomainStatus(
        id: id,
        newStatus: newStatus,
      );
      _loadDomains();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Estado actualizado a $newStatus'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  void _showDomainDetails(Domain domain) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DomainDetailsSheet(
        domain: domain,
        onUpdate: (String newStatus) {
          Navigator.pop(context);
          _updateStatus(domain.id, newStatus);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
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
          if (isDesktop) _buildDesktopLayout() else _buildMobileLayout(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dominios Pendientes',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Gestiona las solicitudes de productos domain',
                          style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _chip('Pendientes', 'pending'),
                        _chip('En Proceso', 'in_progress'),
                        _chip('Completados', 'completed'),
                        _chip('Todos', 'all'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
              )
            else if (_domains.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No hay dominios ${_filter == 'all' ? '' : _filter}',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _buildDomainCard(_domains[i]),
                    childCount: _domains.length,
                  ),
                ),
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
          surfaceTintColor: Colors.transparent,
          leading: SmartBackButton(
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          title: Text(
            'Dominios Pendientes',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          floating: true,
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _chip('Pendientes', 'pending'),
                _chip('En Proceso', 'in_progress'),
                _chip('Completados', 'completed'),
                _chip('Todos', 'all'),
              ],
            ),
          ),
        ),
        if (_isLoading)
          SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
          )
        else if (_domains.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Text(
                'No hay dominios ${_filter == 'all' ? '' : _filter}',
                style: GoogleFonts.outfit(
                    color: FlutterFlowTheme.of(context).secondaryText),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final domain = _domains[index];
                  return _buildDomainCard(domain)
                      .animate()
                      .fadeIn(delay: (30 * index).ms)
                      .slideY(begin: 0.1);
                },
                childCount: _domains.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _chip(String label, String val) {
    final sel = _filter == val;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() => _filter = val);
          _loadDomains();
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: sel
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: sel
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: sel
                  ? FlutterFlowTheme.of(context).info
                  : FlutterFlowTheme.of(context).secondaryText,
              fontWeight: sel ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDomainCard(Domain domain) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      domain.productSnapshot?.title ?? 'Domain Product',
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      domain.desiredCredentials.email,
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(domain.status).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _statusText(domain.status),
                  style: GoogleFonts.outfit(
                    color: _statusColor(domain.status),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('dd MMM yyyy HH:mm').format(domain.createdAt),
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showDomainDetails(domain),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Ver Detalles',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return FlutterFlowTheme.of(context).warning;
      case 'in_progress':
        return FlutterFlowTheme.of(context).tertiary;
      case 'completed':
        return FlutterFlowTheme.of(context).success;
      case 'cancelled':
        return FlutterFlowTheme.of(context).error;
      default:
        return FlutterFlowTheme.of(context).secondaryText;
    }
  }

  String _statusText(String status) {
    switch (status) {
      case 'pending':
        return 'PENDIENTE';
      case 'in_progress':
        return 'EN PROCESO';
      case 'completed':
        return 'COMPLETADO';
      case 'cancelled':
        return 'CANCELADO';
      default:
        return status.toUpperCase();
    }
  }
}

class _DomainDetailsSheet extends StatelessWidget {
  final Domain domain;
  final Function(String) onUpdate;

  const _DomainDetailsSheet({
    required this.domain,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: ListView(
          controller: controller,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Detalles del Domain',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            const SizedBox(height: 24),
            _DetailRow('Producto', domain.productSnapshot?.title ?? 'N/A'),
            _DetailRow('Email', domain.desiredCredentials.email),
            if (domain.desiredCredentials.password.isNotEmpty)
              _DetailRow('Password', domain.desiredCredentials.password),
            if (domain.desiredCredentials.notes.isNotEmpty)
              _DetailRow('Notas del Cliente', domain.desiredCredentials.notes),
            _DetailRow('Estado', _statusText(domain.status)),
            _DetailRow('Fecha',
                DateFormat('dd/MM/yyyy HH:mm').format(domain.createdAt)),
            if (domain.adminNotes != null)
              _DetailRow('Notas Admin', domain.adminNotes!),
            const SizedBox(height: 24),
            if (domain.status != 'completed')
              Column(
                children: [
                  _ActionButton(
                    label: 'Marcar como En Proceso',
                    color: FlutterFlowTheme.of(context).tertiary,
                    onTap: () => onUpdate('in_progress'),
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    label: 'Completar',
                    color: FlutterFlowTheme.of(context).success,
                    onTap: () => onUpdate('completed'),
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    label: 'Cancelar',
                    color: FlutterFlowTheme.of(context).error,
                    onTap: () => onUpdate('cancelled'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'in_progress':
        return 'En Proceso';
      case 'completed':
        return 'Completado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
