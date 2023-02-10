import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:dio/dio.dart';

class ResponseInterceptor extends Interceptor {
  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    if (response.data is Json && response.data.containsKey("data")) {
      response.data = response.data["data"];
    }

    super.onResponse(response, handler);
  }
}
