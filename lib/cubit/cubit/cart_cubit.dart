import 'package:alphaconsole/cubit/state/cart_state.dart';
import 'package:alphaconsole/models/Console_model.dart';
import 'package:alphaconsole/services/api/cart_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final CartService _cartService = CartService();

  Future<void> getCart() async {
    emit(CartInitial());
    try {
      List<ConsoleModel> consoles = [];

      final Response response = await _cartService.getCart();

      for (var console in response.data['data']) {
        consoles.add(ConsoleModel.fromJson(console));
      }

      emit(CartLoadedState(consoles: consoles));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }
}
