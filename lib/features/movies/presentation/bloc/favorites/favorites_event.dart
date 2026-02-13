import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

/// Events for the Favorites BLoC.
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered to load all favorites from local storage.
class LoadFavoritesEvent extends FavoritesEvent {
  const LoadFavoritesEvent();
}

/// Triggered when the user taps the heart icon to toggle favorite status.
class ToggleFavoriteEvent extends FavoritesEvent {
  final Movie movie;

  const ToggleFavoriteEvent(this.movie);

  @override
  List<Object?> get props => [movie];
}
