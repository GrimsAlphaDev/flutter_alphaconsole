import 'package:alphaconsole/constants/constant.dart';
import 'package:alphaconsole/interceptor/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthentificationService {
  final Dio _dio = DioInterceptor().dio;

  Future<Response> getToken({
    required String email,
    required String password,
  }) async {
    final Response response = await _dio.post("${Constant.baseUrl}oauth/token",
        data: {
          "grant_type": "password",
          "client_id": "2",
          "client_secret": "Uevn1hFQuTb4D0KInvXB3p5fQJYuwJUgDkXvBeiZ",
          "username": email,
          "password": password,
          "scrope": "*"
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    return response;
  }

  Future<Response> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Response response = await _dio.get(
      "${Constant.baseUrl}api/v1/getUser",
      // add header authorization
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
      ),
    );

    return response;
  }

  Future<Response> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final Response response = await _dio.post(
      "${Constant.baseUrl}api/v1/register",
      data: {
        "username": username,
        "email": email,
        "password": password,
      },
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    return response;
  }

  Future<Response> checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Response response = await _dio.get(
      "${Constant.baseUrl}api/v1/checkToken",
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
      ),
    );

    return response;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _dio.get(
      "${Constant.baseUrl}api/v1/logout",
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
  }
}
