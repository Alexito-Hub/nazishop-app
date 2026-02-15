class SecurityManager {
  static final SecurityManager _instance = SecurityManager._internal();
  factory SecurityManager() => _instance;
  SecurityManager._internal();

  DateTime? _lastVerificationTime;

  // Duración de la "Sesión Segura" antes de volver a pedir OTP (e.g. 15 minutos)
  static const Duration _sessionDuration = Duration(minutes: 15);

  bool get isSessionValid {
    if (_lastVerificationTime == null) return false;
    final difference = DateTime.now().difference(_lastVerificationTime!);
    return difference < _sessionDuration;
  }

  void recordVerification() {
    _lastVerificationTime = DateTime.now();
  }

  void invalidateSession() {
    _lastVerificationTime = null;
  }
}
