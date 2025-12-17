import 'package:dio/dio.dart';
import 'package:movietime/core/constants/constants.dart';
import 'package:movietime/features/movies2/data/models/movie_model.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        queryParameters: {'api_key': AppConstants.apiKey},
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      final response = await _dio.get(AppConstants.trending);

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trending movies');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await _dio.get(AppConstants.popular);

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load popular movies');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await _dio.get(
        AppConstants.search,
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search movies');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'Something went wrong: ${error.message}';
    }
  }
}
