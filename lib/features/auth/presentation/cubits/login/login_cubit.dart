import 'package:clean_architecture_template/core/cubit/emit_guard_mixin.dart';
import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/features/auth/application/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

/// State of the login form. Navigation after success is handled by the
/// router, which reacts to `SessionCubit`.
class LoginCubit extends Cubit<LoginState> with EmitGuardMixin {
  new(this._authService) : super(const LoginIdle());

  final AuthService _authService;

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    if (state is LoginInProgress) return;
    emit(const LoginInProgress());
    final result = await _authService.signIn(
      username: username.trim(),
      password: password,
    );
    emitIfOpen(
      result.when<LoginState>(
        success: (_) => const LoginSucceeded(),
        failure: LoginFailed.new,
      ),
    );
  }
}
