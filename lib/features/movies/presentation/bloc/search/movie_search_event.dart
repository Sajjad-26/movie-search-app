import 'package:equatable/equatable.dart';

/// Events for the Movie Search BLoC.
abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the user submits a search query.
class SearchMoviesEvent extends MovieSearchEvent {
  final String query;

  const SearchMoviesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Triggered when the user clears the search bar.
class ClearSearchEvent extends MovieSearchEvent {
  const ClearSearchEvent();
}
