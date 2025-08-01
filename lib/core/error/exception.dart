class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
  @override
  String toString() => 'CacheException: $message';
}
