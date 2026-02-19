import '/index.dart';
import '/models/category_model.dart';
import '/models/service_model.dart';
import '/models/offer_model.dart';
import '/models/listing_model.dart';
import '/components/app_layout.dart';
import '/flutter_flow/nav/nav.dart';

import '/pages/user/profile/appearance/appearance_widget.dart';
import '/pages/admin/admin_auth_guard.dart';
import '/pages/error_page/error_page_widget.dart';
import '/pages/user/security/security_widget.dart';

class AppRoutes {
  // Public routes
  static const String home = '/';
  static const String allProducts = '/shop/products';
  static const String serviceDetail = '/shop/service';
  static const String categoryPage = '/shop/category';
  static const String checkout = '/checkout';
  static const String purchaseSuccess = '/purchase/success';
  static const String offers = '/shop/offers';
  static const String support = '/legal/support';
  static const String terms = '/legal/terms';
  static const String about = '/legal/about';
  static const String privacyPolicy = '/legal/privacy';

  // Auth routes
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String onboarding = '/onboarding';

  // User routes
  static const String profile = '/user/profile';
  static const String editProfile = '/user/profile/edit';
  static const String completeProfile = '/user/profile/complete';
  static const String myPurchases = '/user/purchases';
  static const String ordersHistory = '/user/orders';
  static const String favorites = '/user/favorites';
  static const String paymentMethodsUser = '/user/payment-methods';
  static const String notificationsUser = '/user/notifications';
  static const String security = '/user/security';
  static const String appearance = '/user/appearance';
  static const String viewGiftCode = '/user/credentials/gift-code';
  static const String viewStreamingCredentials = '/user/credentials/streaming';
  static const String viewCredentials = '/user/credentials/view';
  // Admin routes
  static const String admin = '/admin';
  static const String adminCategories = '/admin/categories';
  static const String createCategory = '/admin/categories/create';
  static const String adminServices = '/admin/services';
  static const String createService = '/admin/services/create';
  static const String adminListings = '/admin/listings';
  static const String createListing = '/admin/listings/create';
  static const String adminInventory = '/admin/inventory';
  static const String createInventory = '/admin/inventory/create';

  static const String adminPromotions = '/admin/promotions';
  static const String createPromotion = '/admin/promotions/create';
  static const String adminCoupons = '/admin/coupons';
  static const String createCoupon = '/admin/coupons/create';
  static const String adminNotifications = '/admin/notifications';
  static const String createNotification = '/admin/notifications/create';
  static const String adminAnalytics = '/admin/analytics';
  static const String ordersManagement = '/admin/orders';
  static const String usersManagement = '/admin/users';
  static const String adminConfig = '/admin/config';
  static const String currencyManagement = '/admin/currency';

