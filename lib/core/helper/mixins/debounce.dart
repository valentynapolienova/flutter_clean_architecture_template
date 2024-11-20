import 'dart:async';
import 'dart:ui';

mixin DebouncerMixin {
  Timer? _debounceTimer;

  void runDebounce(VoidCallback action, {required int milliseconds}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void disposeDebouncer() {
    _debounceTimer?.cancel();
  }
}
