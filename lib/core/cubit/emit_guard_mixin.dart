import 'package:flutter_bloc/flutter_bloc.dart';

/// Adds [emitIfOpen] for emitting after an `await`, when the cubit may have
/// been closed in the meantime (for example, the user left the page).
mixin EmitGuardMixin<S> on Cubit<S> {
  void emitIfOpen(S state) {
    if (!isClosed) emit(state);
  }
}
