import 'package:flutter/services.dart'; // Required for Clipboard
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nazi_shop/backend/admin_service.dart';
import '../../../components/smart_back_button.dart';
import 'package:intl/intl.dart';
// Required for auth check
import 'package:go_router/go_router.dart';
import '../../../../backend/security_manager.dart';
import '../components/security_check_dialog.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class AdminInventoryPage extends StatefulWidget {
  final String? listingId;
  final String? listingTitle;

  const AdminInventoryPage({super.key, this.listingId, this.listingTitle});

  @override
  State<AdminInventoryPage> createState() => _AdminInventoryPageState();
}

class _AdminInventoryPageState extends State<AdminInventoryPage> {
  // Styles
  // Colores ahora gestionados por FlutterFlowTheme

  // State
  // final _inputCtrl = TextEditingController(); // REMOVED: Old bulk input

  bool _isLoading = false;
  List<dynamic> _inventory = [];
  String _filterStatus = 'all'; // all, available, sold

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSecurity());
  }

  @override
  void dispose() {
    super.dispose();
  }

  // --- SECURITY ---
  Future<void> _checkSecurity() async {
    // 1. Check if we already have a valid session
    if (SecurityManager().isSessionValid) {
      if (mounted) {
        _loadInventory();
      }
      return;
    }

    // 2. If not, ask for OTP
    final authorized = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SecurityCheckDialog(),
    );

    if (authorized == true) {
      SecurityManager().recordVerification(); // Start new session
      if (mounted) {
        _loadInventory();
      }
    } else {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _loadInventory() async {
    setState(() => _isLoading = true);
    try {
      final data = await AdminService.getInventory(listingId: widget.listingId);
      if (mounted) {
        setState(() {
          _inventory = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<dynamic> get _filteredInventory {
    if (_filterStatus == 'all') return _inventory;

    return _inventory.where((i) {
      final soldTo = i['soldToUser'];
      final status = i['status'] ?? 'available';
      // Treat 'reserved' as effectively sold/unavailable for now
      final isReallySold =
          status == 'sold' || status == 'reserved' || soldTo != null;

      if (_filterStatus == 'sold') return isReallySold;
      if (_filterStatus == 'available') return !isReallySold;
      return true;
    }).toList();
  }

  // --- UI BUILDERS ---

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      floatingActionButton: isDesktop
          ? null
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).secondary,
                  ], // Red Gradient
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
                onPressed: _showAddModal,
                backgroundColor: FlutterFlowTheme.of(context).transparent,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                icon: Icon(Icons.add_task,
                    color: FlutterFlowTheme.of(context).tertiary),
                label: Text(
                  'Añadir Cuenta',
                  style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).tertiary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ),
            ),
    );
  }

  // --- MOBILE LAYOUT (COMPACT LIST) ---
  Widget _buildMobileLayout() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: FlutterFlowTheme.of(context).transparent,
          surfaceTintColor: FlutterFlowTheme.of(context).transparent,
          pinned: true,
          floating: true,
          elevation: 0,
          leadingWidth: 70,
          automaticallyImplyLeading: false,
          leading:
              SmartBackButton(color: FlutterFlowTheme.of(context).primaryText),
          centerTitle: true,
          title: Text(
            widget.listingTitle ?? 'Gestión de Stock',
            style: GoogleFonts.outfit(
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
          actions: [
            // Removed redundant IconButton
          ],
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Todos', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Disponibles', 'available'),
                const SizedBox(width: 8),
                _buildFilterChip('Vendidos', 'sold'),
              ],
            ),
          ),
        ),
        if (_isLoading)
          SliverFillRemaining(
              child: Center(
                  child: CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary)))
        else if (_filteredInventory.isEmpty)
          SliverFillRemaining(
            child: _buildEmptyState(),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _filteredInventory[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InventoryRowItem(item: item)
                        .animate()
                        .fadeIn(delay: (30 * index).ms)
                        .slideX(begin: 0.1),
                  );
                },
                childCount: _filteredInventory.length,
              ),
            ),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }

  // --- DESKTOP LAYOUT (TABLE/LIST STYLE) ---
  Widget _buildDesktopLayout() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Row(
                  children: [
                    Expanded(
                      // Makes title flexible to avoid overflow
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gestión de Inventario',
                            style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            widget.listingTitle ?? 'Inventario General',
                            style: GoogleFonts.outfit(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Filters in a Row (Fixed width elements)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFilterChip('Todos', 'all'),
                        const SizedBox(width: 12),
                        _buildFilterChip('Disponibles', 'available'),
                        const SizedBox(width: 12),
                        _buildFilterChip('Vendidos', 'sold'),
                        const SizedBox(width: 24),
                        Container(
                          height: 44,
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
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _showAddModal,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  FlutterFlowTheme.of(context).primary,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                            ),
                            icon: Icon(Icons.add_task,
                                color: FlutterFlowTheme.of(context).tertiary,
                                size: 20),
                            label: Text(
                              'Añadir Cuenta',
                              style: GoogleFonts.outfit(
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            // Content
            if (_isLoading)
              const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()))
            else if (_filteredInventory.isEmpty)
              SliverFillRemaining(child: _buildEmptyState())
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 80),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child:
                            InventoryRowItem(item: _filteredInventory[index]),
                      );
                    },
                    childCount: _filteredInventory.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              shape: BoxShape.circle,
              border: Border.all(color: FlutterFlowTheme.of(context).alternate),
            ),
            child: Icon(Icons.inbox_outlined,
                size: 40, color: FlutterFlowTheme.of(context).secondaryText),
          ),
          const SizedBox(height: 16),
          Text('No hay ítems en esta sección',
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).secondaryText)),
        ],
      ),
    );
  }

  // --- COMPONENTS ---

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return InkWell(
      onTap: () => setState(() => _filterStatus = value),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected
                ? FlutterFlowTheme.of(context).secondaryText
                : FlutterFlowTheme.of(context).secondaryText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // --- ACTIONS ---
  // --- ACTIONS ---
  void _showAddModal() async {
    // Navigate using Named Route for proper URL and history
    final result = await context.pushNamed(
      'create_inventory',
      queryParameters: {
        if (widget.listingId != null) 'listingId': widget.listingId!,
        if (widget.listingTitle != null) 'listingTitle': widget.listingTitle!,
      },
    );

    // If added successfully, reload
    if (result == true) {
      _loadInventory();
    }
  }
}

