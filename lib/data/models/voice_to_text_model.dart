class VoiceToTextModel {
  final int id;
  final int user;
  final String? title; // nullable
  final String transcript;
  final String created_at;

  VoiceToTextModel({
    required this.id,
    required this.user,
    this.title, // required حذف شده چون nullable هست
    required this.transcript,
    required this.created_at,
  });

  // تبدیل JSON به مدل
  factory VoiceToTextModel.fromJson(Map<String, dynamic> json) {
    return VoiceToTextModel(
      id: json['id'] as int,           // مطمئن می‌شیم int هست
      user: json['user'] as int,       // مطمئن می‌شیم int هست
      title: json['title'] as String?, // می‌تونه null باشه
      transcript: json['transcript'] as String,
      created_at: json['created_at'] as String,
    );
  }

  // تبدیل مدل به JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'title': title, // ممکنه null باشه و مشکلی نیست
      'transcript': transcript,
      'created_at': created_at,
    };
  }
}