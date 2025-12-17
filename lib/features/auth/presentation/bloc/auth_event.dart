abstract class AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String surname;
  final String email;
  final String phone;
  final String password;

  SignUpRequested({
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.password,
  });
}

class ReloadUserRequested extends AuthEvent {}

class SendEmailVerificationRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class UpdateNameRequested extends AuthEvent {
  final String name;
  final String surname;

  UpdateNameRequested({required this.name, required this.surname});
}

class CheckAuthStatus extends AuthEvent {}

class CompleteOnboarding extends AuthEvent {
  final List<String> selectedGenres;

  CompleteOnboarding({required this.selectedGenres});
}
