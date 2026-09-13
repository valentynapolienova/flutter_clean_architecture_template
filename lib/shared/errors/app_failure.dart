import 'package:equatable/equatable.dart';

/// Everything that can go wrong, as the app understands it.
///
/// The data layer throws these, services return them inside `Failable`, and
/// widgets turn them into text with `failure.toMessage(context.l10n)`. The
/// hierarchy is sealed: adding a failure makes the compiler list every
/// `switch` that has to handle it.
sealed class AppFailure extends Equatable implements Exception {
  const new();

  @override
  List<Object?> get props => [];
}

/// The device is offline or the server can't be reached.
final class NoConnectionFailure extends AppFailure {
  const new();
}

/// The server didn't answer in time.
final class TimeoutFailure extends AppFailure {
  const new();
}

/// The server answered with an error status or a body the app can't read.
final class ServerFailure extends AppFailure {
  const new({this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [statusCode];
}

/// The session is missing or expired and couldn't be renewed.
final class UnauthorizedFailure extends AppFailure {
  const new();
}

/// The username or password is wrong.
final class InvalidCredentialsFailure extends AppFailure {
  const new();
}

/// Data stored on the device couldn't be read or written.
final class StorageFailure extends AppFailure {
  const new();
}

/// A bug or an error nobody planned for. [cause] is kept for logs only and
/// doesn't take part in equality.
final class UnexpectedFailure extends AppFailure {
  const new([this.cause]);

  final Object? cause;
}
