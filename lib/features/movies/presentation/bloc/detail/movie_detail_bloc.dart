import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/repositories/movie_repository.dart';
import '../../../domain/entities/movie.dart';
import '../../../../../core/error/exceptions.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

/// BLoC for handling movie detail screen logic.
/// Fetches full movie details and manages favorite state.
class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final MovieRepository repository;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.repository,
  }) : super(const MovieDetailInitial()) {
    on<FetchMovieDetailEvent>(_onFetchDetail);
  }

  /// Fetch movie detail from the API and check favorite status.
  Future<void> _onFetchDetail(
    FetchMovieDetailEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(const MovieDetailLoading());

    try {
      // Fetch detail and favorite status concurrently
      final results = await Future.wait([
        getMovieDetail(event.imdbId),
        repository.isFavorite(event.imdbId),
      ]);

      final movieDetail = results[0] as dynamic;
      final isFavorite = results[1] as bool;

      emit(MovieDetailLoaded(
        movieDetail: movieDetail,
        isFavorite: isFavorite,
      ));
    } on NetworkException catch (e) {
      emit(MovieDetailError(message: e.message));
    } on RateLimitException catch (e) {
      emit(MovieDetailError(message: e.message));
    } on ServerException catch (e) {
      emit(MovieDetailError(message: e.message));
    } catch (e) {
      emit(MovieDetailError(message: 'Failed to load movie details'));
    }
  }
}
