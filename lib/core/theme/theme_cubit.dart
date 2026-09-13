import 'package:clean_architecture_template/core/cubit/emit_guard_mixin.dart';
import 'package:clean_architecture_template/core/result/repository_request_handler.dart';
import 'package:clean_architecture_template/core/storage/settings_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// App-wide light/dark/system choice, remembered between launches.
///
/// Settings carry no business rules, so this cubit uses the storage
/// directly instead of going through a service.
class ThemeCubit extends Cubit<ThemeMode> with EmitGuardMixin {
  new(this._storage) : super(.system);

  final SettingsStorage _storage;

  /// Applies the mode saved on a previous launch, if there is one.
  Future<void> restoreThemeMode() async {
    final result = await RepositoryRequestHandler<String?>()(
      request: _storage.readThemeMode,
    );
    final saved = ThemeMode.values.asNameMap()[result.valueOrNull];
    if (saved != null) emitIfOpen(saved);
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    emit(mode);
    await RepositoryRequestHandler<void>()(
      request: () => _storage.writeThemeMode(mode.name),
    );
  }
}
