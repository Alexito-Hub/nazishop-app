import '/flutter_flow/flutter_flow_theme.dart';

import '../../../../components/smart_back_button.dart';
import '/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppearanceWidget extends StatefulWidget {
  const AppearanceWidget({super.key});

  static String routeName = 'appearance';
  static String routePath = '/appearance';

  @override
  State<AppearanceWidget> createState() => _AppearanceWidgetState();
}

class _AppearanceWidgetState extends State<AppearanceWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // --- PALETA DE COLORES (MODERN) ---
  // static const Color kPrimaryColor = Color(0xFFE50914); // Reemplazado por FlutterFlowTheme

  // --- ESTADO LOCAL ---
  late bool _animationsEnabled;
  late String _fontSize; // Pequeño, Normal, Grande
  final String _language = 'Español';

  bool get _isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    _animationsEnabled = FlutterFlowTheme.animationsEnabled;
    final factor = FlutterFlowTheme.fontSizeFactor;
    if (factor <= 0.85) {
      _fontSize = 'Pequeño';
    } else if (factor >= 1.15) {
      _fontSize = 'Grande';
    } else {
      _fontSize = 'Normal';
    }
  }

  Future<void> _updateAnimations(bool value) async {
    setState(() => _animationsEnabled = value);
    FlutterFlowTheme.saveAnimationsEnabled(value);
    // Force rebuild to apply animation settings (if widgets listen to it)
    MyApp.of(context).setThemeMode(FlutterFlowTheme.themeMode);
  }

  Future<void> _updateFontSize(String sizeKey) async {
    setState(() => _fontSize = sizeKey);
    double factor = 1.0;
    if (sizeKey == 'Pequeño') factor = 0.85;
    if (sizeKey == 'Grande') factor = 1.15;

    FlutterFlowTheme.saveFontSizeFactor(factor);
    // Force rebuild to apply text styles
    MyApp.of(context).setThemeMode(FlutterFlowTheme.themeMode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (_isDesktop) {
              return _buildDesktopLayout();
            } else {
              return _buildMobileLayout();
            }
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // 📱 MOBILE LAYOUT (< 900px)
  // ===========================================================================
  Widget _buildMobileLayout() {
    final theme = FlutterFlowTheme.of(context);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: theme.transparent,
          surfaceTintColor: theme.transparent,
          pinned: true,
          floating: true,
          elevation: 0,
          leadingWidth: 70,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryBackground.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: SmartBackButton(color: theme.primaryText),
          ),
          centerTitle: true,
          title: Text(
            'Apariencia',
            style: GoogleFonts.outfit(
              color: theme.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.0,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildSectionTitle("Tema"),
                const SizedBox(height: 12),
                _buildThemeSelectorMobile(),
                const SizedBox(height: 32),
                _buildSectionTitle("Accesibilidad"),
                const SizedBox(height: 12),
                _buildSwitchTile(
                  title: "Animaciones",
                  subtitle: "Reducir movimiento en la interfaz",
                  value: !_animationsEnabled,
                  onChanged: (v) => _updateAnimations(!v),
                  icon: Icons.animation_rounded,
                ),
                const SizedBox(height: 12),
                _buildFontSizeSelectorMobile(),
                const SizedBox(height: 32),
                _buildSectionTitle("Idioma y Región"),
                const SizedBox(height: 12),
                _buildLanguageTile(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 💻 DESKTOP LAYOUT (>= 900px)
  // ===========================================================================
  Widget _buildDesktopLayout() {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Desktop Header
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apariencia y Preferencias',
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                      Text(
                        'Personaliza tu experiencia visual en NaziShop',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Grid de Configuración Estilo Dashboard
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent:
                        240, // Increased height to prevent 4.4px overflow
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    // Card 1: Tema (Principal)
                    _buildDesktopCard(
                      title: "Tema de la Aplicación",
                      icon: Icons.palette_rounded,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildThemeOptionDesktop(ThemeMode.light,
                                    Icons.wb_sunny_rounded, "Claro"),
                                _buildThemeOptionDesktop(ThemeMode.dark,
                                    Icons.nights_stay_rounded, "Oscuro"),
                                _buildThemeOptionDesktop(ThemeMode.system,
                                    Icons.brightness_auto_rounded, "Auto"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Card 2: Accesibilidad
                    _buildDesktopCard(
                      title: "Accesibilidad",
                      icon: Icons.accessibility_new_rounded,
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          _buildSwitchRow("Animaciones", "Efectos visuales",
                              _animationsEnabled, (v) => _updateAnimations(v)),
                          const SizedBox(height: 12),
                          Divider(color: theme.alternate),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tamaño de texto",
                                  style: GoogleFonts.outfit(
                                      color: theme.secondaryText)),
                              _buildFontSizeToggle(),
                            ],
                          )
                        ],
                      ),
                    ),
                    // Card 3: Idioma (Placeholder)
                    _buildDesktopCard(
                      title: "Idioma",
                      icon: Icons.language_rounded,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.alternate),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("🇪🇸  Español",
                                  style: GoogleFonts.outfit(
                                      color: theme.primaryText, fontSize: 16)),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_drop_down,
                                  color: theme.secondaryText),
                            ],
                          ),
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
    );
  }

  // ===========================================================================
  // 🧩 WIDGETS COMPARTIDOS & LOGICA
  // ===========================================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        color: FlutterFlowTheme.of(context).primary,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildDesktopCard(
      {required String title, required IconData icon, required Widget child}) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.secondaryText, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: theme.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    ).animate().fadeIn().moveY(begin: 10, curve: Curves.easeOut);
  }

  // --- Theme Widgets ---

  Widget _buildThemeSelectorMobile() {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        children: [
          _buildThemeOptionMobile(
              ThemeMode.light, "Claro", Icons.wb_sunny_rounded),
          Divider(color: theme.alternate, height: 1),
          _buildThemeOptionMobile(
              ThemeMode.dark, "Oscuro", Icons.nights_stay_rounded),
          Divider(color: theme.alternate, height: 1),
          _buildThemeOptionMobile(
              ThemeMode.system, "Sistema", Icons.brightness_auto_rounded),
        ],
      ),
    );
  }

  Widget _buildThemeOptionMobile(ThemeMode mode, String title, IconData icon) {
    final isSelected = FlutterFlowTheme.themeMode == mode;
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: () async {
        FlutterFlowTheme.saveThemeMode(mode);
        if (mounted) {
          MyApp.of(context).setThemeMode(mode);
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? theme.primary : theme.secondaryText,
                size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  color: isSelected ? theme.primaryText : theme.secondaryText,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check, color: theme.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOptionDesktop(ThemeMode mode, IconData icon, String label) {
    final isSelected = FlutterFlowTheme.themeMode == mode;
    final theme = FlutterFlowTheme.of(context);
    final kPrimaryColor = theme.primary;
    return GestureDetector(
      onTap: () async {
        FlutterFlowTheme.saveThemeMode(mode);
        if (mounted) {
          MyApp.of(context).setThemeMode(mode);
          setState(() {});
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimaryColor.withValues(alpha: 0.1)
              : theme.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? kPrimaryColor : theme.alternate,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? theme.primaryText : theme.secondaryText,
                size: 28),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected ? theme.primaryText : theme.secondaryText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Accessibility Widgets ---

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration:
                BoxDecoration(color: theme.accent4, shape: BoxShape.circle),
            child: Icon(icon, color: theme.secondaryText, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.outfit(
                        color: theme.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: GoogleFonts.outfit(
                        color: theme.secondaryText, fontSize: 13)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: theme.primary,
            activeTrackColor: theme.primary.withValues(alpha: 0.3),
            inactiveTrackColor: theme.secondaryText.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    final theme = FlutterFlowTheme.of(context);
    final kPrimaryColor = theme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
                  GoogleFonts.outfit(color: theme.primaryText, fontSize: 15)),
          Text(subtitle,
              style:
                  GoogleFonts.outfit(color: theme.secondaryText, fontSize: 12)),
        ]),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: kPrimaryColor,
        ),
      ],
    );
  }

  // --- Font Size Logic ---

  Widget _buildFontSizeSelectorMobile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tamaño de texto",
              style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Row(
            children: [
              _fontSizeBtn("A", "Pequeño"),
              const SizedBox(width: 12),
              _fontSizeBtn("Aa", "Normal"),
              const SizedBox(width: 12),
              _fontSizeBtn("AAA", "Grande"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fontSizeBtn(String label, String valueKey) {
    final isSelected = _fontSize == valueKey;
    final theme = FlutterFlowTheme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: () => _updateFontSize(valueKey),
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? theme.primary : theme.alternate,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: isSelected ? theme.secondaryText : theme.primaryText,
              fontWeight: FontWeight.bold,
              fontSize:
                  valueKey == 'Pequeño' ? 12 : (valueKey == 'Grande' ? 20 : 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeToggle() {
    return Row(
      children: [
        _miniFontBtn("A-", "Pequeño"),
        const SizedBox(width: 8),
        _miniFontBtn("A", "Normal"),
        const SizedBox(width: 8),
        _miniFontBtn("A+", "Grande"),
      ],
    );
  }

  Widget _miniFontBtn(String text, String key) {
    final isSelected = _fontSize == key;
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: () => _updateFontSize(key),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : theme.alternate,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text,
            style: GoogleFonts.outfit(
                color: isSelected ? theme.secondaryText : theme.primaryText,
                fontSize: 12)),
      ),
    );
  }

  // --- Language ---

  Widget _buildLanguageTile() {
    final theme = FlutterFlowTheme.of(context);
    final kPrimaryColor = theme.primary;
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.alternate),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration:
              BoxDecoration(color: theme.accent4, shape: BoxShape.circle),
          child: Icon(Icons.language, color: theme.secondaryText, size: 18),
        ),
        title:
            Text("Idioma", style: GoogleFonts.outfit(color: theme.primaryText)),
        subtitle:
            Text(_language, style: GoogleFonts.outfit(color: kPrimaryColor)),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            color: theme.secondaryText, size: 14),
        onTap: () {
          // Placeholder for language logic
        },
      ),
    );
  }
}
