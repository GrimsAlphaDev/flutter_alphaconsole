import 'package:alphaconsole/constants/constant.dart';
import 'package:alphaconsole/interceptor/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandService {
  final Dio _dio = DioInterceptor().dio;

  Future<Response> getBrands() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Response response = await _dio.get(
      "${Constant.baseUrl}api/v1/getBrands",
      // add header authorization
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
      ),
    );

    return response;
  }
}
