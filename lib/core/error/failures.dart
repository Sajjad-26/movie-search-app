import 'package:equatable/equatable.dart';

/// Base failure class for handling errors across the app.
/// Extends [Equatable] for value comparison in BLoC states.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure for server-side errors (API errors, timeouts, etc.)
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred. Please try again.'])
      : super(message);
}

/// Failure for network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection. Please check your network.'])
      : super(message);
}

/// Failure for API rate limiting
class RateLimitFailure extends Failure {
  const RateLimitFailure([String message = 'API limit reached. Please try again later.'])
      : super(message);
}

/// Failure for local storage operations
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Failed to access local storage.'])
      : super(message);
}

/// Failure for invalid/not found data
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'No results found.'])
      : super(message);
}
