import 'package:equatable/equatable.dart';

/// Movie entity — represents a movie from search results.
/// This is a pure domain entity with no framework dependencies.
class Movie extends Equatable {
  final String imdbID;
  final String title;
  final String year;
  final String poster;

  const Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.poster,
  });

  /// Check if the movie has a valid poster image URL
  bool get hasValidPoster =>
      poster != 'N/A' && poster.isNotEmpty && poster.startsWith('http');

  @override
  List<Object?> get props => [imdbID, title, year, poster];
}
