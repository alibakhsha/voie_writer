import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../data/models/HighlightedText.dart';

class ColorState {
  final TextSelection? selectedText;
  final Color? selectedColor;
  final bool isPaletteOpen;
  final List<HighlightRange> highlights;
  ColorState({
    this.selectedText,
    this.selectedColor,
    this.isPaletteOpen = false,
    this.highlights = const [],
  });

  ColorState.initial()
      : selectedText = null,
        selectedColor = null,
        isPaletteOpen = false,
        highlights = [];

  ColorState copyWith({
    TextSelection? selectedText,
    Color? selectedColor,
    bool? isPaletteOpen,
    List<HighlightRange>? highlights,
  }) {
    return ColorState(
      selectedText: selectedText ?? this.selectedText,
      selectedColor: selectedColor ?? this.selectedColor,
      isPaletteOpen: isPaletteOpen ?? this.isPaletteOpen,
      highlights: highlights ?? this.highlights,
    );
  }
}