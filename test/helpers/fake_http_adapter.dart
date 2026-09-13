import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Answers Dio requests in memory, so network code can be tested end to end.
class FakeHttpAdapter implements HttpClientAdapter {
  new(this.respond);

  final Future<ResponseBody> Function(RequestOptions options) respond;

  /// Every request seen so far, in order.
  final List<RequestOptions> requests = [];

  static ResponseBody json(Object? body, {int statusCode = 200}) {
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    requests.add(options);
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}
