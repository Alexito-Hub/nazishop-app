import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '/backend/admin_service.dart';
import '/models/domain.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../../../components/smart_back_button.dart';
import 'components/domain_card.dart';
import 'components/domain_details_sheet.dart';

class DomainApprovalWidget extends StatefulWidget {
  const DomainApprovalWidget({super.key});

  @override
  State<DomainApprovalWidget> createState() => _DomainApprovalWidgetState();
}

class _DomainApprovalWidgetState extends State<DomainApprovalWidget> {
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
          _domains = res;
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
      builder: (context) => DomainDetailsSheet(
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
                    (ctx, i) => DomainCard(
                      domain: _domains[i],
                      onTap: () => _showDomainDetails(_domains[i]),
                    ),
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
                  return DomainCard(
                    domain: domain,
                    onTap: () => _showDomainDetails(domain),
                  ).animate().fadeIn(delay: (30 * index).ms).slideY(begin: 0.1);
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
}
