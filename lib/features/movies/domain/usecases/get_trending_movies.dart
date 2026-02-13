import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

/// Use case for fetching the curated list of trending movies.
/// Follows the Single Responsibility Principle — one use case per action.
class GetTrendingMovies {
  final MovieRepository repository;

  const GetTrendingMovies(this.repository);

  /// Execute the trending movies fetch.
  Future<List<MovieDetail>> call() {
    return repository.getTrendingMovies();
  }
}
