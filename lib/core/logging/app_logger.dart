import 'dart:developer' as developer;

/// Severity of a log record. [value] uses the `package:logging` scale, which
/// DevTools understands for colouring and filtering.
enum LogLevel {
  debug(500),
  info(800),
  warning(900),
  error(1000),
  off(2000);

  new(this.value);

  final int value;
}

/// Receives error records, for example to forward them to a crash reporter.
typedef ErrorReporter = void Function(
  String message,
  Object? error,
  StackTrace? stackTrace,
);

/// A named logger on top of `dart:developer`.
///
/// Records appear in the IDE debug console and in the DevTools Logging view,
/// tagged with [name]. Declare one per file:
///
/// ```dart
/// const _log = AppLogger('PostsRepository');
/// ```
class AppLogger {
  const new(this.name);

  final String name;

  /// Records below this level are skipped. Configured in `bootstrap`.
  static LogLevel minLevel = .debug;

  /// Called for every [error] record, regardless of [minLevel].
  static ErrorReporter? errorReporter;

  void debug(String message) => _write(.debug, message);

  void info(String message) => _write(.info, message);

  void warning(String message, {Object? error, StackTrace? stackTrace}) =>
      _write(.warning, message, error: error, stackTrace: stackTrace);

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _write(.error, message, error: error, stackTrace: stackTrace);
    errorReporter?.call(message, error, stackTrace);
  }

  void _write(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.value < minLevel.value) return;
    developer.log(
      message,
      name: name,
      level: level.value,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
