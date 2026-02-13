import 'package:equatable/equatable.dart';
import '../../features/movies/domain/entities/movie_detail.dart';

/// Represents a genre section with its movies loaded from the API.
class GenreSection extends Equatable {
  final String name;
  final String icon;
  final List<MovieDetail> movies;

  const GenreSection({
    required this.name,
    required this.icon,
    required this.movies,
  });

  @override
  List<Object?> get props => [name, icon, movies];
}
