import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/search_movies.dart';
import '../../../../../core/error/exceptions.dart';
import 'movie_search_event.dart';
import 'movie_search_state.dart';

/// BLoC for handling movie search logic.
/// Listens for [MovieSearchEvent]s and emits [MovieSearchState]s.
class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies})
      : super(const MovieSearchInitial()) {
    on<SearchMoviesEvent>(_onSearchMovies);
    on<ClearSearchEvent>(_onClearSearch);
  }

  /// Handle search event — fetch movies from OMDB API.
  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MovieSearchState> emit,
  ) async {
    // Don't search for empty queries
    if (event.query.trim().isEmpty) {
      emit(const MovieSearchInitial());
      return;
    }

    emit(const MovieSearchLoading());

    try {
      final movies = await searchMovies(event.query.trim());

      if (movies.isEmpty) {
        emit(MovieSearchEmpty(query: event.query));
      } else {
        emit(MovieSearchLoaded(movies: movies, query: event.query));
      }
    } on NetworkException catch (e) {
      emit(MovieSearchError(message: e.message));
    } on RateLimitException catch (e) {
      emit(MovieSearchError(message: e.message));
    } on ServerException catch (e) {
      emit(MovieSearchError(message: e.message));
    } catch (e) {
      emit(MovieSearchError(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  /// Handle clear search — reset to initial state.
  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<MovieSearchState> emit,
  ) {
    emit(const MovieSearchInitial());
  }
}
