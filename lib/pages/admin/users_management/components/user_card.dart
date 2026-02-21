import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/custom_snackbar.dart';
import '/backend/admin_service.dart';
import '/models/user_model.dart';
import '/components/safe_image.dart';
import 'add_balance_dialog.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onUpdate;

  const UserCard({
    super.key,
    required this.user,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = user.isActive;
    final role = user.role;
    final isSuperAdmin = role.toLowerCase() == 'superadmin';
    final isAdmin = role.toLowerCase() == 'admin';

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Added for flexibility
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate),
                  ),
                  child: CircleAvatar(
                    radius: 24.0,
                    backgroundColor: FlutterFlowTheme.of(context).alternate,
                    child: user.photoUrl.isNotEmpty
                        ? ClipOval(
                            child: SafeImage(
                              user.photoUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.person_outline_rounded,
                            size: 24.0,
                            color: FlutterFlowTheme.of(context).secondaryText),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.displayName,
                              style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isSuperAdmin) ...[
                            const SizedBox(width: 6.0),
                            Icon(Icons.stars_rounded,
                                color: FlutterFlowTheme.of(context).tertiary,
                                size: 16.0),
                          ] else if (isAdmin) ...[
                            const SizedBox(width: 6.0),
                            Icon(Icons.verified_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 16.0),
                          ],
                        ],
                      ),
                      Text(
                        user.email.isNotEmpty ? user.email : 'No email',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: isActive
                        ? FlutterFlowTheme.of(context)
                            .success
                            .withValues(alpha: 0.1)
                        : FlutterFlowTheme.of(context)
                            .error
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isActive
                          ? FlutterFlowTheme.of(context)
                              .success
                              .withValues(alpha: 0.2)
                          : FlutterFlowTheme.of(context)
                              .error
                              .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    isActive ? 'Activo' : 'Inactivo',
                    style: GoogleFonts.outfit(
                      color: isActive
                          ? FlutterFlowTheme.of(context).success
                          : FlutterFlowTheme.of(context).error,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatBadge(
                  context,
                  Icons.shopping_bag_rounded,
                  '${user.totalPurchases}',
                ),
                const SizedBox(width: 8.0),
                _buildStatBadge(
                  context,
                  Icons.monetization_on_rounded,
                  '\$${user.totalSpent.toStringAsFixed(0)}',
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    isActive ? 'Bloquear' : 'Activar',
                    isActive ? Icons.block_rounded : Icons.check_circle_rounded,
                    isActive
                        ? FlutterFlowTheme.of(context).secondaryText
                        : FlutterFlowTheme.of(context).success,
                    () async {
                      final success = await AdminService.updateUser(
                          user.id, {'is_active': !isActive});
                      if (success) {
                        onUpdate();
                        if (context.mounted) {
                          CustomSnackBar.success(context, 'Estado actualizado');
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: PopupMenuButton<String>(
                    onSelected: (newRole) async {
                      final success = await AdminService.updateUser(
                          user.id, {'role': newRole});
                      if (success) {
                        onUpdate();
                        if (context.mounted) {
                          CustomSnackBar.success(context, 'Rol actualizado');
                        }
                      }
                    },
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    offset: const Offset(0, -120),
                    itemBuilder: (context) => [
                      _buildPopupItem(
                          context,
                          'customer',
                          'Cliente',
                          Icons.person_rounded,
                          FlutterFlowTheme.of(context).primaryText),
                      _buildPopupItem(
                          context,
                          'admin',
                          'Admin',
                          Icons.verified_rounded,
                          FlutterFlowTheme.of(context).primary),
                      _buildPopupItem(
                          context,
                          'superadmin',
                          'Superadmin',
                          Icons.stars_rounded,
                          FlutterFlowTheme.of(context).tertiary),
                    ],
                    child: _buildActionButton(
                      context,
                      'Rol',
                      Icons.manage_accounts_rounded,
                      FlutterFlowTheme.of(context).tertiary,
                      null,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                _buildActionButton(
                  context,
                  '',
                  Icons.add_card_rounded,
                  FlutterFlowTheme.of(context).primary,
                  () => showDialog(
                    context: context,
                    builder: (context) =>
                        AddBalanceDialog(user: user, onUpdate: onUpdate),
                  ),
                  width: 44,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).alternate,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 12.0, color: FlutterFlowTheme.of(context).secondaryText),
          const SizedBox(width: 6.0),
          Text(
            text,
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon,
      Color color, VoidCallback? onTap,
      {double? width}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 40,
        width: width,
        padding:
            width == null ? const EdgeInsets.symmetric(horizontal: 12) : null,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(BuildContext context, String value,
      String label, IconData icon, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 13)),
        ],
      ),
    );
  }
}
