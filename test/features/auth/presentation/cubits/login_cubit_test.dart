import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_template/features/auth/domain/user.dart';
import 'package:clean_architecture_template/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture_template/shared/errors/app_failure.dart';
import 'package:clean_architecture_template/shared/result/failable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService();
  });

  group('LoginCubit', () {
    blocTest<LoginCubit, LoginState>(
      'signs in with a trimmed username',
      setUp: () =>
          when(() => authService.signIn(username: 'emilys', password: 'secret'))
              .thenAnswer((_) async => const Succeeded(testUser)),
      build: () => LoginCubit(authService),
      act: (cubit) => cubit.signIn(username: '  emilys ', password: 'secret'),
      expect: () => const [LoginInProgress(), LoginSucceeded()],
    );

    blocTest<LoginCubit, LoginState>(
      'shows why signing in failed',
      setUp: () =>
          when(
            () => authService.signIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => const Failed<User>(InvalidCredentialsFailure()),
          ),
      build: () => LoginCubit(authService),
      act: (cubit) => cubit.signIn(username: 'emilys', password: 'wrong'),
      expect: () => const [
        LoginInProgress(),
        LoginFailed(InvalidCredentialsFailure()),
      ],
    );
  });
}
