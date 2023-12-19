import 'package:alphaconsole/cubit/state/popular_console_state.dart';
import 'package:alphaconsole/models/Console_model.dart';
import 'package:alphaconsole/services/api/console_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularConsoleCubit extends Cubit<PopularState> {
  PopularConsoleCubit() : super(PopularInitial());

  final ConsoleService _consoleService = ConsoleService();

  Future<void> getPopularConsole({
    required String brandId,
  }) async {
    emit(PopularLoadingState());
    try {
      List<ConsoleModel> consoles = [];

      final Response response = await _consoleService.getConsoles();
      for (var console in response.data['data']) {
        consoles.add(ConsoleModel.fromJson(console));
      }
      // ignore: unrelated_type_equality_checks
      List<ConsoleModel> popularConsole = consoles
          // ignore: unrelated_type_equality_checks
          .where((console) => console.brand_id == brandId)
          .toList()
        ..sort((a, b) => b.total_sales.compareTo(a.total_sales));

      emit(PopularLoadedState(popularConsoles: popularConsole));
    } catch (e) {
      emit(PopularErrorState(message: e.toString()));
    }
  }
}
