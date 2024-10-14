import 'package:bloc/bloc.dart';

class ThemeBloc extends Cubit<bool> {
  ThemeBloc() : super(false);

  void themeConvert() => emit(!state);
}
