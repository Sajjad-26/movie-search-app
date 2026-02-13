import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../features/movies/domain/entities/movie.dart';
import '../../features/movies/domain/entities/movie_detail.dart';
import '../theme/app_theme.dart';
import '../models/genre_section.dart';

/// Horizontal scrolling movie row widget for genre sections.
/// Shows a section header (icon + genre name) and a horizontally scrollable
/// list of movie poster cards. Tapping a card navigates to the detail page.
class GenreMovieRow extends StatelessWidget {
  final GenreSection section;
  final void Function(Movie movie) onMovieTap;

  const GenreMovieRow({
    super.key,
    required this.section,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (section.movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Section Header ──────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                section.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ─── Horizontal Movie List ───────────────────────────
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: section.movies.length,
            itemBuilder: (context, index) {
              return _buildMovieCard(context, section.movies[index]);
            },
          ),
        ),
      ],
    );
  }

  /// Builds a single movie card for the horizontal list.
  Widget _buildMovieCard(BuildContext context, MovieDetail movie) {
    return GestureDetector(
      onTap: () {
        final movieEntity = Movie(
          imdbID: movie.imdbID,
          title: movie.title,
          year: movie.year,
          poster: movie.poster,
        );
        onMovieTap(movieEntity);
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Poster ─────────────────────────────────────
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    movie.hasValidPoster
                        ? CachedNetworkImage(
                            imageUrl: movie.poster,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppTheme.searchBarBg,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppTheme.searchBarBg,
                              child: const Icon(
                                Icons.movie_outlined,
                                size: 32,
                                color: AppTheme.textTertiary,
                              ),
                            ),
                          )
                        : Container(
                            color: AppTheme.searchBarBg,
                            child: const Icon(
                              Icons.movie_outlined,
                              size: 32,
                              color: AppTheme.textTertiary,
                            ),
                          ),

                    // ─── IMDB Rating Badge ────────────────────
                    if (movie.imdbRating != 'N/A')
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 12,
                                color: AppTheme.imdbYellow,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                movie.imdbRating,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ─── Title ──────────────────────────────────────
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),

            // ─── Year ───────────────────────────────────────
            Text(
              movie.year,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
