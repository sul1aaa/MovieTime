import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietime/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:movietime/features/auth/presentation/bloc/auth_event.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.read<AuthBloc>().add(ReloadUserRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEB2F3D),
      child: Center(
        child: Image.asset('assets/images/splash.png', width: 150, height: 150),
      ),
    );
  }
}
