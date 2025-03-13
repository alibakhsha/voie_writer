part of 'get_list_voice.dart';


class GetListVoiceAdapter {
  @override
  final int typeId = 0;

  @override
  GetListVoice read( reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GetListVoice(
      id: fields[0] as int,
      user: fields[1] as int,
      title: fields[2] as String,
      transcript: fields[3] as String,
      created_at: fields[4] as String,
    );
  }

  @override
  void write( writer, GetListVoice obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.transcript)
      ..writeByte(4)
      ..write(obj.created_at);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GetListVoiceAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
