import 'package:equatable/equatable.dart';

import 'error_model.dart';

class Failure extends Equatable {
  @override
  List<Object> get props => [];

  final String errorMessage;
  final List<ErrorModel>? errorData;
  final int? errorCode;

  Failure(
      {this.errorMessage = 'Unexpected error occurred',
      this.errorCode,
      this.errorData});

  @override
  String toString() {
    return "Failure(errorMessage: $errorMessage, errorData $errorData, errorCode: $errorCode)";
  }
}

// General failures
class InternetConnectionFailure extends Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class TestFailure extends Failure {}

class EmailConfirmationFailure extends Failure {}

// Hive failures
class HiveGetFailure extends Failure {}

class HiveDeleteFailure extends Failure {}

class HiveSetFailure extends Failure {}

// Authfailure
class LogInFailure extends Failure {}

class SignUpFailure extends Failure {}

class CheckEmailFailure extends Failure {}

class IncorrectEmailFailure extends Failure {}

class IncorrectPasswordFailure extends Failure {}

class ResetCodePasswordFailure extends Failure {}

class GoogleSignUpFailure extends Failure {}

class AppleSignUpFailure extends Failure {}

class UnauthorizedFailure extends Failure {}

class ProfileFailure extends Failure {}
