import '../../domain/entities/movie_detail.dart';

/// Data model for MovieDetail, extending the domain entity.
/// Handles JSON deserialization from the OMDB detail endpoint.
class MovieDetailModel extends MovieDetail {
  const MovieDetailModel({
    required super.imdbID,
    required super.title,
    required super.year,
    required super.rated,
    required super.runtime,
    required super.genre,
    required super.director,
    required super.actors,
    required super.plot,
    required super.poster,
    required super.imdbRating,
    required super.rottenTomatoesRating,
    required super.metascore,
  });

  /// Create a [MovieDetailModel] from OMDB API detail JSON response.
  ///
  /// Extracts the Rotten Tomatoes rating from the "Ratings" array.
  /// Example JSON:
  /// ```json
  /// {
  ///   "Title": "Jurassic Park",
  ///   "Year": "1993",
  ///   "Rated": "PG-13",
  ///   "Runtime": "127 min",
  ///   "Genre": "Action, Adventure, Sci-Fi",
  ///   "Director": "Steven Spielberg",
  ///   "Actors": "Sam Neill, Laura Dern, Jeff Goldblum",
  ///   "Plot": "An industrialist invites some experts...",
  ///   "Poster": "https://...",
  ///   "Ratings": [
  ///     {"Source": "Internet Movie Database", "Value": "8.2/10"},
  ///     {"Source": "Rotten Tomatoes", "Value": "91%"},
  ///     {"Source": "Metacritic", "Value": "68/100"}
  ///   ],
  ///   "Metascore": "68",
  ///   "imdbRating": "8.2",
  ///   "imdbID": "tt0107290"
  /// }
  /// ```
  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    // Extract Rotten Tomatoes rating from the Ratings array
    String rtRating = 'N/A';
    if (json['Ratings'] != null && json['Ratings'] is List) {
      for (final rating in json['Ratings']) {
        if (rating['Source'] == 'Rotten Tomatoes') {
          rtRating = rating['Value'] ?? 'N/A';
          break;
        }
      }
    }

    return MovieDetailModel(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      rated: json['Rated'] ?? 'N/A',
      runtime: json['Runtime'] ?? 'N/A',
      genre: json['Genre'] ?? '',
      director: json['Director'] ?? 'N/A',
      actors: json['Actors'] ?? 'N/A',
      plot: json['Plot'] ?? 'No plot available.',
      poster: json['Poster'] ?? 'N/A',
      imdbRating: json['imdbRating'] ?? 'N/A',
      rottenTomatoesRating: rtRating,
      metascore: json['Metascore'] ?? 'N/A',
    );
  }
}
