import 'package:flutter_bloc/flutter_bloc.dart';

import '../../event/search/search_event.dart';
import '../../state/search/search_state.dart';



class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState('')) {
    on<SearchEvent>((event, emit) {
      emit(SearchState(event.query));
    });
  }
}