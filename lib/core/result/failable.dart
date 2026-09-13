import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:equatable/equatable.dart';

/// What a service call produced: [Succeeded] with a value or [Failed] with an
/// [AppFailure].
///
/// Services return it instead of throwing, so callers have to handle both
/// outcomes.
sealed class Failable<T> {
  const new();

  /// Calls [success] or [failure], depending on the outcome.
  R when<R>({
    required R Function(T value) success,
    required R Function(AppFailure failure) failure,
  }) => switch (this) {
    Succeeded(value: final result) => success(result),
    Failed(failure: final reason) => failure(reason),
  };

  /// The value when the call succeeded, otherwise `null`.
  T? get valueOrNull => switch (this) {
    Succeeded(value: final result) => result,
    Failed() => null,
  };
}

final class Succeeded<T> extends Failable<T> with Equatable {
  const new(this.value);

  final T value;

  @override
  List<Object?> get props => [value];
}

final class Failed<T> extends Failable<T> with Equatable {
  const new(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}

typedef FutureFailable<T> = Future<Failable<T>>;
