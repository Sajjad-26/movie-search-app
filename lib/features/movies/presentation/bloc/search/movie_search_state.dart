import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

/// States for the Movie Search BLoC.
abstract class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object?> get props => [];
}

/// Initial state — shown before any search is performed.
class MovieSearchInitial extends MovieSearchState {
  const MovieSearchInitial();
}

/// Loading state — shown while the search request is in progress.
class MovieSearchLoading extends MovieSearchState {
  const MovieSearchLoading();
}

/// Loaded state — contains the list of movies returned from the search.
class MovieSearchLoaded extends MovieSearchState {
  final List<Movie> movies;
  final String query;

  const MovieSearchLoaded({required this.movies, required this.query});

  @override
  List<Object?> get props => [movies, query];
}

/// Empty state — no movies found for the search query.
class MovieSearchEmpty extends MovieSearchState {
  final String query;

  const MovieSearchEmpty({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Error state — an error occurred during the search.
class MovieSearchError extends MovieSearchState {
  final String message;

  const MovieSearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
