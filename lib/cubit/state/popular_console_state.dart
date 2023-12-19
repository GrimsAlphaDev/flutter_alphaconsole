import 'package:alphaconsole/models/Console_model.dart';
import 'package:equatable/equatable.dart';

abstract class PopularState extends Equatable {
  const PopularState();

  @override
  List<Object> get props => [];
}

class PopularInitial extends PopularState {}

class PopularLoadingState extends PopularState {}

class PopularLoadedState extends PopularState {
  final List<ConsoleModel> popularConsoles;

  const PopularLoadedState({required this.popularConsoles});

  @override
  List<Object> get props => [popularConsoles];
}

class PopularErrorState extends PopularState {
  final String message;

  const PopularErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
