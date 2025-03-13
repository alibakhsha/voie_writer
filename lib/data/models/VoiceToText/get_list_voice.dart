

part 'get_list_voice.g.dart';


class GetListVoice  {

  final int id;


  final int user;


  final String title;


  final String transcript;

  final String created_at;

  GetListVoice({
    required this.id,
    required this.user,
    required this.title,
    required this.transcript,
    required this.created_at,
  });

  factory GetListVoice.fromJson(Map<String, dynamic> json) {
    return GetListVoice(
      id: json['id'] as int,
      user: json['user'] as int,
      title: json['audio'] as String,
      transcript: json['transcript'] as String,
      created_at: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'audio': title,
      'transcript': transcript,
      'created_at': created_at,
    };
  }
}