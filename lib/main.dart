import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;
import 'features/movies/presentation/bloc/search/movie_search_bloc.dart';
import 'features/movies/presentation/bloc/favorites/favorites_bloc.dart';
import 'features/movies/presentation/bloc/favorites/favorites_event.dart';
import 'features/movies/presentation/bloc/trending/trending_bloc.dart';
import 'features/movies/presentation/bloc/genre_sections/genre_sections_bloc.dart';
import 'features/movies/presentation/pages/home_page.dart';

/// Entry point of the Movie Search App.
/// Initializes dependency injection and provides BLoCs to the widget tree.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies (SharedPreferences, Dio, etc.)
  await di.initDependencies();

  runApp(const MovieSearchApp());
}

/// Root widget of the application.
class MovieSearchApp extends StatelessWidget {
  const MovieSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Movie Search BLoC — available app-wide for search state
        BlocProvider(create: (_) => di.sl<MovieSearchBloc>()),
        // Favorites BLoC — available app-wide, loads favorites on startup
        BlocProvider(
          create: (_) =>
              di.sl<FavoritesBloc>()..add(const LoadFavoritesEvent()),
        ),
        // Trending BLoC — available app-wide for the trending carousel
        BlocProvider(create: (_) => di.sl<TrendingBloc>()),
        // Genre Sections BLoC — for genre rows on home screen
        BlocProvider(create: (_) => di.sl<GenreSectionsBloc>()),
      ],
      child: MaterialApp(
        title: 'Movie Search App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomePage(),
      ),
    );
  }
}
