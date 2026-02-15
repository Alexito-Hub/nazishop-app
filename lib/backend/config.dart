/// Backend Configuration
/// Centraliza todas las URLs y constantes del backend
library;

class BackendConfig {
  // Base URL del servidor
  static String get baseUrl {
    return 'https://api.naziventas.shop';

    /*
    if (kReleaseMode) return 'https://api.auralixpe.xyz';

    // Para Android físico con cable USB, se requiere ejecutar:
    // adb reverse tcp:8080 tcp:8080
    // Esto permite usar 'localhost' tanto en emulador como en físico.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://localhost:8080';
    }

    return 'http://localhost:8080';
    */
  }

  // Endpoints

  // WebSocket endpoint (para subscriptions GraphQL en el futuro)
  static String get wsEndpoint =>
      '${baseUrl.replaceFirst('http', 'ws')}/hybrid';

  // Timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 15);

  // Configuración de autenticación
  static const String tokenStorageKey = 'nazishop_auth_token';
  static const String userStorageKey = 'nazishop_user_data';

  // Headers comunes
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Validación de URL según ambiente
  static bool get isProduction => baseUrl.contains('https://');
  static bool get isDevelopment => !isProduction;

  // URLs de configuración según ambiente
  static String getUrl(String environment) {
    switch (environment.toLowerCase()) {
      case 'production':
        return 'https://api.auralixpe.xyz'; // URL de producción
      case 'staging':
        return 'https://staging-api.auralixpe.xyz'; // URL de staging
      case 'development':
      default:
        return baseUrl; // URL dinámica según plataforma
    }
  }
}