// ===========================================================================
// 📦 INVENTORY ROW ITEM (Compact List Style)
// ===========================================================================
class InventoryRowItem extends StatefulWidget {
  final dynamic item;
  const InventoryRowItem({super.key, required this.item});

  @override
  State<InventoryRowItem> createState() => _InventoryRowItemState();
}

class _InventoryRowItemState extends State<InventoryRowItem> {
  bool _isHovered = false;

  void _showDetails(BuildContext context) {
    final item = widget.item;
    final creds = item['credentials'] ?? {};
    final soldTo = item['soldToUser'];
    final reservedBy = item['reservedBy']; // Available if populated
    final theme = FlutterFlowTheme.of(context);

    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: theme.secondaryBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: theme.alternate),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: theme.primary),
                        const SizedBox(width: 12),
                        Text('Detalles del Item',
                            style: GoogleFonts.outfit(
                                color: theme.primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const Spacer(),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close, color: theme.secondaryText))
                      ],
                    ),
                    Divider(color: theme.alternate, height: 30),

                    // Credentials Section
                    Text('CREDENCIALES',
                        style: GoogleFonts.outfit(
                            color: theme.secondaryText,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                        Icons.email, 'Email', creds['email'] ?? 'N/A', theme,
                        copyable: true),
                    _buildDetailRow(Icons.key, 'Contraseña',
                        creds['password'] ?? '********', theme,
                        copyable: true),
                    if (creds['pin'] != null &&
                        creds['pin'].toString().isNotEmpty)
                      _buildDetailRow(
                          Icons.pin, 'PIN', creds['pin'].toString(), theme,
                          copyable: true),
                    if (creds['profileName'] != null &&
                        creds['profileName'].toString().isNotEmpty)
                      _buildDetailRow(Icons.portrait, 'Perfil',
                          creds['profileName'].toString(), theme),

                    Divider(color: theme.alternate, height: 30),

                    // Status / Buyer Section
                    Text('ESTADO Y ASIGNACIÓN',
                        style: GoogleFonts.outfit(
                            color: theme.secondaryText,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                    const SizedBox(height: 12),

                    if (soldTo != null)
                      _buildUserRow('Vendido a', soldTo, theme.error, theme)
                    else if (reservedBy != null)
                      _buildUserRow(
                          'Reservado por', reservedBy, theme.warning, theme)
                    else
                      Row(children: [
                        Icon(Icons.check_circle_outline,
                            color: theme.success, size: 16),
                        const SizedBox(width: 8),
                        Text('Disponible para venta',
                            style: GoogleFonts.outfit(
                                color: theme.success, fontSize: 14))
                      ]),

                    const SizedBox(height: 20),

                    // Timestamps
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: theme.primaryBackground,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          _buildTimestampRow(
                              'Creado', item['createdAt'], theme),
                          if (item['reservedAt'] != null)
                            _buildTimestampRow(
                                'Reservado', item['reservedAt'], theme),
                          if (item['soldAt'] != null)
                            _buildTimestampRow(
                                'Vendido', item['soldAt'], theme),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, FlutterFlowTheme theme,
      {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.secondaryText),
          const SizedBox(width: 12),
          SizedBox(
              width: 80,
              child: Text(label,
                  style: GoogleFonts.outfit(
                      color: theme.secondaryText, fontSize: 13))),
          Expanded(
              child: SelectableText(value,
                  style: GoogleFonts.robotoMono(
                      color: theme.primaryText, fontSize: 13))),
          if (copyable)
            InkWell(
              onTap: () => Clipboard.setData(ClipboardData(text: value)),
              child: Icon(Icons.copy, size: 14, color: theme.primary),
            )
        ],
      ),
    );
  }

  Widget _buildUserRow(
      String label, dynamic user, Color color, FlutterFlowTheme theme) {
    // Check if user is Map or ObjectId string (depending on populate)
    // Assuming backend populates correctly.
    final name = user is Map
        ? (user['displayName'] ?? user['email'] ?? 'Usuario')
        : 'ID: $user';
    final email = user is Map ? (user['email'] ?? '') : '';
    final photo = user is Map ? user['photoUrl'] : null;

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color.withValues(alpha: 0.2),
          backgroundImage: photo != null ? NetworkImage(photo) : null,
          child:
              photo == null ? Icon(Icons.person, size: 16, color: color) : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.outfit(
                    color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            Text(name,
                style:
                    GoogleFonts.outfit(color: theme.primaryText, fontSize: 14)),
            if (email.isNotEmpty)
              Text(email,
                  style: GoogleFonts.outfit(
                      color: theme.secondaryText, fontSize: 12)),
          ],
        )
      ],
    );
  }

  Widget _buildTimestampRow(
      String label, String? dateStr, FlutterFlowTheme theme) {
    if (dateStr == null) return const SizedBox.shrink();
    final date = DateTime.parse(dateStr);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  GoogleFonts.outfit(color: theme.secondaryText, fontSize: 12)),
          Text(DateFormat('dd MMM yyyy, HH:mm').format(date),
              style: GoogleFonts.robotoMono(
                  color: theme.primaryText, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Parsing Data simplified logic (No images, just pure data)
    final item = widget.item;
    final theme = FlutterFlowTheme.of(context);
    // Try to get listing/offer title primarily
    final listing = item['offerId'] is Map ? item['offerId'] : {};

    String fullTitle = 'Producto Desconocido';
    if (listing.isNotEmpty) {
      // Prefer explicit title, fallback to service + plan
      if (listing['title'] != null && listing['title'].toString().isNotEmpty) {
        fullTitle = listing['title'].toString();
      } else {
        // Safe access for nested objects
        final serviceObj =
            listing['serviceId'] is Map ? listing['serviceId'] : null;
        final commercialObj =
            listing['commercial'] is Map ? listing['commercial'] : null;

        final serviceName = serviceObj != null
            ? (serviceObj['name'] ?? 'Servicio')
            : 'Servicio';
        final planName =
            commercialObj != null ? (commercialObj['plan'] ?? '') : '';
        fullTitle = '$serviceName $planName'.trim();
      }
    }

    final soldTo = item['soldToUser'];
    final reservedBy = item['reservedBy'];
    final statusStr = item['status'] as String? ?? 'available';
    final isReserved = statusStr == 'reserved';
    final isSold = statusStr == 'sold' || soldTo != null;

    // Status Logic
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isSold) {
      statusColor = theme.error;
      statusText = 'VENDIDO';
      statusIcon = Icons.lock_person;
    } else if (isReserved) {
      statusColor = theme.warning;
      statusText = 'RESERVADO';
      statusIcon = Icons.timelapse;
    } else {
      statusColor = theme.success;
      statusText = 'DISPONIBLE';
      statusIcon = Icons.check_circle_outline;
    }

    final creds = item['credentials'] ?? {};
    final email = creds['email'] ?? 'N/A';
    final dateStr = item['createdAt'];
    final formattedDate = dateStr != null
        ? DateFormat('dd MMM, HH:mm').format(DateTime.parse(dateStr))
        : '';

    final borderColor =
        _isHovered ? theme.primary.withValues(alpha: 0.5) : theme.alternate;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showDetails(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: theme.primary.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              // 1. Status Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),
              const SizedBox(width: 20),

              // 2. Main Info (Email + Service)
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      email,
                      style: GoogleFonts.robotoMono(
                        color: theme.primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (fullTitle.isNotEmpty)
                      Text(
                        fullTitle,
                        style: GoogleFonts.outfit(
                            color: theme.secondaryText, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // 3. Buyer / Reserve Info (Desktop mainly, or condensed on mobile)
              if (MediaQuery.of(context).size.width > 750) ...[
                const SizedBox(width: 20),
                Expanded(
                    flex: 3,
                    child: isSold && soldTo != null
                        ? Builder(builder: (context) {
                            final isMap = soldTo is Map;
                            final photo = isMap ? soldTo['photoUrl'] : null;
                            final photoUrl = photo is String ? photo : null;
                            final name = isMap
                                ? (soldTo['displayName'] ??
                                    soldTo['email'] ??
                                    'Usuario')
                                : 'ID: $soldTo';
                            return Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: theme.alternate,
                                  backgroundImage: photoUrl != null
                                      ? NetworkImage(photoUrl)
                                      : null,
                                  child: photoUrl == null
                                      ? Icon(Icons.person,
                                          size: 12, color: theme.secondaryText)
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Vendido a',
                                          style: GoogleFonts.outfit(
                                              color: theme.secondaryText,
                                              fontSize: 10)),
                                      Text(
                                        name,
                                        style: GoogleFonts.outfit(
                                            color: theme.primaryText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          })
                        : (isReserved && reservedBy != null
                            ? Builder(builder: (context) {
                                final isMap = reservedBy is Map;
                                final photo =
                                    isMap ? reservedBy['photoUrl'] : null;
                                final photoUrl = photo is String ? photo : null;
                                final name = isMap
                                    ? (reservedBy['displayName'] ??
                                        reservedBy['email'] ??
                                        'Usuario')
                                    : 'ID: $reservedBy';
                                return Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor:
                                          theme.warning.withValues(alpha: 0.2),
                                      backgroundImage: photoUrl != null
                                          ? NetworkImage(photoUrl)
                                          : null,
                                      child: photoUrl == null
                                          ? Icon(Icons.person,
                                              size: 12, color: theme.warning)
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Reservado por',
                                              style: GoogleFonts.outfit(
                                                  color: theme.warning,
                                                  fontSize: 10)),
                                          Text(
                                            name,
                                            style: GoogleFonts.outfit(
                                                color: theme.primaryText,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              })
                            : (isReserved
                                ? Text('Reservado',
                                    style: GoogleFonts.outfit(
                                        color: theme.warning, fontSize: 13))
                                : Text('Disponible para venta',
                                    style: GoogleFonts.outfit(
                                        color: theme.secondaryText,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic))))),
              ],

              // 4. Date & Status Label
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: statusColor.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(6),
                        color: statusColor.withValues(alpha: 0.05)),
                    child: Text(statusText,
                        style: GoogleFonts.outfit(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  Text(formattedDate,
                      style: GoogleFonts.outfit(
                          color: theme.secondaryText, fontSize: 11)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
