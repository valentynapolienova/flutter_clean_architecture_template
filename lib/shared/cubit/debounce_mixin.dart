import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Delays an action until calls stop arriving, e.g. search as you type.
mixin DebounceMixin<S> on Cubit<S> {
  Timer? _debounceTimer;

  /// Runs [action] once [delay] has passed without another [debounce] call.
  /// A pending action is dropped when the cubit closes.
  void debounce(Duration delay, void Function() action) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () {
      if (!isClosed) action();
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
