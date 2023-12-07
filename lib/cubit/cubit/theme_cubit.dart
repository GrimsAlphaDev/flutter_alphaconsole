import 'package:alphaconsole/cubit/state/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  bool theme = false;

  void changeTheme() {
    theme = !theme;
    emit(ThemeLoadedState(theme: theme));
  }
}
