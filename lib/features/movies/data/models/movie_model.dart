import 'dart:convert';
import '../../domain/entities/movie.dart';

/// Data model for Movie, extending the domain entity.
/// Handles JSON serialization/deserialization from the OMDB API.
class MovieModel extends Movie {
  const MovieModel({
    required super.imdbID,
    required super.title,
    required super.year,
    required super.poster,
  });

  /// Create a [MovieModel] from OMDB API JSON response.
  /// 
  /// Example JSON:
  /// ```json
  /// {
  ///   "Title": "Jurassic Park",
  ///   "Year": "1993",
  ///   "imdbID": "tt0107290",
  ///   "Poster": "https://..."
  /// }
  /// ```
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      poster: json['Poster'] ?? 'N/A',
    );
  }

  /// Convert to a JSON map for local storage.
  Map<String, dynamic> toJson() {
    return {
      'imdbID': imdbID,
      'Title': title,
      'Year': year,
      'Poster': poster,
    };
  }

  /// Create a [MovieModel] from a stored JSON string.
  factory MovieModel.fromJsonString(String jsonString) {
    return MovieModel.fromJson(json.decode(jsonString));
  }

  /// Convert to a JSON string for local storage.
  String toJsonString() => json.encode(toJson());

  /// Create a [MovieModel] from a domain [Movie] entity.
  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      imdbID: movie.imdbID,
      title: movie.title,
      year: movie.year,
      poster: movie.poster,
    );
  }
}
