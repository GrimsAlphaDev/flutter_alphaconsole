import 'package:alphaconsole/constants/constant.dart';
import 'package:alphaconsole/cubit/state/user_state.dart';
import 'package:alphaconsole/interceptor/dio_interceptor.dart';
import 'package:alphaconsole/models/user_model.dart';
import 'package:alphaconsole/view/not_found_page.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCubit extends Cubit<UserState> {
  final Dio _dio = DioInterceptor().dio;

  UserCubit() : super(UserInitialState());

  Future<void> getUser() async {
    emit(UserLoadingState());
    try {
      final Response response = await _dio.get("${Constant.baseUrl}users/me");
      // convert data to model
      final user = UserModel.fromJson(response.data);
      emit(UserLoadedState(user: user));
    } catch (e) {
      emit(UserErrorState(message: e.toString()));
    }
  }

  Future<List> login(
      {required String email,
      required String password,
      required context}) async {
    List feedBackRes = [];

    emit(UserLoadingState());
    try {
      final Response response = await _dio.post("${Constant.baseUrl}auth/local",
          data: {
            "identifier": email,
            "password": password,
          },
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ));

      if (response.statusCode == 400) {
        emit(const UserErrorState(message: "Email atau password salah"));
        feedBackRes = [false, "Email atau password salah"];
        return feedBackRes;
      }

      // convert data to model
      final user = UserModel.fromJson(response.data["user"]);

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("jwt", response.data["jwt"]);
        // Rest of the code...
      } catch (e) {
        emit(const UserErrorState(message: "Gagal menyimpan token"));
        feedBackRes = [false, "Gagal menyimpan credentials"];
        return feedBackRes;
      }

      emit(UserLoadedState(user: user));
      feedBackRes = [true, "Berhasil Login"];
      return feedBackRes;
    } catch (e) {
      emit(UserErrorState(message: e.toString()));
      feedBackRes = [false, e.toString()];
      return feedBackRes;
    }
  }

  Future<List> register(
      {required String username,
      required String email,
      required String password}) async {
    emit(UserLoadingState());
    try {
      final Response response =
          await _dio.post("${Constant.baseUrl}auth/local/register",
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
              ));

      // print(response);
      // get jwt from response['jwt']

      if (response.statusCode == 400) {
        emit(const UserErrorState(message: "Terjadi Kesalahan Input"));
        return [false, "Terjadi Kesalahan Input"];
      }

      // convert data to model
      final user = UserModel.fromJson(response.data["user"]);

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("jwt", response.data["jwt"]);
      } catch (e) {
        emit(const UserErrorState(message: "Gagal menyimpan token"));
        return [false, "Gagal menyimpan credentials"];
      }

      emit(UserLoadedState(user: user));
      return [true, "Berhasil Register"];
    } catch (e) {
      emit(UserErrorState(message: e.toString()));
      return [false, e.toString()];
    }
  }

  Future<void> checkLogin(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString("jwt");
    if (jwt != null) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
      );
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt");
  }
}
