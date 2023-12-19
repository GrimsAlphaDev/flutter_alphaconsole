import 'package:alphaconsole/constants/constant.dart';
import 'package:alphaconsole/interceptor/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  final Dio _dio = DioInterceptor().dio;

  Future<Response> getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Response response = await _dio.get(
      "${Constant.baseUrl}api/v1/getCarts",
      // add header authorization
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
      ),
    );

    return response;
  }

  Future<Response> addToCart({required id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Response response = await _dio.post(
      "${Constant.baseUrl}api/v1/addCart",
      // add header authorization
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
      ),
      data: {
        "console_id": id,
      },
    );

    return response;
  }
}
