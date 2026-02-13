import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../features/movies/domain/entities/movie.dart';
import '../../features/movies/domain/entities/movie_detail.dart';
import '../theme/app_theme.dart';

/// Netflix-style auto-scrolling carousel for trending movies.
/// Features:
/// - Auto-advances every 4 seconds
/// - Peek-next-card effect via viewportFraction
/// - Gradient overlay with title, year, and genre
/// - Dot indicators
/// - Tap to navigate to detail page
class TrendingCarousel extends StatefulWidget {
  final List<MovieDetail> movies;
  final void Function(Movie movie) onMovieTap;

  const TrendingCarousel({
    super.key,
    required this.movies,
    required this.onMovieTap,
  });

  @override
  State<TrendingCarousel> createState() => _TrendingCarouselState();
}

class _TrendingCarouselState extends State<TrendingCarousel> {
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || widget.movies.isEmpty) return;
      final nextPage = (_currentPage + 1) % widget.movies.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  /// Reset auto-scroll timer when user manually swipes.
  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _startAutoScroll(); // Reset timer on manual interaction
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Section Header ──────────────────────────────────────
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
                'Trending Now',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const Spacer(),
              Icon(
                Icons.local_fire_department_rounded,
                color: Colors.orange.shade400,
                size: 22,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ─── Carousel ────────────────────────────────────────────
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.movies.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return _buildCarouselCard(context, widget.movies[index]);
            },
          ),
        ),
        const SizedBox(height: 14),

        // ─── Dot Indicators ──────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.movies.length,
            (index) => _buildDot(index),
          ),
        ),
      ],
    );
  }

  /// Builds a single carousel card with poster, gradient overlay, and text.
  Widget _buildCarouselCard(BuildContext context, MovieDetail movie) {
    return GestureDetector(
      onTap: () {
        // Convert MovieDetail to Movie entity for navigation
        final movieEntity = Movie(
          imdbID: movie.imdbID,
          title: movie.title,
          year: movie.year,
          poster: movie.poster,
        );
        widget.onMovieTap(movieEntity);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ─── Background Poster ───────────────────────────
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
                    errorWidget: (context, url, error) =>
                        _buildPlaceholder(movie),
                  )
                : _buildPlaceholder(movie),

            // ─── Gradient Overlay ────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.85),
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),

            // ─── Bottom Text Content ─────────────────────────
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Year + Genre
                  Row(
                    children: [
                      Text(
                        movie.year,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      if (movie.genre.isNotEmpty && movie.genre != 'N/A') ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            movie.genre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  // IMDB Rating badge
                  if (movie.imdbRating != 'N/A')
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.imdbYellow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Colors.black87,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            movie.imdbRating,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Placeholder when poster is unavailable.
  Widget _buildPlaceholder(MovieDetail movie) {
    return Container(
      color: const Color(0xFF1A1D26),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.movie_outlined,
              size: 48,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Dot indicator widget.
  Widget _buildDot(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryBlue : AppTheme.dividerColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
