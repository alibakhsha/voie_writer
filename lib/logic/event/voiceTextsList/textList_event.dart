class MoveEvent {
  final int index;
MoveEvent(this.index);
}
class ResetMoveEvent extends MoveEvent {
  ResetMoveEvent() : super(-1);
}
abstract class VoiceTextEvent {}

class FetchVoiceTexts extends VoiceTextEvent {}