import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_template/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture_template/features/auth/presentation/pages/login_page.dart';
import 'package:clean_architecture_template/shared/errors/app_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/pump_app.dart';

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit;

void main() {
  late MockLoginCubit cubit;

  setUp(() {
    cubit = MockLoginCubit();
    when(
      () => cubit.signIn(
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpPage(
    WidgetTester tester, [
    LoginState state = const LoginIdle(),
  ]) {
    whenListen(cubit, const Stream<LoginState>.empty(), initialState: state);
    return tester.pumpApp(
      BlocProvider<LoginCubit>.value(value: cubit, child: const LoginPage()),
    );
  }

  final signInButton = find.widgetWithText(FilledButton, 'Sign in');

  group('LoginPage', () {
    testWidgets('asks for both fields before signing in', (tester) async {
      await pumpPage(tester);

      await tester.tap(signInButton);
      await tester.pump();

      expect(find.text('This field is required.'), findsNWidgets(2));
      verifyNever(
        () => cubit.signIn(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      );
    });

    testWidgets('signs in with the demo account', (tester) async {
      await pumpPage(tester);

      await tester.tap(find.text('Use demo account'));
      await tester.tap(signInButton);

      verify(
        () => cubit.signIn(
          username: LoginPage.demoUsername,
          password: LoginPage.demoPassword,
        ),
      ).called(1);
    });

    testWidgets('shows why signing in failed', (tester) async {
      await pumpPage(tester, const LoginFailed(InvalidCredentialsFailure()));

      expect(find.text('Wrong username or password.'), findsOneWidget);
    });

    testWidgets('disables the button while signing in', (tester) async {
      await pumpPage(tester, const LoginInProgress());

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });
  });
}
