import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_template/shared/errors/app_failure.dart';
import 'package:clean_architecture_template/shared/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockSettingsStorage storage;

  setUp(() {
    storage = MockSettingsStorage();
  });

  group('ThemeCubit', () {
    blocTest<ThemeCubit, ThemeMode>(
      'restores the saved theme mode',
      setUp: () =>
          when(() => storage.readThemeMode()).thenAnswer((_) async => 'dark'),
      build: () => ThemeCubit(storage),
      act: (cubit) => cubit.restoreThemeMode(),
      expect: () => const [ThemeMode.dark],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'stays on the system mode when nothing is saved',
      setUp: () =>
          when(() => storage.readThemeMode()).thenAnswer((_) async => null),
      build: () => ThemeCubit(storage),
      act: (cubit) => cubit.restoreThemeMode(),
      expect: () => const <ThemeMode>[],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'stays on the system mode when storage fails',
      setUp: () =>
          when(() => storage.readThemeMode()).thenThrow(const StorageFailure()),
      build: () => ThemeCubit(storage),
      act: (cubit) => cubit.restoreThemeMode(),
      expect: () => const <ThemeMode>[],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'changes and saves the theme mode',
      setUp: () =>
          when(() => storage.writeThemeMode(any())).thenAnswer((_) async {}),
      build: () => ThemeCubit(storage),
      act: (cubit) => cubit.changeThemeMode(ThemeMode.light),
      expect: () => const [ThemeMode.light],
      verify: (_) => verify(() => storage.writeThemeMode('light')).called(1),
    );
  });
}
