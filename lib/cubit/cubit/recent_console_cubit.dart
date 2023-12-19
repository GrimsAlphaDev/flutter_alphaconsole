import 'package:alphaconsole/cubit/state/recent_console_state.dart';
import 'package:alphaconsole/models/Console_model.dart';
import 'package:alphaconsole/services/api/console_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentConsoleCubit extends Cubit<RecentState> {
  RecentConsoleCubit() : super(RecentInitial());

  final ConsoleService _consoleService = ConsoleService();

  Future<void> getRecentConsole({
    required String brandId,
  }) async {
    emit(RecentLoadingState());
    try {
      List<ConsoleModel> consoles = [];

      final Response response = await _consoleService.getConsoles();
      for (var console in response.data['data']) {
        consoles.add(ConsoleModel.fromJson(console));
      }
      // ignore: unrelated_type_equality_checks
      List<ConsoleModel> filteredConsoles = consoles
          // ignore: unrelated_type_equality_checks
          .where((console) => console.brand_id == brandId)
          .toList()
        ..sort((a, b) => b.year.compareTo(a.year));
      // print("filter : $filteredConsoles");
      // print(consoles.length);
      emit(RecentLoadedState(recentConsoles: filteredConsoles));
    } catch (e) {
      emit(RecentErrorState(message: e.toString()));
    }
  }

  Future<void> searchConsole(
      {required String keyword, required String brandId}) async {
    try {
      List<ConsoleModel> consoles = [];

      final Response response =
          await _consoleService.searchConsole(keyword: keyword);

      for (var console in response.data['data']) {
        consoles.add(ConsoleModel.fromJson(console));
      }

      // ignore: unrelated_type_equality_checks
      List<ConsoleModel> filteredConsoles = consoles
          // ignore: unrelated_type_equality_checks
          .where((console) => console.brand_id == brandId)
          .toList()
        ..sort((a, b) => b.year.compareTo(a.year));

      emit(RecentLoadedState(recentConsoles: filteredConsoles));
    } catch (e) {
      emit(RecentErrorState(message: e.toString()));
    }
  }
}
