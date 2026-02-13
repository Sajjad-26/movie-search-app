import '../entities/movie.dart';
import '../entities/movie_detail.dart';

/// Abstract repository contract for movie operations.
/// Defined in the domain layer — implemented in the data layer.
/// This ensures the domain layer has no dependency on external packages.
abstract class MovieRepository {
  /// Search movies by query string.
  /// Returns a list of [Movie] entities on success.
  /// Throws [Failure] on error.
  Future<List<Movie>> searchMovies(String query);

  /// Fetch detailed information for a movie by its IMDB ID.
  /// Returns a [MovieDetail] entity on success.
  Future<MovieDetail> getMovieDetail(String imdbId);

  /// Retrieve all movies saved as favorites from local storage.
  Future<List<Movie>> getFavorites();

  /// Toggle the favorite status of a movie.
  /// Saves or removes the movie from local storage.
  Future<void> toggleFavorite(Movie movie);

  /// Check if a movie is currently favorited.
  Future<bool> isFavorite(String imdbId);

  /// Fetch a curated list of trending/popular movies.
  Future<List<MovieDetail>> getTrendingMovies();

  /// Fetch movie details for an arbitrary list of IMDB IDs.
  Future<List<MovieDetail>> getMoviesByIds(List<String> imdbIds);
}
