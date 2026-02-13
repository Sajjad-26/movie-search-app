import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/movie_card.dart';
import '../../../../core/widgets/search_input.dart';
import '../../domain/entities/movie.dart';
import '../bloc/search/movie_search_bloc.dart';
import '../bloc/search/movie_search_event.dart';
import '../bloc/search/movie_search_state.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';
import 'movie_detail_page.dart';

/// Search Results Page — shows a grid of movies returned from the search.
/// Matches the reference: AppBar with back arrow and "Search Results",
/// search bar with query, result count, 2-column GridView.
class SearchResultsPage extends StatefulWidget {
  final String initialQuery;

  const SearchResultsPage({super.key, required this.initialQuery});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Trigger a new search.
  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    context.read<MovieSearchBloc>().add(SearchMoviesEvent(query.trim()));
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
      appBar: AppBar(
        title: const Text('Search Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // ─── Search Bar ──────────────────────────────────
              SearchInput(
                controller: _searchController,
                autofocus: false,
                onSubmitted: _performSearch,
                onClear: () {
                  setState(() {
                    _searchController.clear();
                  });
                  context.read<MovieSearchBloc>().add(const ClearSearchEvent());
                },
              ),
              const SizedBox(height: 16),
              // ─── Results Area ────────────────────────────────
              Expanded(
                child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
                  builder: (context, state) {
                    if (state is MovieSearchLoading) {
                      return _buildLoadingState();
                    } else if (state is MovieSearchLoaded) {
                      return _buildResultsGrid(state.movies, state.query);
                    } else if (state is MovieSearchEmpty) {
                      return _buildEmptyState(state.query);
                    } else if (state is MovieSearchError) {
                      return _buildErrorState(state.message);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Loading indicator while fetching results.
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryBlue,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Searching...',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Grid of search results.
  Widget _buildResultsGrid(List<Movie> movies, String query) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Result count
        Text(
          '${movies.length} movies found',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 12),
        // Grid
        Expanded(
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, favState) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.55,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  final isFav = favState is FavoritesLoaded
                      ? favState.isFavorite(movie.imdbID)
                      : false;
                  return MovieCard(
                    movie: movie,
                    isFavorite: isFav,
                    onTap: () => _navigateToDetail(movie),
                    onFavoriteTap: () {
                      context.read<FavoritesBloc>().add(ToggleFavoriteEvent(movie));
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Empty state when no results are found.
  Widget _buildEmptyState(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_filter_outlined,
            size: 80,
            color: AppTheme.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No movies found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for "$query" with different keywords',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Error state with retry option.
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 80,
            color: AppTheme.accentRed.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          const Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () =>
                _performSearch(_searchController.text),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
