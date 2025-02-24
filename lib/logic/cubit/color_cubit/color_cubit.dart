import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'color_state.dart';

class ColorCubit extends Cubit<ColorState> {
  ColorCubit() : super(ColorState());

  void setSelection(TextSelection selection) {
    emit(state.copyWith(selectedText: selection));
  }

  void highlightSelection(Color color) {
    emit(state.copyWith(selectedColor: color, isPaletteOpen: false));
  }

  void togglePalette() {
    emit(state.copyWith(isPaletteOpen: !state.isPaletteOpen));
  }
}