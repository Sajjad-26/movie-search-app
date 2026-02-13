/// Core constants for the Movie Search App.
/// Contains API configuration values used throughout the app.
class ApiConstants {
  ApiConstants._(); // Prevent instantiation

  /// OMDB API base URL
  static const String baseUrl = 'https://www.omdbapi.com/';

  /// OMDB API Key — Replace with your own key from https://www.omdbapi.com/apikey.aspx
  static const String apiKey = 'cbbbbec0';

  /// Build search URL for querying movies by title
  static String searchUrl(String query) => '$baseUrl?s=$query&apikey=$apiKey';

  /// Build detail URL for fetching movie details by IMDB ID
  static String detailUrl(String imdbId) => '$baseUrl?i=$imdbId&apikey=$apiKey';

  /// Curated list of popular movie IMDB IDs for the trending carousel.
  /// These are well-known titles with high-quality poster images.
  static const List<String> trendingImdbIds = [
    'tt1375666', // Inception
    'tt0468569', // The Dark Knight
    'tt0816692', // Interstellar
    'tt4154796', // Avengers: Endgame
    'tt0133093', // The Matrix
    'tt0111161', // The Shawshank Redemption
    'tt1856101', // Blade Runner 2049
    'tt0076759', // Star Wars: A New Hope
    'tt0167260', // The Lord of the Rings: Return of the King
    'tt0120737', // The Lord of the Rings: Fellowship of the Ring
    'tt0137523', // Fight Club
    'tt0110912', // Pulp Fiction
    'tt0109830', // Forrest Gump
    'tt0068646', // The Godfather
    'tt6751668', // Parasite
  ];

  /// Genre sections shown on the home screen.
  /// Each contains a name, emoji icon, and curated IMDB IDs.
  static const List<Map<String, dynamic>> genreSections = [
    {
      'name': 'Horror',
      'icon': '🎃',
      'ids': [
        'tt1457767', // The Conjuring
        'tt0078748', // Alien
        'tt0054215', // Psycho
        'tt7784604', // Hereditary
        'tt1099212', // Twilight (Horror-adjacent)
        'tt0363547', // The Ring (2002)
        'tt0070047', // The Exorcist
        'tt5052448', // Get Out
      ],
    },
    {
      'name': 'Sci-Fi',
      'icon': '🚀',
      'ids': [
        'tt0083658', // Blade Runner
        'tt3659388', // The Martian
        'tt0848228', // The Avengers
        'tt0088763', // Back to the Future
        'tt1631867', // Edge of Tomorrow
        'tt2543164', // Arrival
        'tt1392170', // The Hunger Games
        'tt0103064', // Terminator 2
      ],
    },
    {
      'name': 'Action',
      'icon': '💥',
      'ids': [
        'tt0361748', // Inglourious Basterds
        'tt2015381', // Guardians of the Galaxy
        'tt0167261', // LOTR: Two Towers
        'tt0120915', // Star Wars: Episode I
        'tt1300854', // Iron Man 3
        'tt0372784', // Batman Begins
        'tt1392190', // Mad Max: Fury Road
        'tt4154756', // Avengers: Infinity War
      ],
    },
  ];
}
