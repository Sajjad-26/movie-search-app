import 'package:equatable/equatable.dart';

/// Events for the Movie Detail BLoC.
abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the detail screen is opened — fetches full movie info.
class FetchMovieDetailEvent extends MovieDetailEvent {
  final String imdbId;

  const FetchMovieDetailEvent(this.imdbId);

  @override
  List<Object?> get props => [imdbId];
}
