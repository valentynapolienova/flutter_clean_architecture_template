import 'dart:async';

import 'package:clean_architecture_template/features/auth/application/auth_service.dart';
import 'package:clean_architecture_template/features/auth/domain/user.dart';
import 'package:clean_architecture_template/shared/cubit/emit_guard_mixin.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'session_state.dart';

/// App-wide sign-in state. The router listens to it to guard pages.
class SessionCubit extends Cubit<SessionState> with EmitGuardMixin {
  new(this._authService) : super(const SessionUnknown()) {
    _userChanges = _authService.userChanges.listen(_applyUser);
  }

  final AuthService _authService;
  late final StreamSubscription<User?> _userChanges;

  /// Resolves the session stored on the device. When it can't be loaded, for
  /// example offline, the user lands on the login page.
  Future<void> restore() async {
    final result = await _authService.restoreSession();
    _applyUser(result.valueOrNull);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  void _applyUser(User? user) {
    emitIfOpen(user == null ? const SessionSignedOut() : SessionSignedIn(user));
  }

  @override
  Future<void> close() async {
    await _userChanges.cancel();
    await super.close();
  }
}
