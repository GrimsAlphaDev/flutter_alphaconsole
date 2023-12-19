import 'package:alphaconsole/models/Console_model.dart';
import 'package:equatable/equatable.dart';

abstract class RecentState extends Equatable {
  const RecentState();

  @override
  List<Object> get props => [];
}

class RecentInitial extends RecentState {}

class RecentLoadingState extends RecentState {}

class RecentLoadedState extends RecentState {
  final List<ConsoleModel> recentConsoles;

  const RecentLoadedState({required this.recentConsoles});

  @override
  List<Object> get props => [recentConsoles];
}

class RecentErrorState extends RecentState {
  final String message;

  const RecentErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
