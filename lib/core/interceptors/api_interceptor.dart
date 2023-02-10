// import 'package:circleup/core/error/failures.dart';
// import 'package:circleup/core/presentation/widgets/notifications.dart';
// import 'package:circleup/features/authorization/presentation/blocs/auth_bloc/auth_bloc.dart';
// import 'package:circleup/injection_container.dart';
// import 'package:dio/dio.dart';
// import 'package:fimber/logart';
//
// class ApiInterceptor extends Interceptor {
//   @override
//   Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
//     if (err.requestOptions.path == '/user/auth/obtain-token') {
//    Fimber.e('AuthError: obtain token error - $err');
//       if (err.response?.statusCode == 401) {
//         final code = err.response?.data['code'];
//
//         if (code == 'authentication_failed') {
//        Fimber.e('AuthError: account does not exist on backend');
//           sl<AuthBloc>().add(NoAccountOnBackendEvent());
//         }
//       } else if (err.response?.statusCode == 400) {
//      Fimber.e('AuthError: logged out');
//         sl<AuthBloc>().add(UnAuthenticateEvent());
//       }
//     } else if (err.requestOptions.path.contains('refresh-token')) {
//       final code = err.response?.data['code'];
//       if (err.response?.statusCode == 401 && code == 'token_not_valid') {
//         Notifications.error(failure: RefreshTokenApiAuthFailure());
//
//         sl<AuthBloc>().add(UnAuthenticateEvent());
//       }
//     }
//
//     super.onError(err, handler);
//   }
// }
