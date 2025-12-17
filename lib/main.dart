import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movietime/features/auth/auth_gate.dart';
import 'package:movietime/features/auth/data/prefs/prefs_service.dart';
import 'package:provider/provider.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/movies2/data/repositories/movie_repository.dart';
import 'features/movies2/presentation/providers/favourites_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize SharedPreferences
  await PreferencesService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MovieRepository>(create: (_) => MovieRepository()),
        ChangeNotifierProvider<FavoritesProvider>(
          create: (_) => FavoritesProvider(),
        ),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(FirebaseAuth.instance)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const AuthGate(),
      ),
    );
  }
}
