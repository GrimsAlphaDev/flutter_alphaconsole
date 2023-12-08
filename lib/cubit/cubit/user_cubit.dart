import 'package:alphaconsole/constants/constant.dart';
import 'package:alphaconsole/cubit/state/user_state.dart';
import 'package:alphaconsole/interceptor/dio_interceptor.dart';
import 'package:alphaconsole/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCubit extends Cubit<UserState> {
  final Dio _dio = DioInterceptor().dio;

  UserCubit() : super(UserInitialState());

  Future<UserModel> getUser() async {
    emit(UserLoadingState());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final Response response = await _dio.get(
        "${Constant.baseUrl}api/v1/",
        // add header authorization
        options: Options(
          headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
        ),
      );
      // convert data to model
      final user = UserModel.fromJson(response.data['data']);
      emit(UserLoadedState(user: user));
      return user;
    } catch (e) {
      emit(UserErrorState(message: e.toString()));
    }
    return UserModel(
      id: '0',
      username: "",
      email: "",
      image: '',
    );
  }

  Future<List> login(
      {required String email,
      required String password,
      required context}) async {
    List feedBackRes = [];

    emit(UserLoadingState());
    try {
      final Response response =
          await _dio.post("${Constant.baseUrl}oauth/token",
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

      if (response.statusCode == 400) {
        emit(const UserErrorState(message: "Email atau password salah"));
        feedBackRes = [false, "Email atau password salah"];
        return feedBackRes;
      }
      print(response.data["access_token"]);
      // convert data to model
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response.data["access_token"]);
        try {
          UserModel user = await getUser();
          emit(UserLoadedState(user: user));
        } catch (e) {
          emit(const UserErrorState(message: "Gagal menyimpan token"));
          feedBackRes = [false, "Gagal menyimpan credentials"];
          return feedBackRes;
        }
      } catch (e) {
        emit(const UserErrorState(message: "Gagal menyimpan token"));
        feedBackRes = [false, "Gagal menyimpan credentials"];
        return feedBackRes;
      }

      // emit(UserLoadedState(user: user));
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
    String? token = prefs.getString("token");

    if (token != null) {
      final Response response = await _dio.get(
        "${Constant.baseUrl}api/v1/checkToken",
        options: Options(
          headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
        ),
      );

      if (response.data['data'] == true) {
        Navigator.pushReplacementNamed(
          context,
          '/app',
        );
        return;
      } else {
        await prefs.remove("token");
        Navigator.pushReplacementNamed(
          context,
          '/login',
        );
        return;
      }
    }
    // Navigator.pushReplacementNamed(
    //   context,
    //   '/home',
    // );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
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
      await prefs.remove("token");
    } catch (e) {
      print(e);
    }
  }
}
