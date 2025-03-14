import 'dart:ui';

class HighlightedText {
  final String text;
  final List<HighlightRange> highlights;

  HighlightedText({required this.text, required this.highlights});

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'highlights': highlights.map((h) => h.toJson()).toList(),
    };
  }

  factory HighlightedText.fromJson(Map<String, dynamic> json) {
    return HighlightedText(
      text: json['text'],
      highlights: (json['highlights'] as List)
          .map((h) => HighlightRange.fromJson(h))
          .toList(),
    );
  }
}

class HighlightRange {
  final int start;
  final int end;
  final Color color;

  HighlightRange({required this.start, required this.end, required this.color});

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'color': color.value,
    };
  }

  factory HighlightRange.fromJson(Map<String, dynamic> json) {
    return HighlightRange(
      start: json['start'],
      end: json['end'],
      color: Color(json['color']),
    );
  }
}