import 'package:hive/hive.dart';

part 'get_list_voice.g.dart'; // این خط باید باشه

@HiveType(typeId: 0)
class GetListVoice extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int user;

  @HiveField(2)
  final String audio;

  @HiveField(3)
  final String transcript;

  @HiveField(4)
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