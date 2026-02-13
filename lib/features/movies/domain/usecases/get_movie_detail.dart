import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

/// Use case for fetching detailed movie information by IMDB ID.
class GetMovieDetail {
  final MovieRepository repository;

  const GetMovieDetail(this.repository);

  /// Execute the detail fetch with the given [imdbId].
  Future<MovieDetail> call(String imdbId) {
    return repository.getMovieDetail(imdbId);
  }
}
