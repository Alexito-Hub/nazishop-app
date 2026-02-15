import 'package:nazi_shop/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/admin_service.dart';

import 'package:flutter_animate/flutter_animate.dart';
import '../../../components/smart_back_button.dart';

class AdminAnalyticsPage extends StatefulWidget {
  const AdminAnalyticsPage({super.key});

  @override
  State<AdminAnalyticsPage> createState() => _AdminAnalyticsPageState();
}

class _AdminAnalyticsPageState extends State<AdminAnalyticsPage> {
  bool _isLoading = false;
  Map<String, dynamic> _stats = {};
  Map<String, dynamic> _serverStats = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final res = await AdminService.getDashboardStats();
      final serverRes = await AdminService.getServerStats();
      if (mounted) {
        setState(() {
          _stats = res['data'] ?? {};
          _serverStats = serverRes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final theme = FlutterFlowTheme.of(context);

    // Adaptive Colors
    final bgColor = theme.primaryBackground;
    final cardColor = theme.secondaryBackground;
    final borderColor = theme.alternate;

    return Scaffold(
      backgroundColor: bgColor,
      body: isDesktop
          ? _buildDesktopLayout(theme, cardColor, borderColor)
          : _buildMobileLayout(theme, cardColor, borderColor),
    );
  }

  Widget _buildDesktopLayout(
      FlutterFlowTheme theme, Color cardColor, Color borderColor) {
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
                        Text('Analytics',
                            style: GoogleFonts.outfit(
                                color: theme.primaryText,
                                fontSize: 32,
                                fontWeight: FontWeight.bold)),
                        Text('Métricas y rendimiento de la tienda',
                            style: GoogleFonts.outfit(
                                color: theme.secondaryText, fontSize: 16)),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.date_range,
                              color: theme.secondaryText, size: 16),
                          const SizedBox(width: 8),
                          Text('Últimos 30 días',
                              style: GoogleFonts.outfit(
                                  color: theme.secondaryText,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              sliver: SliverToBoxAdapter(
                  child: _buildContent(true, theme, cardColor, borderColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
      FlutterFlowTheme theme, Color cardColor, Color borderColor) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          leading: SmartBackButton(color: theme.primaryText),
          title: Text('Analytics',
              style: GoogleFonts.outfit(
                  color: theme.primaryText, fontWeight: FontWeight.bold)),
          centerTitle: true,
          pinned: true,
          floating: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
              child: _buildContent(false, theme, cardColor, borderColor)),
        ),
      ],
    );
  }

