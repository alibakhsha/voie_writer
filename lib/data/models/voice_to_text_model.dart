class VoiceToTextModel {
  final int id;
  final int user;
  final String audio;
  final String transcript;
  final DateTime createdAt;

  VoiceToTextModel({
    required this.id,
    required this.user,
    required this.audio,
    required this.transcript,
    required this.createdAt,
  });

  // تبدیل JSON به مدل
  factory VoiceToTextModel.fromJson(Map<String, dynamic> json) {
    return VoiceToTextModel(
      id: json['id'],
      user: json['user'],
      audio: json['audio'],
      transcript: json['transcript'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // تبدیل مدل به JSON (مثلاً برای ارسال درخواست POST)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'audio': audio,
      'transcript': transcript,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
