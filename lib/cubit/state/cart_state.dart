import 'package:alphaconsole/models/Console_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<ConsoleModel> consoles;

  const CartLoadedState({required this.consoles});

  @override
  List<Object> get props => [consoles];
}

class CartErrorState extends CartState {
  final String message;

  const CartErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
