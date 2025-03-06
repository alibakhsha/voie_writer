class MoveState {
  final double leftPosition;

  final int selectedIndex;
  final Map<int, double> positions;

  MoveState({required this.leftPosition,
    required this.selectedIndex,
    required this.positions});
}