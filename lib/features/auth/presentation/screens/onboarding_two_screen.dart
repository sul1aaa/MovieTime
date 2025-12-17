import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietime/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:movietime/features/auth/presentation/bloc/auth_event.dart';
import 'package:movietime/features/auth/presentation/bloc/auth_state.dart';
import 'package:movietime/features/movies2/presentation/screens/home_screen.dart';

class OnboardingTwoScreen extends StatefulWidget {
  const OnboardingTwoScreen({super.key});

  @override
  State<OnboardingTwoScreen> createState() => _OnboardingTwoScreenState();
}

class _OnboardingTwoScreenState extends State<OnboardingTwoScreen> {
  final List<String> genres = [
    "Action",
    "Adventure",
    "Drama",
    "Comedy",
    "Crime",
    "Documentary",
    "Sports",
    "Fantasy",
    "Horror",
    "Music",
    "Western",
    "Thriller",
    "Sci-fi",
  ];

  final Set<String> selectedGenres = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121011),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated && state.hasCompletedOnboarding) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (_) => false,
                );
              }
            },
            child: Column(
              children: [
                const SizedBox(height: 80),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: genres.map((genre) {
                    final isSelected = selectedGenres.contains(genre);

                    return ChoiceChip(
                      label: Text(genre),
                      selected: isSelected,
                      selectedColor: Colors.red,
                      backgroundColor: const Color(0xFF1E1E1E),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                      onSelected: (_) {
                        setState(() {
                          isSelected
                              ? selectedGenres.remove(genre)
                              : selectedGenres.add(genre);
                        });
                      },
                    );
                  }).toList(),
                ),
                const Spacer(),
                const Text(
                  "Select the genres you\nlike to watch",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        CompleteOnboarding(
                          selectedGenres: selectedGenres.toList(),
                        ),
                      );
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
