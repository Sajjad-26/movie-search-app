/// Custom exceptions thrown by data sources.
/// These are caught at the repository level and converted to [Failure] types.

/// Exception thrown when the server returns an error response.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred']);
}

/// Exception thrown when there is no network connectivity.
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection']);
}

/// Exception thrown when the API rate limit is reached.
class RateLimitException implements Exception {
  final String message;
  const RateLimitException([this.message = 'API request limit reached']);
}

/// Exception thrown when local cache operations fail.
class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error occurred']);
}
