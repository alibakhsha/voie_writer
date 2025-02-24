import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ColorState {
  final Color? selectedColor;
  final TextSelection? selectedText;
  final bool isPaletteOpen;

  ColorState({this.selectedColor, this.selectedText, this.isPaletteOpen = false});

  ColorState copyWith({Color? selectedColor, TextSelection? selectedText, bool? isPaletteOpen}) {
    return ColorState(
      selectedColor: selectedColor ?? this.selectedColor,
      selectedText: selectedText ?? this.selectedText,
      isPaletteOpen: isPaletteOpen ?? this.isPaletteOpen,
    );
  }
}