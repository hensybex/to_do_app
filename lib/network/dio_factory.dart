import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_key.dart';
import 'auth_interceptor.dart';

class DioFactory {
  DioFactory._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://beta.mrdekk.ru/todobackend/",
        queryParameters: {
          //'api_key': apiKey,
          'Authorization': 'Bearer $apiKey',
        },
      ),
    );
    (dio.transformer as DefaultTransformer).jsonDecodeCallback =
        (string) => compute(_convertToJson, string);
    dio.interceptors.add(AuthInterceptor());
    return dio;
  }

  static dynamic _convertToJson(String string) => json.decode(string);
}