  Widget _buildContent(bool isDesktop, FlutterFlowTheme theme, Color cardColor,
      Color borderColor) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: theme.primary));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            mainAxisExtent: 140, // Height for Stat Cards
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatCard('Usuarios', '${_stats['users']?['total'] ?? 0}',
                Icons.people, theme, cardColor, borderColor),
            _buildStatCard(
                'Ventas (Mes)',
                '\$${_stats['revenue']?['monthly'] ?? 0}',
                Icons.attach_money,
                theme,
                cardColor,
                borderColor),
            _buildStatCard('Pedidos', '${_stats['orders']?['total'] ?? 0}',
                Icons.shopping_bag, theme, cardColor, borderColor),
            _buildStatCard(
                'Inventario',
                '${_stats['inventory']?['total'] ?? 0}',
                Icons.inventory,
                theme,
                cardColor,
                borderColor),
          ],
        ),
        const SizedBox(height: 30),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildServerInfo(theme, cardColor, borderColor)),
              const SizedBox(width: 20),
              Expanded(child: _buildAppStatus(theme, cardColor, borderColor)),
            ],
          )
        else ...[
          _buildServerInfo(theme, cardColor, borderColor),
          const SizedBox(height: 20),
          _buildAppStatus(theme, cardColor, borderColor),
        ],
        const SizedBox(height: 30),
        Text('Últimos Movimientos',
            style: GoogleFonts.outfit(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: _stats['recentTransactions'] != null &&
                    (_stats['recentTransactions'] as List).isNotEmpty
                ? Column(
                    children: List.generate(
                        (_stats['recentTransactions'] as List).length, (index) {
                      final transaction =
                          (_stats['recentTransactions'] as List)[index];
                      final isPositive =
                          (transaction['amount'] ?? 0) > 0; // Assumption
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                            backgroundColor:
                                theme.primary.withValues(alpha: 0.1),
                            child: Icon(
                                isPositive
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: theme.primary,
                                size: 18)),
                        title: Text(
                            transaction['description'] ??
                                transaction['type'] ??
                                'Transacción',
                            style:
                                GoogleFonts.outfit(color: theme.primaryText)),
                        subtitle: Text(
                            transaction['created_at'] != null
                                ? 'Fecha: ${transaction['created_at'].toString().split('T')[0]}'
                                : 'Reciente',
                            style:
                                GoogleFonts.outfit(color: theme.secondaryText)),
                        trailing: Text(
                            '${isPositive ? '+' : ''}\$${transaction['amount'] ?? 0}',
                            style: GoogleFonts.outfit(
                                color: isPositive ? theme.success : theme.error,
                                fontWeight: FontWeight.bold)),
                      );
                    }),
                  )
                : Center(
                    child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('No hay movimientos recientes',
                        style: GoogleFonts.outfit(color: theme.secondaryText)),
                  ))),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon,
      FlutterFlowTheme theme, Color cardColor, Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.primary, size: 28),
          const SizedBox(height: 12),
          Text(value,
              style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          Text(title,
              style:
                  GoogleFonts.outfit(color: theme.secondaryText, fontSize: 14)),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildServerInfo(
      FlutterFlowTheme theme, Color cardColor, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Información del Servidor',
            style: GoogleFonts.outfit(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              _buildProgressRow('CPU Load', _serverStats['cpu'] ?? 0.0,
                  FlutterFlowTheme.of(context).primary, theme),
              const SizedBox(height: 16),
              if (_serverStats['cpu_model'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CPU Model',
                          style:
                              GoogleFonts.outfit(color: theme.secondaryText)),
                      const SizedBox(height: 4),
                      Text(_serverStats['cpu_model'],
                          style: GoogleFonts.outfit(
                              color: theme.primaryText, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              _buildProgressRow('Memory Usage', _serverStats['memory'] ?? 0.0,
                  FlutterFlowTheme.of(context).tertiary, theme),
              const SizedBox(height: 16),
              _buildProgressRow('Disk Space', _serverStats['disk'] ?? 0.0,
                  FlutterFlowTheme.of(context).secondary, theme),
              const SizedBox(height: 20),
              Divider(color: borderColor),
              const SizedBox(height: 16),
              if (_serverStats['platform'] != null)
                Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('OS Platform',
                              style: GoogleFonts.outfit(
                                  color: theme.secondaryText)),
                          Text(_serverStats['platform'],
                              style: GoogleFonts.outfit(
                                  color: theme.primaryText,
                                  fontWeight: FontWeight.bold))
                        ])),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Uptime',
                      style: GoogleFonts.outfit(color: theme.secondaryText)),
                  Text(_serverStats['uptime'] ?? '-',
                      style: GoogleFonts.outfit(
                          color: theme.primaryText,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow(
      String label, double value, Color color, FlutterFlowTheme theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.outfit(color: theme.secondaryText)),
            Text('${value.toStringAsFixed(1)}%',
                style: GoogleFonts.outfit(
                    color: theme.primaryText, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: color.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildAppStatus(
      FlutterFlowTheme theme, Color cardColor, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Estado de la Aplicación',
            style: GoogleFonts.outfit(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              _buildStatusRow(
                  'Version', _serverStats['version'] ?? '1.0.0', theme),
              _buildStatusRow(
                  'Node Version', _serverStats['node_version'] ?? '-', theme),
              _buildStatusRow('Environment',
                  _serverStats['environment'] ?? 'Production', theme),
              _buildStatusRow(
                  'Database', _serverStats['database'] ?? 'Connected', theme,
                  isStatus: true,
                  isOk: _serverStats['database'] == 'Connected'),
              _buildStatusRow(
                  'API Status', _serverStats['status'] ?? 'Online', theme,
                  isStatus: true, isOk: _serverStats['status'] == 'Online'),
              _buildStatusRow(
                  'Last Backup', _serverStats['last_backup'] ?? '-', theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(String label, String value, FlutterFlowTheme theme,
      {bool isStatus = false, bool isOk = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(color: theme.secondaryText)),
          isStatus
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOk
                        ? theme.success.withValues(alpha: 0.1)
                        : theme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: isOk ? theme.success : theme.error),
                  ),
                  child: Text(value,
                      style: GoogleFonts.outfit(
                          color: isOk ? theme.success : theme.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                )
              : Text(value,
                  style: GoogleFonts.outfit(
                      color: theme.primaryText, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
