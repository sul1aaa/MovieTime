import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';

class FavoritesProvider extends ChangeNotifier {
  final Map<int, Movie> _favoriteMovies = {};

  List<int> get favoriteIds => _favoriteMovies.keys.toList();
  List<Movie> get favoriteMovies => _favoriteMovies.values.toList();

  void toggleFavorite(int movieId, {Movie? movie}) {
    if (_favoriteMovies.containsKey(movieId)) {
      _favoriteMovies.remove(movieId);
    } else {
      if (movie != null) {
        _favoriteMovies[movieId] = movie;
      }
    }
    notifyListeners();
  }

  bool isFavorite(int movieId) {
    return _favoriteMovies.containsKey(movieId);
  }
}
