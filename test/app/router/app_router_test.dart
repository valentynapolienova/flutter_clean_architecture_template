import 'package:clean_architecture_template/app/router/app_router.dart';
import 'package:clean_architecture_template/app/router/routes.dart';
import 'package:clean_architecture_template/features/auth/presentation/cubits/session/session_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_data.dart';

void main() {
  group('redirectForSession', () {
    test(
      'holds every page on the splash screen while the session is unknown',
      () {
        expect(
          redirectForSession(const SessionUnknown(), Routes.posts),
          Routes.splash,
        );
        expect(
          redirectForSession(const SessionUnknown(), Routes.splash),
          isNull,
        );
      },
    );

    test('sends signed-out users to login', () {
      expect(
        redirectForSession(const SessionSignedOut(), Routes.postDetails(3)),
        Routes.login,
      );
      expect(
        redirectForSession(const SessionSignedOut(), Routes.login),
        isNull,
      );
    });

    test('moves signed-in users off splash and login only', () {
      const session = SessionSignedIn(testUser);

      expect(redirectForSession(session, Routes.login), Routes.posts);
      expect(redirectForSession(session, Routes.splash), Routes.posts);
      expect(redirectForSession(session, Routes.postDetails(3)), isNull);
    });
  });
}
