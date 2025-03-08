import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/search/search_state.dart';




class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState(''));


  void updateQuery(String query) {
    emit(SearchState(query));
  }
}

