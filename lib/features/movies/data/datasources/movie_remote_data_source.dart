import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/movie_model.dart';
import '../models/movie_detail_model.dart';

/// Remote data source for the OMDB API.
/// Handles all HTTP requests via Dio.
abstract class MovieRemoteDataSource {
  /// Searches movies by query string.
  /// Returns a list of [MovieModel] on success.
  /// Throws [ServerException] or [NetworkException] on failure.
  Future<List<MovieModel>> searchMovies(String query);

  /// Fetches movie detail by IMDB ID.
  /// Returns a [MovieDetailModel] on success.
  Future<MovieDetailModel> getMovieDetail(String imdbId);

  /// Fetches details for a curated list of trending movie IMDB IDs.
  /// Returns a list of [MovieDetailModel].
  Future<List<MovieDetailModel>> getTrendingMovies();

  /// Fetches movie details for an arbitrary list of IMDB IDs.
  /// Used for genre section loading.
  Future<List<MovieDetailModel>> getMoviesByIds(List<String> imdbIds);
}

/// Implementation of [MovieRemoteDataSource] using Dio HTTP client.
class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  const MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          's': query,
          'apikey': ApiConstants.apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // OMDB returns {"Response": "False", "Error": "..."} on failure
        if (data['Response'] == 'False') {
          final error = data['Error'] ?? 'Unknown error';
          if (error.contains('limit')) {
            throw const RateLimitException();
          }
          // "Movie not found!" or "Too many results" — return empty list
          return [];
        }

        // Parse the "Search" array into MovieModel list
        final List<dynamic> searchResults = data['Search'] ?? [];
        return searchResults.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw ServerException('Server returned status ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException();
      }
      throw ServerException(e.message ?? 'Network request failed');
    }
  }

  @override
  Future<MovieDetailModel> getMovieDetail(String imdbId) async {
    try {
      final response = await dio.get(
        ApiConstants.baseUrl,
        queryParameters: {
          'i': imdbId,
          'apikey': ApiConstants.apiKey,
          'plot': 'full',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['Response'] == 'False') {
          final error = data['Error'] ?? 'Unknown error';
          if (error.contains('limit')) {
            throw const RateLimitException();
          }
          throw ServerException(error);
        }

        return MovieDetailModel.fromJson(data);
      } else {
        throw ServerException('Server returned status ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException();
      }
      throw ServerException(e.message ?? 'Network request failed');
    }
  }

  @override
  Future<List<MovieDetailModel>> getTrendingMovies() async {
    try {
      // Fetch all trending movie details concurrently
      final futures = ApiConstants.trendingImdbIds.map((id) async {
        try {
          return await getMovieDetail(id);
        } catch (_) {
          // Skip individual failures — don't let one bad ID break the carousel
          return null;
        }
      });

      final results = await Future.wait(futures);
      return results.whereType<MovieDetailModel>().toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException();
      }
      throw ServerException(e.message ?? 'Network request failed');
    }
  }

  @override
  Future<List<MovieDetailModel>> getMoviesByIds(List<String> imdbIds) async {
    try {
      final futures = imdbIds.map((id) async {
        try {
          return await getMovieDetail(id);
        } catch (_) {
          return null;
        }
      });

      final results = await Future.wait(futures);
      return results.whereType<MovieDetailModel>().toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException();
      }
      throw ServerException(e.message ?? 'Network request failed');
    }
  }
}
