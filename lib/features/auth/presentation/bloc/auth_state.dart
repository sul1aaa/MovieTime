abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String uid;
  final String email;
  final String name;
  final String surname;
  final String phone;
  final bool hasCompletedOnboarding;

  AuthAuthenticated({
    required this.uid,
    required this.email,
    required this.name,
    required this.surname,
    required this.phone,
    this.hasCompletedOnboarding = false,
  });
}

class AuthUnauthenticated extends AuthState {}

class AuthEmailNotVerified extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
