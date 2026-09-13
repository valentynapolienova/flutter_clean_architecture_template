import 'dart:async';

import 'package:clean_architecture_template/app/di/service_locator.dart';
import 'package:clean_architecture_template/app/router/routes.dart';
import 'package:clean_architecture_template/app/router/stream_listenable.dart';
import 'package:clean_architecture_template/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture_template/features/auth/presentation/cubits/session/session_cubit.dart';
import 'package:clean_architecture_template/features/auth/presentation/pages/login_page.dart';
import 'package:clean_architecture_template/features/auth/presentation/pages/splash_page.dart';
import 'package:clean_architecture_template/features/posts/presentation/cubits/post_details/post_details_cubit.dart';
import 'package:clean_architecture_template/features/posts/presentation/cubits/posts_list/posts_list_cubit.dart';
import 'package:clean_architecture_template/features/posts/presentation/pages/post_details_page.dart';
import 'package:clean_architecture_template/features/posts/presentation/pages/posts_page.dart';
import 'package:clean_architecture_template/shared/widgets/not_found_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Builds the app's router.
///
/// Screen cubits are created in the route builders, a fresh one per visit,
/// so pages only read them from the widget tree.
GoRouter createRouter({required SessionCubit sessionCubit}) {
  return GoRouter(
    initialLocation: Routes.posts,
    refreshListenable: StreamListenable(sessionCubit.stream),
    redirect: (context, state) =>
        redirectForSession(sessionCubit.state, state.matchedLocation),
    errorBuilder: (context, state) =>
        NotFoundPage(onGoHome: () => context.go(Routes.posts)),
    routes: [
      GoRoute(path: '/', redirect: (_, _) => Routes.posts),
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(
        path: Routes.login,
        builder: (_, _) => BlocProvider(
          create: (_) => LoginCubit(sl()),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: Routes.posts,
        builder: (_, _) => BlocProvider(
          create: (_) =>
              _started(PostsListCubit(sl()), (cubit) => cubit.loadFirstPage()),
          child: const PostsPage(),
        ),
        routes: [
          GoRoute(
            path: ':${Routes.postIdParam}',
            redirect: (_, state) =>
                _postId(state) == null ? Routes.posts : null,
            builder: (_, state) {
              final postId = _postId(state)!;
              return BlocProvider(
                create: (_) => _started(
                  PostDetailsCubit(sl()),
                  (cubit) => cubit.load(postId),
                ),
                child: PostDetailsPage(postId: postId),
              );
            },
          ),
        ],
      ),
    ],
  );
}

/// Keeps every page behind the splash screen until the stored session is
/// checked, sends signed-out users to login, and moves signed-in users away
/// from splash and login. Every other route requires a signed-in user.
@visibleForTesting
String? redirectForSession(SessionState session, String location) {
  final isPublicPage = location == Routes.splash || location == Routes.login;
  return switch (session) {
    SessionUnknown() => location == Routes.splash ? null : Routes.splash,
    SessionSignedOut() => location == Routes.login ? null : Routes.login,
    SessionSignedIn() => isPublicPage ? Routes.posts : null,
  };
}

int? _postId(GoRouterState state) =>
    int.tryParse(state.pathParameters[Routes.postIdParam] ?? '');

/// Starts a cubit's first load without blocking the route builder.
C _started<C>(C cubit, Future<void> Function(C cubit) load) {
  unawaited(load(cubit));
  return cubit;
}
