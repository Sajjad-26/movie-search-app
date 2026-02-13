import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/models/genre_section.dart';
import '../../../domain/repositories/movie_repository.dart';
import 'genre_sections_event.dart';
import 'genre_sections_state.dart';

/// BLoC for managing genre sections on the home screen.
/// Loads all genre sections (Horror, Sci-Fi, Action) concurrently on startup.
class GenreSectionsBloc extends Bloc<GenreSectionsEvent, GenreSectionsState> {
  final MovieRepository repository;

  GenreSectionsBloc({required this.repository})
      : super(const GenreSectionsInitial()) {
    on<LoadGenreSectionsEvent>(_onLoadGenreSections);
  }

  Future<void> _onLoadGenreSections(
    LoadGenreSectionsEvent event,
    Emitter<GenreSectionsState> emit,
  ) async {
    emit(const GenreSectionsLoading());
    try {
      // Load all genre sections concurrently
      final sectionConfigs = ApiConstants.genreSections;
      final futures = sectionConfigs.map((config) async {
        final ids = List<String>.from(config['ids'] as List);
        final movies = await repository.getMoviesByIds(ids);
        return GenreSection(
          name: config['name'] as String,
          icon: config['icon'] as String,
          movies: movies,
        );
      });

      final sections = await Future.wait(futures);
      // Filter out sections with no movies loaded
      final validSections = sections.where((s) => s.movies.isNotEmpty).toList();
      emit(GenreSectionsLoaded(validSections));
    } catch (e) {
      emit(GenreSectionsError(e.toString()));
    }
  }
}
