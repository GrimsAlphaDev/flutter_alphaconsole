import 'package:alphaconsole/cubit/state/pages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PagesCubit extends Cubit<PageState> {
  PagesCubit() : super(PageInitial());

  int currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;
    emit(PageLoadedState(index: index));
  }
}
