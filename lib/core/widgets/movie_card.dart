import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../features/movies/domain/entities/movie.dart';

/// Reusable movie card widget for grid display.
/// Shows the movie poster, title, year, and a favorite heart icon.
/// Matches the reference design: rounded corners, shadow, gradient overlay.
class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const MovieCard({
    super.key,
    required this.movie,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Poster Card ─────────────────────────────────────
          Expanded(
            child: Stack(
              children: [
                // Poster image with rounded corners
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppTheme.searchBarBg,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: movie.hasValidPoster
                      ? CachedNetworkImage(
                          imageUrl: movie.poster,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              _buildPlaceholderPoster(),
                        )
                      : _buildPlaceholderPoster(),
                ),

                // ─── Favorite Heart Icon ──────────────────────────
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isFavorite
                            ? AppTheme.favoriteRed.withOpacity(0.9)
                            : Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.white : AppTheme.textTertiary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Title and Year ────────────────────────────────────
          const SizedBox(height: 8),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            movie.year,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Placeholder widget shown when no valid poster URL is available.
  Widget _buildPlaceholderPoster() {
    return Container(
      color: AppTheme.searchBarBg,
      child: const Center(
        child: Icon(
          Icons.movie_outlined,
          size: 48,
          color: AppTheme.textTertiary,
        ),
      ),
    );
  }
}
