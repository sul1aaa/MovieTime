import 'package:flutter/material.dart';
import 'package:movietime/core/colors/colors.dart';
import 'package:movietime/features/auth/data/prefs/prefs_service.dart';

class SavedGenresScreen extends StatefulWidget {
  const SavedGenresScreen({super.key});

  @override
  State<SavedGenresScreen> createState() => _SavedGenresScreenState();
}

class _SavedGenresScreenState extends State<SavedGenresScreen> {
  final PreferencesService _prefsService = PreferencesService();
  List<String> _savedGenres = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedGenres();
  }

  Future<void> _loadSavedGenres() async {
    final genres = await _prefsService.getSelectedGenres();
    setState(() {
      _savedGenres = genres;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.text),
        ),
        title: const Text(
          'Your Favorite Genres',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _savedGenres.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.movie_filter_outlined,
                    size: 64,
                    color: AppColors.textGrey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No genres saved yet',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Complete onboarding to save your preferences',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You selected ${_savedGenres.length} genres',
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _savedGenres.map((genre) {
                      return Chip(
                        label: Text(genre),
                        backgroundColor: AppColors.primary,
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
