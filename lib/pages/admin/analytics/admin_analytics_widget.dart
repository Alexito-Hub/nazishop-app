import 'package:nazi_shop/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import 'package:nazi_shop/models/admin_models.dart';

import '../../../components/smart_back_button.dart';
import 'components/analytics_stat_card.dart';
import 'components/server_info_card.dart';
import 'components/app_status_card.dart';
import 'components/recent_transactions_list.dart';

class AdminAnalyticsWidget extends StatefulWidget {
  const AdminAnalyticsWidget({super.key});

  @override
  State<AdminAnalyticsWidget> createState() => _AdminAnalyticsWidgetState();
}

class _AdminAnalyticsWidgetState extends State<AdminAnalyticsWidget> {
  bool _isLoading = false;
  DashboardStats? _stats;
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
          _stats = res;
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
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            mainAxisExtent: 140, // Height for Stat Cards
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            AnalyticsStatCard(
              title: 'Usuarios',
              value: '${_stats?.totalUsers ?? 0}',
              icon: Icons.people,
            ),
            AnalyticsStatCard(
              title: 'Ventas (Mes)',
              value: '\$${_stats?.monthlyRevenue ?? 0}',
              icon: Icons.attach_money,
            ),
            AnalyticsStatCard(
              title: 'Pedidos',
              value: '${_stats?.totalOrders ?? 0}',
              icon: Icons.shopping_bag,
            ),
            AnalyticsStatCard(
              title: 'Inventario',
              value: '${_stats?.activeServices ?? 0}',
              icon: Icons.inventory,
            ),
          ],
        ),
        const SizedBox(height: 30),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: ServerInfoCard(serverStats: _serverStats)),
              const SizedBox(width: 20),
              Expanded(child: AppStatusCard(serverStats: _serverStats)),
            ],
          )
        else ...[
          ServerInfoCard(serverStats: _serverStats),
          const SizedBox(height: 20),
          AppStatusCard(serverStats: _serverStats),
        ],
        const SizedBox(height: 30),
        RecentTransactionsList(transactions: _stats?.recentTransactions ?? []),
      ],
    );
  }
}
