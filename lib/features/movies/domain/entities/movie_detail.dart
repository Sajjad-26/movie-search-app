import 'package:equatable/equatable.dart';

/// MovieDetail entity — represents the full details of a movie.
/// Includes plot, cast, ratings, genres, and other metadata
/// retrieved from the OMDB detail endpoint.
class MovieDetail extends Equatable {
  final String imdbID;
  final String title;
  final String year;
  final String rated;
  final String runtime;
  final String genre;
  final String director;
  final String actors;
  final String plot;
  final String poster;
  final String imdbRating;
  final String rottenTomatoesRating;
  final String metascore;

  const MovieDetail({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.rated,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.actors,
    required this.plot,
    required this.poster,
    required this.imdbRating,
    required this.rottenTomatoesRating,
    required this.metascore,
  });

  /// Check if the movie has a valid poster image URL
  bool get hasValidPoster =>
      poster != 'N/A' && poster.isNotEmpty && poster.startsWith('http');

  /// Returns a list of genre strings (e.g., ['Action', 'Adventure', 'Sci-Fi'])
  List<String> get genreList =>
      genre.split(',').map((g) => g.trim()).where((g) => g.isNotEmpty).toList();

  /// Returns a list of actor names
  List<String> get actorList =>
      actors.split(',').map((a) => a.trim()).where((a) => a.isNotEmpty).toList();

  @override
  List<Object?> get props => [
        imdbID, title, year, rated, runtime, genre,
        director, actors, plot, poster,
        imdbRating, rottenTomatoesRating, metascore,
      ];
}
