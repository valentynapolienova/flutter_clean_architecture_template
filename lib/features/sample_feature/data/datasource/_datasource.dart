import 'package:dio/dio.dart';

abstract class Datasource {
  Future<bool> getFunction();
}

class DatasourceImpl implements Datasource {
  final Dio dio;

  DatasourceImpl({required this.dio});

  @override
  Future<bool> getFunction() async {
    final response = await dio.get(
      '/function',
    );
    return response.data;
  }
}
