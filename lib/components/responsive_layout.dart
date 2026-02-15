import 'package:flutter/material.dart';

/// Widget para manejar layouts responsive de forma consistente
class ResponsiveLayout extends StatelessWidget {
  final Widget? mobileLayout;
  final Widget? tabletLayout;
  final Widget? desktopLayout;
  final double mobileMaxWidth;
  final double tabletMaxWidth;

  const ResponsiveLayout({
    super.key,
    this.mobileLayout,
    this.tabletLayout,
    this.desktopLayout,
    this.mobileMaxWidth = 600,
    this.tabletMaxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width > tabletMaxWidth && desktopLayout != null) {
          return desktopLayout!;
        } else if (width > mobileMaxWidth && tabletLayout != null) {
          return tabletLayout!;
        } else {
          return mobileLayout ?? Container();
        }
      },
    );
  }
}

/// Extension para obtener información responsive del contexto
extension ResponsiveContext on BuildContext {
  bool get isMobile {
    final width = MediaQuery.of(this).size.width;
    return width <= 600;
  }

  bool get isTablet {
    final width = MediaQuery.of(this).size.width;
    return width > 600 && width <= 1200;
  }

  bool get isDesktop {
    final width = MediaQuery.of(this).size.width;
    return width > 1200;
  }

  int get crossAxisCount {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }

  double get cardAspectRatio {
    if (isDesktop) return 1.0;
    if (isTablet) return 0.9;
    return 0.85;
  }
}

/// Widget base para páginas con layout responsive estándar
class ResponsivePage extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBottomNav;
  final int currentIndex;
  final ValueChanged<int>? onBottomNavTap;

  const ResponsivePage({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBottomNav = false,
    this.currentIndex = 0,
    this.onBottomNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNav ? _buildBottomNavBar(context) : null,
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Compras',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
