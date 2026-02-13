import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie_detail.dart';

/// States for the Movie Detail BLoC.
abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

/// Initial state — before detail has been fetched.
class MovieDetailInitial extends MovieDetailState {
  const MovieDetailInitial();
}

/// Loading state — detail is being fetched from the API.
class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading();
}

/// Loaded state — movie detail has been successfully fetched.
class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movieDetail;
  final bool isFavorite;

  const MovieDetailLoaded({
    required this.movieDetail,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [movieDetail, isFavorite];

  /// Create a copy with updated favorite status.
  MovieDetailLoaded copyWith({bool? isFavorite}) {
    return MovieDetailLoaded(
      movieDetail: movieDetail,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

/// Error state — failed to fetch movie detail.
class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
