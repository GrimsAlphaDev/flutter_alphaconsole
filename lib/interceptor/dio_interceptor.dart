import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioInterceptor {
  Dio get dio {
    Dio dio = Dio();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Lakukan sesuatu dengan response jika diperlukan
          return handler.next(response);
        },
        onError: (e, handler) {
          // Log or handle the error
          debugPrint('DioError: $e');
          return handler.reject(e);
        },
      ),
    );

    return dio;
  }
}
