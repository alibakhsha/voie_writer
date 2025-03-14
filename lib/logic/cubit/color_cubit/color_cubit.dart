import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/HighlightedText.dart';
import 'color_state.dart';

class ColorCubit extends Cubit<ColorState> {
  ColorCubit() : super(ColorState.initial());

  void setSelection(TextSelection selection) {
    emit(state.copyWith(selectedText: selection));
  }

  void highlightSelection(Color color) {
    if (state.selectedText != null) {
      final newHighlights = List<HighlightRange>.from(state.highlights)
        ..add(HighlightRange(
          start: state.selectedText!.start,
          end: state.selectedText!.end,
          color: color,
        ));
      emit(state.copyWith(
        highlights: newHighlights,
        selectedColor: color,
        isPaletteOpen: false,
      ));
    }
  }

  void togglePalette() {
    emit(state.copyWith(isPaletteOpen: !state.isPaletteOpen));
  }
}