import 'package:equatable/equatable.dart';
import '../../../../../core/models/genre_section.dart';

/// States for the GenreSections BLoC.
abstract class GenreSectionsState extends Equatable {
  const GenreSectionsState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no genre data loaded yet.
class GenreSectionsInitial extends GenreSectionsState {
  const GenreSectionsInitial();
}

/// Loading state — fetching genre section data.
class GenreSectionsLoading extends GenreSectionsState {
  const GenreSectionsLoading();
}

/// Loaded state — genre sections ready for display.
class GenreSectionsLoaded extends GenreSectionsState {
  final List<GenreSection> sections;

  const GenreSectionsLoaded(this.sections);

  @override
  List<Object?> get props => [sections];
}

/// Error state — something went wrong.
class GenreSectionsError extends GenreSectionsState {
  final String message;

  const GenreSectionsError(this.message);

  @override
  List<Object?> get props => [message];
}
