import 'package:clean_architecture_template/core/models/server_error.dart';
import 'package:clean_architecture_template/core/network/network_info.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:dio/dio.dart';

import 'failures.dart';

Future<Failure> errorHandler(Object error, Failure? defaultFailure) async {
  try {
    //print(error);
    if (error is DioError) {
      //print(error);
      if (error.response != null) {
        if (error.response!.statusCode == 403 ||
            error.response!.statusCode == 401) {
          return UnauthorizedFailure();
        } else if (error.response!.statusCode == 403 &&
            defaultFailure is ProfileFailure) {
          return UnauthorizedFailure();
        }
        ServerError serverError =
            ServerError.fromJson(error.response?.data ?? {});
        return Failure(
            errorMessage: serverError.detail != null &&
                    serverError.detail!.isNotEmpty
                ? serverError.detail!
                : "Sorry, we cannot process your request at the moment. Please contact the support team.");
      }
    }

    NetworkInfo networkInfo = sl();
    if (!(await networkInfo.isConnected)) {
      return InternetConnectionFailure();
    }

    return defaultFailure!;
  } catch (err) {
    return Failure();
  }
}

class ServerException implements Exception {}

class CacheException implements Exception {}

class GetTokenException implements Exception {}
