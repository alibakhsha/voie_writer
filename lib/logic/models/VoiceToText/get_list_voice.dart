class GetListVoice {
  final int id;
  final int user;
  final String audio;
  final String transcript;
  final String createdAt;

  GetListVoice({
    required this.id,
    required this.user,
    required this.audio,
    required this.transcript,
    required this.createdAt,
  });

  factory GetListVoice.fromJson(Map<String, dynamic> json) {
    return GetListVoice(
      id: json['id'] as int,
      user: json['user'] as int,
      audio: json['audio'] as String,
      transcript: json['transcript'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'audio': audio,
      'transcript': transcript,
      'created_at': createdAt,
    };
  }
}