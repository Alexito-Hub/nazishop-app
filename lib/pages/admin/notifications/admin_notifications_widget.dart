import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import '../../../components/smart_back_button.dart';
import 'package:nazi_shop/models/notification_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class AdminNotificationsWidget extends StatefulWidget {
  const AdminNotificationsWidget({super.key});

  @override
  State<AdminNotificationsWidget> createState() =>
      _AdminNotificationsWidgetState();
}

class _AdminNotificationsWidgetState extends State<AdminNotificationsWidget> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final res = await AdminService.getNotifications();
      if (mounted) {
        setState(() {
          _notifications =
              res.map((e) => NotificationModel.fromJson(e)).toList();
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

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Stack(
        children: [
          // Removed background blur bubbles for cleaner look
          if (isDesktop) _buildDesktopLayout() else _buildMobileLayout(),
        ],
      ),
      floatingActionButton: isDesktop
          ? null
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).secondary
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: _goToCreatePage,
                backgroundColor: FlutterFlowTheme.of(context).transparent,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                icon: Icon(Icons.add,
                    color: FlutterFlowTheme.of(context).primaryText),
                label: Text(
                  'Nueva',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
            ),
    );
  }

  Widget _buildDesktopLayout() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notificaciones',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                      Text('Envía mensajes push a los usuarios',
                          style: GoogleFonts.outfit(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 16)),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).primary,
                          FlutterFlowTheme.of(context).secondary
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _goToCreatePage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: Text('Nueva Notificación',
                          style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
              Expanded(child: _buildList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          pinned: true,
          title: Text('Notificaciones',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.bold)),
          leading:
              SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
        ),
        SliverFillRemaining(child: _buildList()),
      ],
    );
  }

  Widget _buildList() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary));
    }
    if (_notifications.isEmpty) {
      return Center(
          child: Text('No hay historial',
              style: TextStyle(
                  color: FlutterFlowTheme.of(context).secondaryText)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final n = _notifications[index];
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
                        child: Image.network(n.imageUrl!, fit: BoxFit.cover))
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
      _loadData();
    }
  }
}
