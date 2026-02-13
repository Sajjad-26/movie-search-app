import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/movies/data/datasources/movie_remote_data_source.dart';
import 'features/movies/data/datasources/movie_local_data_source.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/domain/usecases/search_movies.dart';
import 'features/movies/domain/usecases/get_movie_detail.dart';
import 'features/movies/domain/usecases/get_trending_movies.dart';
import 'features/movies/presentation/bloc/search/movie_search_bloc.dart';
import 'features/movies/presentation/bloc/favorites/favorites_bloc.dart';
import 'features/movies/presentation/bloc/trending/trending_bloc.dart';
import 'features/movies/presentation/bloc/genre_sections/genre_sections_bloc.dart';

/// Service Locator — registers all dependencies using GetIt.
/// Called once at app startup before runApp().
final sl = GetIt.instance;

/// Initialize all dependencies in the service locator.
Future<void> initDependencies() async {
  // ─── External Dependencies ──────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      )));

  // ─── Data Sources ───────────────────────────────────────────
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ─── Repository ─────────────────────────────────────────────
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // ─── Use Cases ──────────────────────────────────────────────
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetail(sl()));
  sl.registerLazySingleton(() => GetTrendingMovies(sl()));

  // ─── BLoCs ──────────────────────────────────────────────────
  sl.registerFactory(() => MovieSearchBloc(searchMovies: sl()));
  sl.registerFactory(() => FavoritesBloc(repository: sl()));
  sl.registerFactory(() => TrendingBloc(getTrendingMovies: sl()));
  sl.registerFactory(() => GenreSectionsBloc(repository: sl()));
}
