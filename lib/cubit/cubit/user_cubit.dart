import 'package:alphaconsole/cubit/state/user_state.dart';
import 'package:alphaconsole/models/user_model.dart';
import 'package:alphaconsole/services/api/authentification_service.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCubit extends Cubit<UserState> {
  final AuthentificationService _authentificationService =
      AuthentificationService();

  UserCubit() : super(UserInitialState());

  // Future<void> getUser() async {
  //   emit(UserLoadingState());
  //   try {
  //     final Response response = await _authentificationService.getUserInfo();
  //     // convert data to model
  //     final user = UserModel.fromJson(response.data['data']);
  //     emit(UserLoadedState(user: user));
  //     // return user;
  //   } catch (e) {
  //     emit(UserErrorState(message: e.toString()));
  //   }
  // }

  Future<List> login(
      {required String email,
      required String password,
      required context}) async {
    List feedBackRes = [];

    emit(UserLoadingState());
    try {
      final Response response = await _authentificationService.getToken(
          email: email, password: password);

      if (response.statusCode == 400) {
        emit(const UserErrorState(message: "Email atau password salah"));
        feedBackRes = [false, "Email atau password salah"];
        return feedBackRes;
      }
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response.data["access_token"]);
        try {
          final Response response =
              await _authentificationService.getUserInfo();
          UserModel user = UserModel.fromJson(response.data['data']);
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
      final Response response = await _authentificationService.register(
          username: username, email: email, password: password);

      if (response.statusCode == 400) {
        emit(const UserErrorState(message: "Terjadi Kesalahan Input"));
        return [false, "Terjadi Kesalahan Input"];
      }

      // convert data to model
      final user = UserModel.fromJson(response.data["data"]);
      // print(user);
      emit(UserLoadedState(user: user));
      return [true, "Berhasil Register"];
    } catch (e) {
      // print(e);

      emit(UserErrorState(message: e.toString()));
      return [false, e.toString()];
    }
  }

  Future<bool> checkLogin() async {
    emit(UserLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token != null) {
      final Response response = await _authentificationService.checkToken();

      if (response.data['data'] == true) {
        // Navigator.pushReplacementNamed(
        //   context,
        //   '/app',
        // );
        return true;
      } else {
        await prefs.remove("token");
        // Navigator.pushReplacementNamed(
        //   context,
        //   '/login',
        // );
        return false;
      }
    }
    // Navigator.pushReplacementNamed(
    //   context,
    //   '/home',
    // );
    return false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await _authentificationService.logout();
      await prefs.remove("token");
    } catch (e) {
      print(e);
    }
  }
}
