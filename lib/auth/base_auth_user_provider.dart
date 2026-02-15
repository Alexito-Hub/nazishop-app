class AuthUserInfo {
  const AuthUserInfo({
    this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
  });

  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
}

abstract class BaseAuthUser {
  bool get loggedIn;
  bool get emailVerified;

  AuthUserInfo get authUserInfo;

  Future? delete();
  Future? updateEmail(String email);
  Future? updatePassword(String newPassword);
  Future? sendEmailVerification();
  Future refreshUser() async {}

  String? get uid => authUserInfo.uid;
  String? get email => authUserInfo.email;
  String? get displayName => authUserInfo.displayName;
  String? get photoUrl => authUserInfo.photoUrl;
  String? get phoneNumber => authUserInfo.phoneNumber;

  // Role-based access methods (to be overridden by implementations)
  String get role => 'customer';
  bool get isSuperAdmin => false;
  bool get isAdmin => false;
  bool get isCustomer => loggedIn;
  String get roleDisplayName => 'Usuario';
}

BaseAuthUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
