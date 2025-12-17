import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietime/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:movietime/features/auth/presentation/bloc/auth_event.dart';
import 'package:movietime/features/auth/presentation/bloc/auth_state.dart';
import 'package:movietime/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:movietime/features/auth/presentation/screens/onboarding_two_screen.dart';
import 'package:movietime/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:movietime/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:movietime/features/movies2/presentation/screens/home_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          if (state.hasCompletedOnboarding) {
            return const HomeScreen();
          }
          return const OnboardingTwoScreen();
        }

        if (state is AuthEmailNotVerified) {
          return const EmailVerificationScreen();
        }

        if (state is AuthUnauthenticated) {
          return const SignInScreen();
        }

        return const SignUpScreen();
      },
    );
  }
}
