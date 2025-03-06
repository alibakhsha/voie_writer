class MoveEvent {
  final int index;
MoveEvent(this.index);
}
class ResetMoveEvent extends MoveEvent {
  ResetMoveEvent() : super(-1);
}