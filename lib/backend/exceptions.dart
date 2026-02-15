/// Excepciones personalizadas para el backend de NaziShop
library;

/// Excepción base para errores del backend
class BackendException implements Exception {
  final String message;
  final String? code;

  BackendException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Excepción de GraphQL con detalles del error
class GraphQLException extends BackendException {
  GraphQLException({
    required String message,
    String? code,
  }) : super(message, code: code);
}

/// Excepción de autenticación (401)
class AuthenticationException extends BackendException {
  AuthenticationException(super.message) : super(code: 'UNAUTHENTICATED');
}

/// Excepción de autorización (403)
class AuthorizationException extends BackendException {
  AuthorizationException(super.message) : super(code: 'UNAUTHORIZED');
}

/// Excepción del servidor (5xx)
class ServerException extends BackendException {
  ServerException(super.message) : super(code: 'SERVER_ERROR');
}

/// Excepción HTTP genérica
class HttpException extends BackendException {
  final int statusCode;

  HttpException(super.message, this.statusCode) : super(code: 'HTTP_ERROR');
}

/// Excepción de red/conexión
class NetworkException extends BackendException {
  NetworkException(super.message) : super(code: 'NETWORK_ERROR');
}

/// Excepción de validación
class ValidationException extends BackendException {
  final Map<String, String>? fieldErrors;

  ValidationException(super.message, {this.fieldErrors})
      : super(code: 'VALIDATION_ERROR');
}
