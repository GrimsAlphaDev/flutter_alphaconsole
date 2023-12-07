import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeLoadingState extends ThemeState {}

class ThemeLoadedState extends ThemeState {
  final bool theme;

  const 
  ThemeLoadedState({required this.theme});

  @override
  List<Object> get props => [theme];
}

class ThemeErrorState extends ThemeState {
  final String message;

  const ThemeErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
