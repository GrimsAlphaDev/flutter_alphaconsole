import 'package:alphaconsole/constants/constant.dart';
import 'package:alphaconsole/interceptor/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsoleService {
  final Dio _dio = DioInterceptor().dio;

  Future<Response> getConsoles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Response response = await _dio.get(
      "${Constant.baseUrl}api/v1/getConsoles",
      // add header authorization
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
      ),
    );

    return response;
  }

  Future<Response> searchConsole({required String keyword}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Response response = await _dio.get(
      "${Constant.baseUrl}api/v1/searchConsole?keyword=$keyword",
      // add header authorization
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
      ),
    );

    return response;
  }

  Future<Response> getConsole({required String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Response response = await _dio.get(
      "${Constant.baseUrl}api/v1/getConsole/$id",
      // add header authorization
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
      ),
    );

    return response;
  }
}
