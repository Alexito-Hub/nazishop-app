import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/backend/notification_service.dart';
import '/components/loading_indicator.dart';
import '/components/app_snackbar.dart';
import '/components/safe_image.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/components/design_system.dart';
import '/components/app_empty_state.dart';

class NotificationsUserWidget extends StatefulWidget {
  const NotificationsUserWidget({super.key});

  static const String routeName = 'notifications_user';
  static const String routePath = '/notificationsUser';

  @override
  State<NotificationsUserWidget> createState() =>
      _NotificationsUserWidgetState();
}

class _NotificationsUserWidgetState extends State<NotificationsUserWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Colors
  Color get _primaryColor => FlutterFlowTheme.of(context).primary;

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;
  bool _isLoading = true;
  List<Map<String, dynamic>> _notifications = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final notifs = await NotificationService.getNotifications();
    if (mounted) {
      setState(() {
        _notifications = notifs;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _loadNotifications();
  }

  Future<void> _markAsRead(String id, int index) async {
    if (_notifications[index]['read'] == true) return;

    setState(() {
      _notifications[index]['read'] = true;
    });
    await NotificationService.markAsRead(id);
  }

  Future<void> _deleteNotification(String id, int index) async {
    final theme = FlutterFlowTheme.of(context);
    final removed = _notifications[index];
    setState(() {
      _notifications.removeAt(index);
    });

    bool success = await NotificationService.deleteNotification(id);
    if (!success && mounted) {
      // Revert if failed
      setState(() {
        _notifications.insert(index, removed);
      });
      AppSnackbar.show(context, 'Error eliminando notificación',
          backgroundColor: theme.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            color: theme.primary,
            backgroundColor: theme.secondaryBackground,
            child: _isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const AppEmptyState(
      icon: Icons.notifications_off_outlined,
      message: 'No tienes notificaciones',
    );
  }

  // ===================== DESKTOP =====================
  Widget _buildDesktopLayout() {
    final theme = FlutterFlowTheme.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Centro de Avisos',
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mantente al día con actualizaciones y alertas importantes',
                        style: GoogleFonts.outfit(
                            fontSize: 16, color: theme.secondaryText),
                      ),
                      const SizedBox(height: 16),
                      if (_notifications.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _primaryColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            '${_notifications.where((n) => !n['read']).length} nuevas alertas',
                            style: GoogleFonts.outfit(
                                color: _primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              sliver: _isLoading
                  ? SliverFillRemaining(
                      child: Center(
                          child: LoadingIndicator(
                      color: _primaryColor,
                    )))
                  : _notifications.isEmpty
                      ? SliverToBoxAdapter(child: _buildEmptyState())
                      : SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 600,
                            mainAxisExtent: 140, // Height of card
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildNotificationItem(
                                      _notifications[index], index)
                                  .animate()
                                  .fadeIn(delay: (30 * index).ms)
                                  .slideX();
                            },
                            childCount: _notifications.length,
                          ),
                        ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  // ===================== MOBILE =====================
  Widget _buildMobileLayout() {
    final theme = FlutterFlowTheme.of(context);
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Header Standard Transparente & Centrado
        DSMobileAppBar(
          title: 'Notificaciones',
          actions: [
            IconButton(
              onPressed: _handleRefresh,
              icon: Icon(Icons.refresh_rounded, color: theme.secondaryText),
              tooltip: 'Actualizar',
            ),
            const SizedBox(width: 8),
          ],
        ),

        // 2. Contenido
        if (_isLoading)
          SliverFillRemaining(
            child: Center(child: LoadingIndicator(color: _primaryColor)),
          )
        else if (_notifications.isEmpty)
          SliverFillRemaining(child: _buildEmptyState())
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildNotificationItem(_notifications[index], index)
                        .animate()
                        .fadeIn(delay: (50 * index).ms),
                  );
                },
                childCount: _notifications.length,
              ),
            ),
          )
      ],
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notif, int index) {
    bool read = notif['read'];
    final theme = FlutterFlowTheme.of(context);

    // Parse time logic simplified for display
    String timeStr = 'Reciente';
    try {
      // Assuming ISO string
      if (notif['time'] != null) {
        final date = DateTime.tryParse(notif['time']);
        if (date != null) {
          final diff = DateTime.now().difference(date);
          if (diff.inDays > 0) {
            timeStr = '${diff.inDays}d';
          } else if (diff.inHours > 0) {
            timeStr = '${diff.inHours}h';
          } else {
            timeStr = '${diff.inMinutes}m';
          }
        } else {
          timeStr = notif['time'];
        }
      }
    } catch (e) {
      timeStr = notif['time'] ?? '';
    }

    return Dismissible(
      key: Key(notif['id'] ?? index.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline,
            color: Colors.white), // White on red background
      ),
      onDismissed: (direction) => _deleteNotification(notif['id'], index),
      child: GestureDetector(
        onTap: () async {
          await _markAsRead(notif['id'], index);
          if (notif['route'] != null && notif['route'].toString().isNotEmpty) {
            if (mounted) context.push(notif['route']);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(20),
            // Subtly highlight unread items with a border
            border: Border.all(
                color: read
                    ? theme.alternate
                    : _primaryColor.withValues(alpha: 0.3),
                width: 1),
            boxShadow: read
                ? []
                : [
                    BoxShadow(
                      color: _primaryColor.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container OR Image
              if (notif['imageUrl'] != null &&
                  notif['imageUrl'].toString().isNotEmpty)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SafeImage(
                      notif['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(notif['color'] ?? 0xFFE50914)
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                      NotificationService.getIconData(notif['icon'] ?? ''),
                      color: Color(notif['color'] ?? 0xFFE50914),
                      size: 24),
                ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (notif['priority'] == 'high')
                          Container(
                            margin: const EdgeInsets.only(right: 6, top: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4)),
                            child: const Text('URGENTE',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                        Expanded(
                          child: Text(notif['title'] ?? 'Notificación',
                              style: GoogleFonts.outfit(
                                  color: theme.primaryText,
                                  fontSize: 16,
                                  fontWeight: read
                                      ? FontWeight.normal
                                      : FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Text(timeStr,
                            style: GoogleFonts.outfit(
                                color: theme.secondaryText, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(notif['message'] ?? '',
                        style: GoogleFonts.outfit(
                            color: theme.secondaryText,
                            fontSize: 14,
                            height: 1.4)),
                    if (notif['route'] != null &&
                        notif['route'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'Ver detalles',
                              style: GoogleFonts.outfit(
                                color: _primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Icon(Icons.arrow_forward,
                                size: 12, color: _primaryColor),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Unread Indicator
              if (!read)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: _primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor,
                            blurRadius: 6,
                            spreadRadius: 1,
                          )
                        ]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
