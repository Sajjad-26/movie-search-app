import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_trending_movies.dart';
import 'trending_event.dart';
import 'trending_state.dart';

/// BLoC for managing trending/popular movies carousel state.
class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  final GetTrendingMovies getTrendingMovies;

  TrendingBloc({required this.getTrendingMovies})
      : super(const TrendingInitial()) {
    on<LoadTrendingEvent>(_onLoadTrending);
  }

  Future<void> _onLoadTrending(
    LoadTrendingEvent event,
    Emitter<TrendingState> emit,
  ) async {
    emit(const TrendingLoading());
    try {
      final movies = await getTrendingMovies();
      emit(TrendingLoaded(movies));
    } catch (e) {
      emit(TrendingError(e.toString()));
    }
  }
}