  static GoRouter createRouter(AppStateNotifier appStateNotifier) {
    return GoRouter(
      initialLocation: home,
      refreshListenable: appStateNotifier,
      debugLogDiagnostics: false,
      redirect: (context, state) {
        final bool loggedIn = appStateNotifier.loggedIn;

        // Rutas públicas de autenticación (Login, Registro, Recuperar Password, Onboarding)
        final bool isAuthRoute = state.matchedLocation == login ||
            state.matchedLocation == register ||
            state.matchedLocation == forgotPassword ||
            state.matchedLocation == onboarding;

        // Rutas que NO se deben visitar si ya estás logueado (Login, Registro, Onboarding)
        // NOTA: Permitimos 'forgotPassword' incluso si estás logueado, por si quiere resetear.
        final bool isGuestOnlyRoute = state.matchedLocation == login ||
            state.matchedLocation == register ||
            state.matchedLocation == onboarding;

        // 1. Si NO está logueado y NO es una ruta de auth, redirigir a Login o Onboarding
        if (!loggedIn && !isAuthRoute) {
          return appStateNotifier.onboardingCompleted ? login : onboarding;
        }

        // 2. Si SÍ está logueado e intenta ver Login/Registro, redirigir a Home
        if (loggedIn && isGuestOnlyRoute) {
          return home;
        }

        return null;
      },
      routes: [
        // Rutas fuera del layout (Login, Registro, etc)
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const AuthLoginWidget(),
        ),
        GoRoute(
          path: register,
          name: 'register',
          builder: (context, state) => const AuthCreateWidget(),
        ),
        GoRoute(
          path: forgotPassword,
          name: 'auth_forgot_password',
          builder: (context, state) => const AuthForgotPasswordWidget(),
        ),
        GoRoute(
          path: onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingWidget(),
        ),

        // Rutas dentro del layout moderno (ShellRoute)
        ShellRoute(
          builder: (context, state, child) {
            return AppLayout(
              currentRoute: state.uri.toString(),
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: home,
              name: 'home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomePageWidget(),
              ),
            ),
            GoRoute(
              path: allProducts,
              name: 'all_products',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AllProductsWidget(),
              ),
            ),
            GoRoute(
              path: favorites,
              name: 'favorites',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: FavoritesWidget(),
              ),
            ),
            GoRoute(
              path: profile,
              name: 'profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfileWidget(),
              ),
            ),
            GoRoute(
              path: appearance,
              name: 'appearance',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AppearanceWidget(),
              ),
            ),
            GoRoute(
              path: myPurchases,
              name: 'my_purchases',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: MyPurchasesWidget(),
              ),
            ),
            GoRoute(
              path: ordersHistory,
              name: 'orders_history',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: MyPurchasesWidget(),
              ),
            ),
            GoRoute(
              path: paymentMethodsUser,
              name: 'payment_methods_user',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PaymentMethodsUserWidget(),
              ),
            ),
            GoRoute(
              path: notificationsUser,
              name: 'notifications_user',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: NotificationsUserWidget(),
              ),
            ),
            GoRoute(
              path: adminNotifications,
              name: 'admin_notifications',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: AdminNotificationsWidget()),
              ),
            ),
            GoRoute(
              path: adminPromotions,
              name: 'admin_promotions',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: AdminPromotionsWidget()),
              ),
            ),
            GoRoute(
              path: createPromotion,
              name: 'create_promotion',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: CreatePromotionWidget()),
              ),
            ),
            GoRoute(
              path: '$categoryPage/:categoryId',
              name: 'category_page',
              pageBuilder: (context, state) {
                final categoryId = state.pathParameters['categoryId'];
                if (state.extra is Category) {
                  return NoTransitionPage(
                      child: CategoryPage(category: state.extra as Category));
                }
                return NoTransitionPage(
                  child: CategoryPage(
                    category: _createMockCategory(categoryId ?? ''),
                  ),
                );
              },
            ),
            GoRoute(
              path: '$serviceDetail/:serviceId',
              name: 'service_detail',
              pageBuilder: (context, state) {
                final serviceId = state.pathParameters['serviceId'];
                if (state.extra is Service) {
                  return NoTransitionPage(
                      child:
                          ServiceDetailWidget(service: state.extra as Service));
                }
                return NoTransitionPage(
                  child: ServiceDetailWidget(
                      service: _createMockService(serviceId ?? '')),
                );
              },
            ),
            GoRoute(
              path: checkout,
              name: 'checkout',
              pageBuilder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return NoTransitionPage(
                  child: CheckoutWidget(
                    service: extra?['service'] as Service,
                    selectedListing: extra?['selectedListing'] as Listing,
                  ),
                );
              },
            ),
            GoRoute(
              path: purchaseSuccess,
              name: 'purchase_success',
              pageBuilder: (context, state) => NoTransitionPage(
                child: PurchaseSuccessWidget(
                  serviceName: state.uri.queryParameters['serviceName'],
                  orderId: state.uri.queryParameters['orderId'],
                ),
              ),
            ),
            GoRoute(
              path: offers,
              name: 'offers',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: OffersWidget(),
              ),
            ),
            GoRoute(
              path: editProfile,
              name: 'auth_edit_profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: EditProfileWidget(),
              ),
            ),
            GoRoute(
              path: security,
              name: 'security',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SecurityWidget(),
              ),
            ),
            GoRoute(
              path: completeProfile,
              name: 'complete_profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CompleteProfileWidget(),
              ),
            ),

            // View Credential Routes
            GoRoute(
              path: viewGiftCode,
              name: 'view_gift_code',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ViewGiftCodeWidget(
                  serviceName: state.uri.queryParameters['serviceName'] ?? '',
                  code: state.uri.queryParameters['code'] ?? '',
                  expiryDate: state.uri.queryParameters['expiryDate'],
                  instructions: state.uri.queryParameters['instructions'],
                ),
              ),
            ),
            GoRoute(
              path: viewStreamingCredentials,
              name: 'view_streaming_credentials',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ViewStreamingCredentialsWidget(
                  orderId: state.uri.queryParameters['orderId'],
                  serviceName: state.uri.queryParameters['serviceName'],
                  plan: state.uri.queryParameters['plan'],
                  email: state.uri.queryParameters['email'],
                  password: state.uri.queryParameters['password'],
                  pin: state.uri.queryParameters['pin'],
                  profiles: state.uri.queryParameters['profiles'],
                  expiryDate: state.uri.queryParameters['expiryDate'],
                ),
              ),
            ),
            GoRoute(
              path: viewCredentials,
              name: 'view_credentials',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ViewCredentialsWidget(
                  serviceName: state.uri.queryParameters['serviceName'],
                  email: state.uri.queryParameters['email'],
                  password: state.uri.queryParameters['password'],
                  pin: state.uri.queryParameters['pin'],
                  isStreaming:
                      state.uri.queryParameters['isStreaming'] == 'true',
                  orderId: state.uri.queryParameters['orderId'],
                ),
              ),
            ),

            // Admin Routes
            GoRoute(
              path: admin,
              name: 'admin',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: AdminWidget()),
              ),
            ),
            GoRoute(
              path: adminCategories,
              name: 'admin_categories',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: AdminCategoriesWidget()),
              ),
            ),
            GoRoute(
              path: adminServices,
              name: 'admin_services',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: AdminServicesWidget()),
              ),
            ),
            GoRoute(
              path: adminListings,
              name: 'admin_listings',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: AdminListingsWidget()),
              ),
            ),
            GoRoute(
              path: adminInventory,
              name: 'admin_inventory',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: AdminInventoryWidget()),
              ),
            ),

            GoRoute(
              path: createInventory,
              name: 'create_inventory',
              pageBuilder: (context, state) {
                final listingId = state.uri.queryParameters['listingId'];
                final listingTitle = state.uri.queryParameters['listingTitle'];
                return NoTransitionPage(
                  child: AdminAuthGuard(
                    child: CreateInventoryWidget(
                      listingId: (listingId == null || listingId.isEmpty)
                          ? null
                          : listingId,
                      listingTitle:
                          (listingTitle == null || listingTitle.isEmpty)
                              ? null
                              : listingTitle,
                    ),
                  ),
                );
              },
            ),
            GoRoute(
              path: adminCoupons,
              name: 'admin_coupons',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: AdminCouponsWidget()),
              ),
            ),
            GoRoute(
              path: createCoupon,
              name: 'create_coupon',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: CreateCouponWidget()),
              ),
            ),
            GoRoute(
              path: adminAnalytics,
              name: 'admin_analytics',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: AdminAnalyticsWidget()),
              ),
            ),
            GoRoute(
              path: ordersManagement,
              name: 'orders_management',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: OrdersManagementWidget()),
              ),
            ),
            GoRoute(
              path: usersManagement,
              name: 'users_management',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: UsersManagementWidget()),
              ),
            ),
            GoRoute(
              path: adminConfig,
              name: 'admin_config',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: AdminConfigWidget()),
              ),
            ),
            GoRoute(
              path: currencyManagement,
              name: 'currency_management',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: CurrencyManagementWidget()),
              ),
            ),
            GoRoute(
              path: createCategory,
              name: 'create_category',
              pageBuilder: (context, state) => NoTransitionPage(
                child: AdminAuthGuard(
                    child: CreateCategoryWidget(
                        category: state.extra as Category?)),
              ),
            ),
            GoRoute(
              path: createService,
              name: 'create_service',
              pageBuilder: (context, state) => NoTransitionPage(
                child: AdminAuthGuard(
                    child:
                        CreateServiceWidget(service: state.extra as Service?)),
              ),
            ),
            GoRoute(
              path: createListing,
              name: 'create_listing',
              pageBuilder: (context, state) => NoTransitionPage(
                child: AdminAuthGuard(
                    child: CreateListingWidget(offer: state.extra as Offer?)),
              ),
            ),
            GoRoute(
              path: createNotification,
              name: 'create_notification',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AdminAuthGuard(child: CreateNotificationWidget()),
              ),
            ),

            // Other Pages
            GoRoute(
              path: support,
              name: 'support',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SupportWidget(),
              ),
            ),
            GoRoute(
              path: terms,
              name: 'terms',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: TermsWidget(),
              ),
            ),
            GoRoute(
              path: about,
              name: 'about',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AboutWidget(),
              ),
            ),
            GoRoute(
              path: privacyPolicy,
              name: 'privacy_policy',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PrivacyPolicyWidget(),
              ),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) =>
          const ErrorPageWidget(type: ErrorType.notFound),
    );
  }

  // Métodos de utilidad para crear objetos mock
  static Category _createMockCategory(String id) {
    return Category(
      id: id,
      code: 'MOCK_${id.toUpperCase()}',
      name: 'Categoría $id',
      description: 'Descripción de la categoría $id',
      ui: CategoryUI(
        icon: 'category_icon',
        color: '#2196F3',
      ),
      isActive: true,
      services: [],
    );
  }

  static Service _createMockService(String id) {
    return Service(
      id: id,
      code: 'SRV_$id',
      name: 'Servicio $id',
      description: 'Descripción del servicio $id',
      categoryId: 'streaming',
      branding: ServiceBranding(
        primaryColor: '#000000',
        secondaryColor: '#ffffff',
      ),
      isActive: true,
      lowestPrice: 15.99,
    );
  }
}

// Página temporal para funcionalidades no implementadas
// _ComingSoonPage removed
