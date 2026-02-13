import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import '../bloc/detail/movie_detail_bloc.dart';
import '../bloc/detail/movie_detail_event.dart';
import '../bloc/detail/movie_detail_state.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';

/// Movie Detail Page — full-screen detail view for a selected movie.
/// Matches the reference: hero poster, curved bottom sheet with info,
/// genre chips, ratings row (IMDB, RT, Metacritic), plot, cast list.
class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailBloc(
        getMovieDetail: GetIt.instance<GetMovieDetail>(),
        repository: GetIt.instance<MovieRepository>(),
      )..add(FetchMovieDetailEvent(movie.imdbID)),
      child: _MovieDetailView(movie: movie),
    );
  }
}

class _MovieDetailView extends StatelessWidget {
  final Movie movie;

  const _MovieDetailView({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return _buildLoadingState(context);
          } else if (state is MovieDetailLoaded) {
            return _buildDetailView(context, state.movieDetail, state.isFavorite);
          } else if (state is MovieDetailError) {
            return _buildErrorState(context, state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Loading state with a placeholder poster.
  Widget _buildLoadingState(BuildContext context) {
    return Stack(
      children: [
        // Show the poster from search results while loading details
        if (movie.hasValidPoster)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: movie.poster,
              fit: BoxFit.cover,
            ),
          ),
        // Back button
        _buildBackButton(context),
        // Loading indicator
        const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryBlue,
          ),
        ),
      ],
    );
  }

  /// Full detail view after data is loaded.
  Widget _buildDetailView(BuildContext context, MovieDetail detail, bool isFavorite) {
    return CustomScrollView(
      slivers: [
        // ─── Hero Poster Section ──────────────────────────────
        SliverToBoxAdapter(
          child: Stack(
            children: [
              // Poster image
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: detail.hasValidPoster
                    ? CachedNetworkImage(
                        imageUrl: detail.poster,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppTheme.searchBarBg,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: AppTheme.searchBarBg,
                        child: const Icon(
                          Icons.movie_outlined,
                          size: 80,
                          color: AppTheme.textTertiary,
                        ),
                      ),
              ),
              // Gradient overlay at bottom of poster
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              // Back button
              _buildBackButton(context),
              // Favorite button
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 16,
                child: BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, favState) {
                    final isFav = favState is FavoritesLoaded
                        ? favState.isFavorite(movie.imdbID)
                        : isFavorite;
                    return GestureDetector(
                      onTap: () {
                        context.read<FavoritesBloc>().add(ToggleFavoriteEvent(movie));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? AppTheme.favoriteRed : AppTheme.textTertiary,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // ─── Detail Content ──────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            transform: Matrix4.translationValues(0, -20, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Title ────────────────────────────────
                Text(
                  detail.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                // ─── Year • Rated • Runtime ──────────────
                Text(
                  '${detail.year} • ${detail.rated} • ${detail.runtime}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 16),
                // ─── Genre Chips ──────────────────────────
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: detail.genreList
                      .map((genre) => _buildGenreChip(genre))
                      .toList(),
                ),
                const SizedBox(height: 24),
                // ─── Ratings Row ──────────────────────────
                _buildRatingsRow(detail),
                const SizedBox(height: 28),
                // ─── Plot Section ─────────────────────────
                const Text(
                  'PLOT',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  detail.plot,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textPrimary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                // ─── Cast & Crew Section ──────────────────
                const Text(
                  'CAST & CREW',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                // Director
                _buildCastItem(
                  name: detail.director,
                  role: 'Director',
                  color: AppTheme.primaryBlue,
                ),
                const SizedBox(height: 12),
                // Actors
                ...detail.actorList.map((actor) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCastItem(
                      name: actor,
                      role: '',
                      color: _getActorColor(detail.actorList.indexOf(actor)),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Back button overlay on the poster.
  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back,
            color: AppTheme.textPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }

  /// Genre chip widget.
  Widget _buildGenreChip(String genre) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.textPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        genre.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  /// Ratings row showing IMDB, Rotten Tomatoes, and Metacritic scores.
  Widget _buildRatingsRow(MovieDetail detail) {
    return Row(
      children: [
        // IMDB Rating
        _buildRatingItem(
          label: 'IMDB',
          value: detail.imdbRating,
          suffix: '/10',
          icon: Icons.star_rounded,
          iconColor: AppTheme.imdbYellow,
        ),
        const SizedBox(width: 32),
        // Rotten Tomatoes
        _buildRatingItem(
          label: 'ROTTEN\nTOMATOES',
          value: detail.rottenTomatoesRating,
          suffix: '',
          icon: Icons.local_fire_department_rounded,
          iconColor: AppTheme.rottenTomatoesRed,
        ),
        const SizedBox(width: 32),
        // Metacritic
        _buildRatingItem(
          label: 'METACRITIC',
          value: detail.metascore,
          suffix: '/100',
          icon: Icons.circle,
          iconColor: AppTheme.metacriticGreen,
        ),
      ],
    );
  }

  /// Individual rating item.
  Widget _buildRatingItem({
    required String label,
    required String value,
    required String suffix,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppTheme.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value != 'N/A' ? value : '–',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (value != 'N/A' && suffix.isNotEmpty)
                    TextSpan(
                      text: suffix,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Cast/crew item with colored avatar circle.
  Widget _buildCastItem({
    required String name,
    required String role,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            if (role.isNotEmpty)
              Text(
                role,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// Generate distinct colors for actor avatars.
  Color _getActorColor(int index) {
    const colors = [
      Color(0xFFE8B861), // Gold
      Color(0xFFD4A057), // Tan
      Color(0xFFC99B54), // Warm brown
      Color(0xFF8B9DC3), // Steel blue
      Color(0xFF9B8EC4), // Lavender
      Color(0xFFE88B8B), // Coral
    ];
    return colors[index % colors.length];
  }

  /// Error state with retry.
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: AppTheme.accentRed.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
