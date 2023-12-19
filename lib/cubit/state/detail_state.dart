import 'package:alphaconsole/models/Console_model.dart';
import 'package:equatable/equatable.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoadingState extends DetailState {}

class DetailLoadedState extends DetailState {
  final ConsoleModel detailConsole;

  const DetailLoadedState({required this.detailConsole});

  @override
  List<Object> get props => [detailConsole];
}

class DetailErrorState extends DetailState {
  final String message;

  const DetailErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
