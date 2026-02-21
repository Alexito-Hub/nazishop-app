import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/admin_service.dart';
import '/models/notification_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '/components/design_system.dart';
import '/components/async_data_builder.dart';
import '/components/app_empty_state.dart';
import '/components/safe_image.dart';

class AdminNotificationsWidget extends StatefulWidget {
  const AdminNotificationsWidget({super.key});

  @override
  State<AdminNotificationsWidget> createState() =>
      _AdminNotificationsWidgetState();
}

class _AdminNotificationsWidgetState extends State<AdminNotificationsWidget> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = AdminService.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: AsyncDataBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, notifs) {
          // rebuild layout with loaded notifications
          return Stack(
            children: [
              if (isDesktop)
                _buildDesktopLayout(notifs)
              else
                _buildMobileLayout(notifs),
            ],
          );
        },
      ),
      floatingActionButton: isDesktop
          ? null
          : DSGradientFab(
              label: 'Nueva',
              icon: Icons.add,
              onPressed: _goToCreatePage,
            ),
    );
  }

  Widget _buildDesktopLayout(List<NotificationModel> notifs) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DSAdminPageHeader(
                title: 'Notificaciones',
                subtitle: 'Envía mensajes push a los usuarios',
                actionLabel: 'Nueva Notificación',
                actionIcon: Icons.send,
                onAction: _goToCreatePage,
              ),
              const SizedBox(height: 40),
              Expanded(child: _buildList(notifs)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(List<NotificationModel> notifs) {
    return CustomScrollView(
      slivers: [
        const DSMobileAppBar(title: 'Notificaciones'),
        SliverFillRemaining(child: _buildList(notifs)),
      ],
    );
  }

  Widget _buildList(List<NotificationModel> notifs) {
    if (notifs.isEmpty) {
      return const AppEmptyState(
        icon: Icons.notifications_none,
        message: 'No hay historial',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifs.length,
      itemBuilder: (context, index) {
        final n = notifs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: FlutterFlowTheme.of(context).alternate),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context)
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: n.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SafeImage(
                          n.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        n.type == 'offer'
                            ? Icons.local_offer
                            : (n.type == 'security'
                                ? Icons.security
                                : Icons.notifications),
                        color: FlutterFlowTheme.of(context).primary,
                        size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (n.priority == 'high')
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .error
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text('URGENTE',
                                style: GoogleFonts.outfit(
                                    color: FlutterFlowTheme.of(context).error,
                                    fontSize: 10)),
                          ),
                        Expanded(
                          child: Text(n.title,
                              style: GoogleFonts.outfit(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(n.message,
                        style: GoogleFonts.outfit(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 13)),
                    if (n.route != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Redirige a: ${n.route}',
                            style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 11)),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person,
                            size: 12,
                            color: FlutterFlowTheme.of(context).secondaryText),
                        const SizedBox(width: 4),
                        Text(
                            n.userId == 'ALL'
                                ? 'Todos los usuarios'
                                : 'Usuario: ${n.userId}',
                            style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 11)),
                        const Spacer(),
                        Text(DateFormat('dd MMM HH:mm').format(n.createdAt),
                            style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 11)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ).animate().fadeIn(delay: (50 * index).ms).slideX();
      },
    );
  }

  void _goToCreatePage() async {
    final res = await context.pushNamed('create_notification');
    if (res == true) {
      setState(() {
        _notificationsFuture = AdminService.getNotifications();
      });
    }
  }
}
