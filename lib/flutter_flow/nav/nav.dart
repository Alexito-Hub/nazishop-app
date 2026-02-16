import 'dart:async';

import 'package:flutter/material.dart';
import '/auth/base_auth_user_provider.dart';
import '/index.dart';
// import '/main.dart';
// import '/flutter_flow/flutter_flow_theme.dart';

import '../../components/app_layout.dart';
import '../../models/category_model.dart';
import '/flutter_flow/flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched
  /// while the user is already signed in.
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;

  bool onboardingCompleted = false;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }

  void completeOnboarding() {
    onboardingCompleted = true;
    notifyListeners();
  }

  void update(BaseAuthUser newUser) {
    final shouldUpdate = user?.uid == null ||
        newUser.uid != user?.uid ||
        newUser.loggedIn != user?.loggedIn;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly suppressed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
  }

  void setRedirectLocationIfUnset(String loc) {
    _redirectLocation ??= loc;
  }

  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String? getRedirectLocation() {
    final loc = _redirectLocation;
    _redirectLocation = null;
    return loc;
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => appStateNotifier.loggedIn
          ? const HomePageModernWidget()
          : const AuthLoginWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ).toRoute(appStateNotifier),

        FFRoute(
          name: 'auth_login',
          path: '/authLogin',
          builder: (context, params) => const AuthLoginWidget(),
        ).toRoute(appStateNotifier),
        FFRoute(
          name: 'auth_create',
          path: '/authCreate',
          builder: (context, params) => const AuthCreateWidget(),
        ).toRoute(appStateNotifier),
        FFRoute(
          name: 'auth_forgot_password',
          path: '/authForgotPassword',
          builder: (context, params) => const AuthForgotPasswordWidget(),
        ).toRoute(appStateNotifier),
        FFRoute(
          name: 'onboarding',
          path: '/onboarding',
          builder: (context, params) => const OnboardingWidget(),
        ).toRoute(appStateNotifier),

        // ShellRoute for Static Sidebar Layout
        ShellRoute(
          builder: (context, state, child) {
            // AppLayout ahora actúa como wrapper
            return AppLayout(currentRoute: state.uri.toString(), child: child);
          },
          routes: [
            FFRoute(
              name: 'home',
              path: '/home',
              builder: (context, params) => const HomePageModernWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'category_page',
              path: '/category/:name',
              builder: (context, params) {
                final category = params.state.extra as Category?;
                if (category == null) {
                  return const HomePageModernWidget();
                }
                return CategoryPage(category: category);
              },
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'complete_profile',
              path: '/completeProfile',
              builder: (context, params) => const CompleteProfileWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'auth_edit_profile',
              path: '/authEditProfile',
              builder: (context, params) => const AuthEditProfileWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'payment_methods_user',
              path: '/paymentMethodsUser',
              builder: (context, params) => const PaymentMethodsUserWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'my_purchases',
              path: '/myPurchases',
              builder: (context, params) => const MyPurchasesModernWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'orders_history',
              path: '/orders-history',
              builder: (context, params) => const OrdersHistoryWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'favorites',
              path: '/favorites',
              builder: (context, params) => const FavoritesModernWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'profile',
              path: '/profile',
              builder: (context, params) => const ProfileModernWidget(),
            ).toRoute(appStateNotifier),

            // ADMIN ROUTES
            FFRoute(
              name: 'admin',
              path: '/admin',
              builder: (context, params) => const AdminWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'admin_categories',
              path: '/admin/categories',
              builder: (context, params) => const AdminCategoriesPage(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'admin_services',
              path: '/admin/services',
              builder: (context, params) => const AdminServicesPage(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'admin_listings',
              path: '/admin/listings',
              builder: (context, params) => const AdminOffersPage(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'admin_coupons',
              path: '/admin/coupons',
              builder: (context, params) => const AdminCouponsPage(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'admin_analytics',
              path: '/admin/analytics',
              builder: (context, params) => const AdminAnalyticsPage(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'admin_config',
              path: '/admin/config',
              builder: (context, params) => const AdminConfigPage(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'about',
              path: '/about',
              builder: (context, params) => const AboutWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'support',
              path: '/support',
              builder: (context, params) => const SupportWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'terms',
              path: '/terms',
              builder: (context, params) => const TermsWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'offers',
              path: '/offers',
              builder: (context, params) => const OffersWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'notifications_user',
              path: '/notificationsUser',
              builder: (context, params) => const NotificationsUserWidget(),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'view_gift_code',
              path: '/viewGiftCode',
              builder: (context, params) => ViewGiftCodeWidget(
                serviceName: params.getParam('serviceName')!,
                code: params.getParam('code')!,
                expiryDate: params.getParam('expiryDate'),
                instructions: params.getParam('instructions'),
              ),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'view_streaming_credentials',
              path: '/viewStreamingCredentials',
              builder: (context, params) => ViewStreamingCredentialsWidget(
                orderId: params.getParam('orderId'),
                serviceName: params.getParam('serviceName'),
                plan: params.getParam('plan'),
                email: params.getParam('email'),
                password: params.getParam('password'),
                pin: params.getParam('pin'),
                profiles: params.getParam('profiles'),
                expiryDate: params.getParam('expiryDate'),
              ),
            ).toRoute(appStateNotifier),
            FFRoute(
              name: 'view_credentials',
              path: '/viewCredentials',
              builder: (context, params) => ViewCredentialsWidget(
                serviceName: params.getParam('serviceName')!,
                email: params.getParam('email')!,
                password: params.getParam('password')!,
                pin: params.getParam('pin'),
                isStreaming: params.getParam('isStreaming') == 'true',
              ),
            ).toRoute(appStateNotifier),
          ],
        ),
      ],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) {
    final context = this;
    if (mounted) {
      if (ignoreRedirect) {
        context.pushNamed(name,
            pathParameters: pathParameters,
            queryParameters: queryParameters,
            extra: extra);
      } else {
        context.goNamed(name,
            pathParameters: pathParameters,
            queryParameters: queryParameters,
            extra: extra);
      }
    }
  }

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) {
    final context = this;
    if (mounted) {
      if (ignoreRedirect) {
        context.pushNamed(name,
            pathParameters: pathParameters,
            queryParameters: queryParameters,
            extra: extra);
      } else {
        context.pushNamed(name,
            pathParameters: pathParameters,
            queryParameters: queryParameters,
            extra: extra);
      }
    }
  }

  void safePop() {
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            return redirectLocation;
          }

          if (name == '_initialize') {
            return appStateNotifier.loggedIn ? '/home' : '/onboarding';
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/authLogin';
          }
          return null;
        },
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = builder(context, ffParams);

          // Handle both transition formats for compatibility
          TransitionInfo? transitionInfo;
          PageTransitionType? transition;

          if (state.extra is TransitionInfo) {
            transitionInfo = state.extra as TransitionInfo;
            transition = transitionInfo.transitionType;
          } else if (state.extra is Map<String, dynamic>) {
            final extraMap = state.extra as Map<String, dynamic>;
            transitionInfo = extraMap[kTransitionInfoKey] as TransitionInfo?;
            transition = transitionInfo?.transitionType;
          }

          if (transition != null) {
            // Custom transitions can be handled here
          }

          return MaterialPage(key: state.pageKey, child: page);
        },
        routes: routes,
      );
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters helper methods
  bool has(String name) =>
      state.pathParameters.containsKey(name) ||
      state.uri.queryParameters.containsKey(name);

  String? getParam(String name) =>
      state.pathParameters[name] ?? state.uri.queryParameters[name];

  // Basic serialization helpers can be added here
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() =>
      const TransitionInfo(hasTransition: false);
}
