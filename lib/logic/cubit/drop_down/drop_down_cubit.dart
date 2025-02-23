import 'package:flutter_bloc/flutter_bloc.dart';

class  DropDownCubit extends Cubit<bool>{
  DropDownCubit(): super(false);

  void toggleDropdown() => emit(!state);
  void closeDropdown() => emit(false);
}