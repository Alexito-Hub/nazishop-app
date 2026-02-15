import 'package:flutter/material.dart';

import 'backend/firebase/firebase_config.dart';
import 'backend/currency_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'auth/base_auth_user_provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'index.dart';
import 'backend/stripe_service.dart';
import 'backend/notification_service.dart';
import 'app_routes.dart';

// Implementación simple de BaseAuthUser para compatibilidad con AppStateNotifier
class SimpleAuthUser extends BaseAuthUser {
  final String _uid;
  final bool _loggedIn;

  SimpleAuthUser({required String uid, required bool loggedIn})
      : _uid = uid,
        _loggedIn = loggedIn;

  @override
  bool get loggedIn => _loggedIn;

  @override
  bool get emailVerified => true;

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(uid: _uid);

  @override
  Future? delete() => null;

  @override
  Future? updateEmail(String email) => null;

  @override
  Future? updatePassword(String newPassword) => null;

  @override
  Future? sendEmailVerification() => null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  await FlutterFlowTheme.initialize();

  try {
    await initFirebase();
    // Initialize currency service after Firebase
    await CurrencyService.initialize();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NaziShopAuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  Locale? _locale;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatchBase? routeMatch]) {
    final RouteMatchBase lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = AppRoutes.createRouter(_appStateNotifier);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeApp());
  }

  Future<void> _initializeApp() async {
    debugPrint('[Bootstrap] initialize start');
    if (!mounted) return;

    final authProvider = context.read<NaziShopAuthProvider>();

    // Sincronizar auth_util con el provider
    authProvider.addListener(() {
      setCurrentUser(authProvider.currentUser);
      _appStateNotifier.update(authProvider.isLoggedIn
          ? SimpleAuthUser(
              uid: authProvider.currentUser?.id ?? '', loggedIn: true)
          : SimpleAuthUser(uid: '', loggedIn: false));
    });
    try {
      await Future.wait([
        _restoreSession(),
        Future.delayed(const Duration(milliseconds: 1000)),
      ]).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint(
              '[Bootstrap] Timeout during initialization, continuing anyway');
          return [];
        },
      );
    } catch (e) {
      debugPrint('[Bootstrap] Error during initialization: $e');
    }

    try {
      await StripeService.init();
    } catch (e) {
      // Stripe not available or error - non-critical for startup
    }

    if (mounted) {
      _appStateNotifier.stopShowingSplashImage();
    }
  }

  Future<void> _restoreSession() async {
    if (!mounted) {
      return;
    }

    final authProvider = context.read<NaziShopAuthProvider>();
    try {
      debugPrint('[Bootstrap] restoreSession start');
      await authProvider.restoreSession().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint(
              '[Bootstrap] restoreSession timeout, continuing without session');
          return false;
        },
      );
      debugPrint(
          '[Bootstrap] restoreSession completed. loggedIn=${authProvider.isLoggedIn}');

      // Sincronizar estado inicial
      setCurrentUser(authProvider.currentUser);

      if (authProvider.isLoggedIn) {
        // Inicializar notificaciones
        await NotificationService.init();
      }
    } catch (e) {
      debugPrint('Error restoring session: $e');
    }

    if (!mounted) {
      return;
    }

    debugPrint('[Bootstrap] updating AppStateNotifier user');
    _appStateNotifier.update(authProvider.isLoggedIn
        ? SimpleAuthUser(
            uid: authProvider.currentUser?.id ?? '', loggedIn: true)
        : SimpleAuthUser(uid: '', loggedIn: false));
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) {
    FlutterFlowTheme.saveThemeMode(mode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Nazi Shop',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('es'),
      ],
      themeMode: FlutterFlowTheme.themeMode,
      routerConfig: _router,
    );
  }
}
