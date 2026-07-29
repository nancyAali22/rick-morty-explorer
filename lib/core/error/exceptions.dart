/// Thrown by the data layer (datasources). The repository implementation
/// catches these and converts them into Failures for the domain layer.
class ServerException implements Exception {
  final String message;

  const ServerException([this.message = 'Server error']);
}

class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'No internet connection']);
}

class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache error']);
}
