part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

final class LoginIdle extends LoginState {
  const new();
}

final class LoginInProgress extends LoginState {
  const new();
}

final class LoginSucceeded extends LoginState {
  const new();
}

final class LoginFailed extends LoginState {
  const new(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}
