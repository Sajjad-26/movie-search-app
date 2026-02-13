import 'package:equatable/equatable.dart';

/// Events for the GenreSections BLoC.
abstract class GenreSectionsEvent extends Equatable {
  const GenreSectionsEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on app startup to load all genre sections.
class LoadGenreSectionsEvent extends GenreSectionsEvent {
  const LoadGenreSectionsEvent();
}
