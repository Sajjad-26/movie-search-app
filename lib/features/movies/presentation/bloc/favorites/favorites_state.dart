import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

/// States for the Favorites BLoC.
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial state — favorites have not been loaded yet.
class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// Loading state — favorites are being loaded from storage.
class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

/// Loaded state — contains the list of favorite movies.
class FavoritesLoaded extends FavoritesState {
  final List<Movie> favorites;

  const FavoritesLoaded({required this.favorites});

  /// Quick lookup: check if a movie is in favorites.
  bool isFavorite(String imdbId) =>
      favorites.any((movie) => movie.imdbID == imdbId);

  @override
  List<Object?> get props => [favorites];
}

/// Error state — failed to load favorites.
class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError({required this.message});

  @override
  List<Object?> get props => [message];
}
