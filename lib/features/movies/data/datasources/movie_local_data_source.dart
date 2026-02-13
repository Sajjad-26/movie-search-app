import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/movie_model.dart';

/// Local data source for managing favorite movies.
/// Uses SharedPreferences for persistent key-value storage.
abstract class MovieLocalDataSource {
  /// Retrieve all favorite movies from local storage.
  Future<List<MovieModel>> getFavorites();

  /// Save a movie to favorites.
  Future<void> saveFavorite(MovieModel movie);

  /// Remove a movie from favorites by IMDB ID.
  Future<void> removeFavorite(String imdbId);

  /// Check if a movie is in favorites.
  Future<bool> isFavorite(String imdbId);
}

/// Implementation of [MovieLocalDataSource] using SharedPreferences.
class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final SharedPreferences sharedPreferences;

  /// Key used to store the favorites list in SharedPreferences.
  static const String _favoritesKey = 'FAVORITES_MOVIES';

  const MovieLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<MovieModel>> getFavorites() async {
    try {
      final jsonStringList = sharedPreferences.getStringList(_favoritesKey);
      if (jsonStringList == null || jsonStringList.isEmpty) {
        return [];
      }

      return jsonStringList
          .map((jsonString) => MovieModel.fromJson(json.decode(jsonString)))
          .toList();
    } catch (e) {
      throw CacheException('Failed to load favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> saveFavorite(MovieModel movie) async {
    try {
      final favorites = await getFavorites();

      // Avoid duplicates
      if (favorites.any((fav) => fav.imdbID == movie.imdbID)) {
        return;
      }

      final jsonStringList = sharedPreferences.getStringList(_favoritesKey) ?? [];
      jsonStringList.add(json.encode(movie.toJson()));
      await sharedPreferences.setStringList(_favoritesKey, jsonStringList);
    } catch (e) {
      throw CacheException('Failed to save favorite: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFavorite(String imdbId) async {
    try {
      final jsonStringList = sharedPreferences.getStringList(_favoritesKey) ?? [];
      jsonStringList.removeWhere((jsonString) {
        final map = json.decode(jsonString);
        return map['imdbID'] == imdbId;
      });
      await sharedPreferences.setStringList(_favoritesKey, jsonStringList);
    } catch (e) {
      throw CacheException('Failed to remove favorite: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(String imdbId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((movie) => movie.imdbID == imdbId);
    } catch (e) {
      return false;
    }
  }
}
