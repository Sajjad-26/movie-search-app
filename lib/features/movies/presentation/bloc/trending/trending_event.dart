import 'package:equatable/equatable.dart';

/// Events for the Trending BLoC.
abstract class TrendingEvent extends Equatable {
  const TrendingEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on app startup to load the trending carousel data.
class LoadTrendingEvent extends TrendingEvent {
  const LoadTrendingEvent();
}
