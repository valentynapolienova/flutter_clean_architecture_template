part of 'session_cubit.dart';

sealed class SessionState extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

/// The stored session hasn't been checked yet.
final class SessionUnknown extends SessionState {
  const new();
}

final class SessionSignedIn extends SessionState {
  const new(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

final class SessionSignedOut extends SessionState {
  const new();
}
