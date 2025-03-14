import 'package:flutter_bloc/flutter_bloc.dart';
import '../../state/voiceTextsList/Move_text.dart';


class HomeCubit extends Cubit<int> {
  HomeCubit() : super(2);

  void changePage(int index) => emit(index.clamp(0, 2));
}


class SearchState {
  final String query;
  SearchState(this.query);
}



class MoveCubit extends Cubit<MoveState> {
  MoveCubit()
      : super(MoveState(selectedIndex: -1, positions: {}, leftPosition: 0.0));

  void move(int index) {
    Map<int, double> newPositions = Map.from(state.positions);


    if (state.selectedIndex == index) {
      newPositions[index] = 0.0;
      emit(
        MoveState(
          selectedIndex: -1,
          positions: newPositions,
          leftPosition: 0.0,
        ),
      );
    } else {

      newPositions.forEach((key, value) {
        newPositions[key] = 0.0;
      });

      newPositions[index] = -42.0;
      emit(
        MoveState(
          selectedIndex: index,
          positions: newPositions,
          leftPosition: -42.0,
        ),
      );
    }
  }

  void reset() {
    emit(MoveState(selectedIndex: -1, positions: {}, leftPosition: 0.0));
  }
}