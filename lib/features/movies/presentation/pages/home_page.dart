import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/search_input.dart';
import '../../../../core/widgets/trending_carousel.dart';
import '../../../../core/widgets/genre_movie_row.dart';
import '../../domain/entities/movie.dart';
import '../bloc/search/movie_search_bloc.dart';
import '../bloc/search/movie_search_event.dart';
import '../bloc/trending/trending_bloc.dart';
import '../bloc/trending/trending_event.dart';
import '../bloc/trending/trending_state.dart';
import '../bloc/genre_sections/genre_sections_bloc.dart';
import '../bloc/genre_sections/genre_sections_event.dart';
import '../bloc/genre_sections/genre_sections_state.dart';
import 'search_results_page.dart';
import 'favorites_page.dart';
import 'movie_detail_page.dart';

/// Home Page — the main screen with a search bar, trending carousel,
/// genre sections, and bottom navigation for Home / Favorites.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load trending movies and genre sections on startup
    context.read<TrendingBloc>().add(const LoadTrendingEvent());
    context.read<GenreSectionsBloc>().add(const LoadGenreSectionsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Navigate to the search results page.
  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    context.read<MovieSearchBloc>().add(SearchMoviesEvent(query.trim()));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(initialQuery: query.trim()),
      ),
    );
  }

  /// Navigate to movie detail page.
  void _navigateToDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          const FavoritesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  /// Builds the Home tab content — search bar, trending carousel, genre sections.
  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // ─── Title ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Discover',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Find your next favorite movie',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
            // ─── Search Bar ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SearchInput(
                controller: _searchController,
                onSubmitted: _performSearch,
                onClear: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
                onSearch: () => _performSearch(_searchController.text),
              ),
            ),
            const SizedBox(height: 28),
            // ─── Trending Carousel ─────────────────────────────
            _buildTrendingSection(),
            const SizedBox(height: 28),
            // ─── Genre Sections ────────────────────────────────
            _buildGenreSections(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Builds the trending movies section with BLoC state handling.
  Widget _buildTrendingSection() {
    return BlocBuilder<TrendingBloc, TrendingState>(
      builder: (context, state) {
        if (state is TrendingLoading) {
          return const SizedBox(
            height: 260,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        } else if (state is TrendingLoaded) {
          return TrendingCarousel(
            movies: state.movies,
            onMovieTap: _navigateToDetail,
          );
        } else if (state is TrendingError) {
          return const SizedBox.shrink();
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Builds the genre sections (Horror, Sci-Fi, Action, etc.)
  Widget _buildGenreSections() {
    return BlocBuilder<GenreSectionsBloc, GenreSectionsState>(
      builder: (context, state) {
        if (state is GenreSectionsLoading) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        } else if (state is GenreSectionsLoaded) {
          return Column(
            children: state.sections.map((section) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: GenreMovieRow(
                  section: section,
                  onMovieTap: _navigateToDetail,
                ),
              );
            }).toList(),
          );
        } else if (state is GenreSectionsError) {
          return const SizedBox.shrink();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
