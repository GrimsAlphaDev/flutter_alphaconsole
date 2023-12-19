import 'package:alphaconsole/cubit/state/detail_state.dart';
import 'package:alphaconsole/models/Console_model.dart';
import 'package:alphaconsole/services/api/cart_service.dart';
import 'package:alphaconsole/services/api/console_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailConsoleCubit extends Cubit<DetailState> {
  DetailConsoleCubit() : super(DetailInitial());

  final ConsoleService _consoleService = ConsoleService();
  final CartService _cartService = CartService();

  Future<void> getConsole({
    required String id,
  }) async {
    emit(DetailInitial());
    try {
      ConsoleModel consoles;

      final Response response = await _consoleService.getConsole(
        id: id,
      );

      consoles = ConsoleModel.fromJson(response.data["data"]);

      emit(DetailLoadedState(detailConsole: consoles));
    } catch (e) {
      emit(DetailErrorState(message: e.toString()));
    }
  }

  Future<List<dynamic>> addToCart({
    required int consoleId,
  }) async {
    try {
      final Response response = await _cartService.addToCart(id: consoleId);

      if (response.data["status"] == "success") {
        return [true, response.data["message"]];
      } else {
        return [false, response.data["message"]];
      }
    } catch (e) {
      return [false, e.toString()];
    }
  }
}
