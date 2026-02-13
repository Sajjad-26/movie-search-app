import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Use case for searching movies by query.
/// Follows the Single Responsibility Principle — one use case per action.
class SearchMovies {
  final MovieRepository repository;

  const SearchMovies(this.repository);

  /// Execute the search with the given [query].
  Future<List<Movie>> call(String query) {
    return repository.searchMovies(query);
  }
}
