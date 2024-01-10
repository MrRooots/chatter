/// Base exceptions interface
abstract interface class BaseException implements Exception {
  final String message;

  const BaseException({required this.message});
}

/// Internal server exceptions
final class ServerException extends BaseException {
  const ServerException({required super.message});
}

/// Connection exceptions
final class ConnectionException extends BaseException {
  const ConnectionException({required super.message});
}

/// Authorization exceptions
final class AuthorizationException extends BaseException {
  final bool isFirstLaunch;

  const AuthorizationException({
    required super.message,
    this.isFirstLaunch = false,
  });
}

/// Authorization exceptions
final class RequestException extends BaseException {
  const RequestException({required super.message});
}

/// Cache exceptions caused by database
final class CacheException extends BaseException {
  const CacheException({required super.message});
}

/// Cache exceptions caused by database
final class FormatException extends BaseException {
  const FormatException({required super.message});
}

/// Undefined exceptions
final class UndefinedException extends BaseException {
  const UndefinedException({required super.message});
}
