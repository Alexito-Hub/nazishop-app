import 'package:flutter/material.dart';

/// A standard responsive wrapper for Nazi Shop that enforces the 900px breakpoint.
/// It simplifies the Mobile vs Desktop branch logic in pages.
class AppResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;

  /// Optional: If provided, will be used as the PreferredSizeWidget (AppBar) on mobile.
  /// Note: If your mobileBody is a CustomScrollView with slivers, leave this null.
  final PreferredSizeWidget? mobileAppBar;

  /// Optional: Shown only on mobile.
  final Widget? mobileFab;

  /// Optional: Background color for the mobile Scaffold.
  final Color? mobileBackgroundColor;

  const AppResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.desktopBody,
    this.mobileAppBar,
    this.mobileFab,
    this.mobileBackgroundColor,
  });

  /// The standard project breakpoint
  static const double breakpoint = 900.0;

  /// Utility to check if current width is desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= breakpoint;

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width >= breakpoint;

    if (desktop) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: desktopBody,
      );
    }

    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: mobileAppBar,
      body: mobileBody,
      floatingActionButton: mobileFab,
    );
  }
}
