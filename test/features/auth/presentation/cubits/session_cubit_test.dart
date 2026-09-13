import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_template/features/auth/domain/user.dart';
import 'package:clean_architecture_template/features/auth/presentation/cubits/session/session_cubit.dart';
import 'package:clean_architecture_template/shared/errors/app_failure.dart';
import 'package:clean_architecture_template/shared/result/failable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late MockAuthService authService;
  late StreamController<User?> userChanges;

  setUp(() {
    authService = MockAuthService();
    userChanges = StreamController<User?>();
    when(() => authService.userChanges).thenAnswer((_) => userChanges.stream);
  });

  tearDown(() => userChanges.close());

  group('SessionCubit', () {
    blocTest<SessionCubit, SessionState>(
      'restore signs in the stored user',
      setUp: () =>
          when(() => authService.restoreSession())
              .thenAnswer((_) async => const Succeeded(testUser)),
      build: () => SessionCubit(authService),
      act: (cubit) => cubit.restore(),
      expect: () => const [SessionSignedIn(testUser)],
    );

    blocTest<SessionCubit, SessionState>(
      'restore signs out when nothing is stored',
      setUp: () =>
          when(() => authService.restoreSession())
              .thenAnswer((_) async => const Succeeded<User?>(null)),
      build: () => SessionCubit(authService),
      act: (cubit) => cubit.restore(),
      expect: () => const [SessionSignedOut()],
    );

    blocTest<SessionCubit, SessionState>(
      'restore signs out when the session cannot be loaded',
      setUp: () => when(() => authService.restoreSession())
          .thenAnswer((_) async => const Failed<User?>(NoConnectionFailure())),
      build: () => SessionCubit(authService),
      act: (cubit) => cubit.restore(),
      expect: () => const [SessionSignedOut()],
    );

    blocTest<SessionCubit, SessionState>(
      'follows users announced by the auth service',
      build: () => SessionCubit(authService),
      act: (_) => userChanges
        ..add(testUser)
        ..add(null),
      wait: Duration.zero,
      expect: () => const [SessionSignedIn(testUser), SessionSignedOut()],
    );

    blocTest<SessionCubit, SessionState>(
      'signOut goes through the auth service',
      setUp: () =>
          when(() => authService.signOut())
              .thenAnswer((_) async => const Succeeded<void>(null)),
      build: () => SessionCubit(authService),
      act: (cubit) => cubit.signOut(),
      verify: (_) => verify(() => authService.signOut()).called(1),
    );
  });
}
