import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietime/features/auth/data/prefs/prefs_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth auth;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final PreferencesService _prefsService = PreferencesService();

  AuthBloc(this.auth) : super(AuthInitial()) {
    on<SignInRequested>(_onSignIn);
    on<SignUpRequested>(_onSignUp);
    on<ReloadUserRequested>(_onReload);
    on<SendEmailVerificationRequested>(_onSendVerification);
    on<SignOutRequested>(_onSignOut);
    on<UpdateNameRequested>(_onUpdateName);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<CompleteOnboarding>(_onCompleteOnboarding);
  }

  Future<void> _onSignIn(SignInRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final cred = await auth.signInWithEmailAndPassword(
        email: e.email,
        password: e.password,
      );

      final user = cred.user;

      if (user == null) {
        emit(AuthUnauthenticated());
        return;
      }

      if (!user.emailVerified) {
        emit(AuthEmailNotVerified());
        return;
      }

      final doc = await db.collection('users').doc(user.uid).get();
      final data = doc.data();

      if (data == null) {
        emit(AuthError('User data not found'));
        return;
      }

      // Save user data to SharedPreferences
      await _prefsService.saveUserData(
        name: data['name'] ?? '',
        surname: data['surname'] ?? '',
        email: user.email!,
        phone: data['phone'] ?? '',
      );

      // Save onboarding status and genres
      final hasCompletedOnboarding = data['hasCompletedOnboarding'] ?? true;
      await _prefsService.setOnboardingCompleted(hasCompletedOnboarding);

      if (data['selectedGenres'] != null) {
        final genres = List<String>.from(data['selectedGenres']);
        await _prefsService.saveSelectedGenres(genres);
      }

      emit(
        AuthAuthenticated(
          uid: user.uid,
          email: user.email!,
          name: data['name'] ?? '',
          surname: data['surname'] ?? '',
          phone: data['phone'] ?? '',
          hasCompletedOnboarding: hasCompletedOnboarding,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Sign in failed"));
    } catch (e) {
      debugPrint('Sign in error: $e');
      emit(AuthError('Sign in failed: $e'));
    }
  }

  Future<void> _onSignUp(SignUpRequested e, Emitter<AuthState> emit) async {
    emit(AuthEmailNotVerified());

    try {
      final cred = await auth.createUserWithEmailAndPassword(
        email: e.email,
        password: e.password,
      );

      final user = cred.user!;
      await user.sendEmailVerification();

      await db.collection('users').doc(user.uid).set({
        'email': e.email,
        'name': e.name,
        'surname': e.surname,
        'phone': e.phone,
        'hasCompletedOnboarding': false,
        'createdAt': Timestamp.now(),
      });
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Sign up failed"));
    }
  }

  Future<void> _onReload(ReloadUserRequested e, Emitter<AuthState> emit) async {
    final user = auth.currentUser;

    if (user == null) return;

    await user.reload();

    final refreshedUser = auth.currentUser;

    debugPrint('EMAIL VERIFIED: ${refreshedUser?.emailVerified}');

    if (refreshedUser != null && refreshedUser.emailVerified) {
      final doc = await db.collection('users').doc(refreshedUser.uid).get();

      final data = doc.data();

      if (data == null) {
        emit(AuthError('User data not found'));
        return;
      }

      // Save to SharedPreferences
      await _prefsService.saveUserData(
        name: data['name'] ?? '',
        surname: data['surname'] ?? '',
        email: refreshedUser.email!,
        phone: data['phone'] ?? '',
      );

      final hasCompletedOnboarding = data['hasCompletedOnboarding'] ?? false;
      await _prefsService.setOnboardingCompleted(hasCompletedOnboarding);

      emit(
        AuthAuthenticated(
          uid: refreshedUser.uid,
          email: refreshedUser.email!,
          name: data['name'] ?? '',
          surname: data['surname'] ?? '',
          phone: data['phone'] ?? '',
          hasCompletedOnboarding: hasCompletedOnboarding,
        ),
      );
    }
  }

  Future<void> _onSendVerification(_, emit) async {
    await auth.currentUser?.sendEmailVerification();
  }

  Future<void> _onSignOut(_, emit) async {
    await auth.signOut();
    await _prefsService.clearAll(); // Clear all saved preferences
    emit(AuthUnauthenticated());
  }

  Future<void> _onUpdateName(
    UpdateNameRequested e,
    Emitter<AuthState> emit,
  ) async {
    final user = auth.currentUser;

    if (user == null || state is! AuthAuthenticated) {
      return;
    }

    try {
      // Update Firestore
      await db.collection('users').doc(user.uid).update({
        'name': e.name,
        'surname': e.surname,
      });

      // Update SharedPreferences
      final currentState = state as AuthAuthenticated;
      await _prefsService.saveUserData(
        name: e.name,
        surname: e.surname,
        email: currentState.email,
        phone: currentState.phone,
      );

      // Update state
      emit(
        AuthAuthenticated(
          uid: currentState.uid,
          email: currentState.email,
          name: e.name,
          surname: e.surname,
          phone: currentState.phone,
          hasCompletedOnboarding: currentState.hasCompletedOnboarding,
        ),
      );
    } catch (error) {
      debugPrint('Error updating name: $error');
      emit(AuthError('Failed to update name'));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus e,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = auth.currentUser;

      if (user == null) {
        emit(AuthUnauthenticated());
        return;
      }

      // Reload user to get latest email verification status
      await user.reload();
      final refreshedUser = auth.currentUser;

      if (refreshedUser == null) {
        emit(AuthUnauthenticated());
        return;
      }

      if (!refreshedUser.emailVerified) {
        emit(AuthEmailNotVerified());
        return;
      }

      final doc = await db.collection('users').doc(refreshedUser.uid).get();
      final data = doc.data();

      if (data == null) {
        emit(AuthUnauthenticated());
        return;
      }

      // Save to SharedPreferences
      await _prefsService.saveUserData(
        name: data['name'] ?? '',
        surname: data['surname'] ?? '',
        email: refreshedUser.email!,
        phone: data['phone'] ?? '',
      );

      final hasCompletedOnboarding = data['hasCompletedOnboarding'] ?? true;
      await _prefsService.setOnboardingCompleted(hasCompletedOnboarding);

      if (data['selectedGenres'] != null) {
        final genres = List<String>.from(data['selectedGenres']);
        await _prefsService.saveSelectedGenres(genres);
      }

      emit(
        AuthAuthenticated(
          uid: refreshedUser.uid,
          email: refreshedUser.email!,
          name: data['name'] ?? '',
          surname: data['surname'] ?? '',
          phone: data['phone'] ?? '',
          hasCompletedOnboarding: hasCompletedOnboarding,
        ),
      );
    } catch (error) {
      debugPrint('Error checking auth status: $error');
      emit(AuthError('Error checking auth status: $error'));
    }
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboarding e,
    Emitter<AuthState> emit,
  ) async {
    final user = auth.currentUser;

    if (user == null || state is! AuthAuthenticated) {
      return;
    }

    try {
      // Update Firestore
      await db.collection('users').doc(user.uid).update({
        'hasCompletedOnboarding': true,
        'selectedGenres': e.selectedGenres,
      });

      // Save to SharedPreferences
      await _prefsService.setOnboardingCompleted(true);
      await _prefsService.saveSelectedGenres(e.selectedGenres);

      // Update state
      final currentState = state as AuthAuthenticated;
      emit(
        AuthAuthenticated(
          uid: currentState.uid,
          email: currentState.email,
          name: currentState.name,
          surname: currentState.surname,
          phone: currentState.phone,
          hasCompletedOnboarding: true,
        ),
      );
    } catch (error) {
      debugPrint('Error completing onboarding: $error');
      emit(AuthError('Failed to complete onboarding'));
    }
  }
}
