import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie_detail.dart';

/// States for the Trending BLoC.
abstract class TrendingState extends Equatable {
  const TrendingState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no data loaded yet.
class TrendingInitial extends TrendingState {
  const TrendingInitial();
}

/// Loading state — fetching trending movie data.
class TrendingLoading extends TrendingState {
  const TrendingLoading();
}

/// Loaded state — trending movies are ready for display.
class TrendingLoaded extends TrendingState {
  final List<MovieDetail> movies;

  const TrendingLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

/// Error state — something went wrong fetching trending data.
class TrendingError extends TrendingState {
  final String message;

  const TrendingError(this.message);

  @override
  List<Object?> get props => [message];
}
