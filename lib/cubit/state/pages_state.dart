import 'package:equatable/equatable.dart';

abstract class PageState extends Equatable {
  const PageState();

  @override
  List<Object> get props => [];
}

class PageInitial extends PageState {}

class PageLoadingState extends PageState {}

class PageLoadedState extends PageState {
  final int index;

  const PageLoadedState({required this.index});

  @override
  List<Object> get props => [index];
}

class PageErrorState extends PageState {
  final String message;

  const PageErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
