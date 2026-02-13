import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/movie_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

/// BLoC for managing favorite movies.
/// Loads favorites from local storage and handles toggle operations.
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final MovieRepository repository;

  FavoritesBloc({required this.repository})
      : super(const FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  /// Load all favorites from local storage.
  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());

    try {
      final favorites = await repository.getFavorites();
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesError(message: 'Failed to load favorites: ${e.toString()}'));
    }
  }

  /// Toggle a movie's favorite status and reload the favorites list.
  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await repository.toggleFavorite(event.movie);
      // Reload favorites after toggling
      final favorites = await repository.getFavorites();
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesError(message: 'Failed to update favorites'));
    }
  }
}
