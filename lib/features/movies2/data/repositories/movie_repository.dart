import 'package:movietime/features/movies2/data/api/api_service.dart';
import 'package:movietime/features/movies2/domain/entities/movie.dart';

class MovieRepository {
  final ApiService _apiService = ApiService();

  Future<List<Movie>> getTrendingMovies() async {
    return await _apiService.getTrendingMovies();
  }

  Future<List<Movie>> getPopularMovies() async {
    return await _apiService.getPopularMovies();
  }

  Future<List<Movie>> searchMovies(String query) async {
    return await _apiService.searchMovies(query);
  }
}
