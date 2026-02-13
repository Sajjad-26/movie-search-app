import '../../../../core/error/exceptions.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';
import '../datasources/movie_local_data_source.dart';
import '../models/movie_model.dart';

/// Concrete implementation of [MovieRepository].
/// Coordinates between remote (OMDB API) and local (SharedPreferences) data sources.
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  const MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Movie>> searchMovies(String query) async {
    // Delegate to remote data source — errors propagate up to BLoC
    return await remoteDataSource.searchMovies(query);
  }

  @override
  Future<MovieDetail> getMovieDetail(String imdbId) async {
    return await remoteDataSource.getMovieDetail(imdbId);
  }

  @override
  Future<List<Movie>> getFavorites() async {
    return await localDataSource.getFavorites();
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isFav = await localDataSource.isFavorite(movie.imdbID);
    if (isFav) {
      await localDataSource.removeFavorite(movie.imdbID);
    } else {
      await localDataSource.saveFavorite(MovieModel.fromEntity(movie));
    }
  }

  @override
  Future<bool> isFavorite(String imdbId) async {
    return await localDataSource.isFavorite(imdbId);
  }

  @override
  Future<List<MovieDetail>> getTrendingMovies() async {
    return await remoteDataSource.getTrendingMovies();
  }

  @override
  Future<List<MovieDetail>> getMoviesByIds(List<String> imdbIds) async {
    return await remoteDataSource.getMoviesByIds(imdbIds);
  }
}
