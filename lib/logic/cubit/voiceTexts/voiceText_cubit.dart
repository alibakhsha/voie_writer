import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';
import '../../device_registration.dart';
import '../../event/voiceTextsList/textList_event.dart';
import '../../models/user_model/JwtToken.dart';
import '../../state/textList_state.dart';
import '../../state/voiceTextsList/textList_state.dart';

class VoiceTextCubit extends Cubit<VoiceTextState> {
  final ApiService _apiService;
  // final DeviceRegistration _deviceRegistration;

  VoiceTextCubit() : _apiService = ApiService(), super(VoiceTextInitial());

  Future<void> initialize(String deviceId) async {
    emit(VoiceTextLoading());
    final deviceReg = DeviceRegistration(_apiService);
    try {
      final token = await deviceReg.authenticateDevice(deviceId);
      if (token != null) {
        print("توکن ست شد - Access: ${token.access}");
        await fetchVoiceTexts();
      } else {
        emit(VoiceTextError('احراز هویت ناموفق'));
      }
    } catch (e) {
      emit(VoiceTextError('خطا در مقداردهی اولیه: $e'));
    }
  }

  Future<void> fetchVoiceTexts() async {
    emit(VoiceTextLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      print("توکن قبل از درخواست: $accessToken");
      if (accessToken == null) {
        emit(VoiceTextError('لطفاً ابتدا دستگاه را احراز هویت کنید'));
        return;
      }
      final voices = await _apiService.getVoiceToText();

      emit(VoiceTextLoaded(voices ?? []));
    } catch (e) {
      emit(VoiceTextError('خطا در گرفتن داده‌ها: $e'));
    }
  }

  // Future <void> deleteVoiceText(int index)async{
  //
  //
  //
  //   if (index < 0 || index >= state.length) {
  //
  //     return;
  //   }
  //
  //   List<Map<String, String>> updatedList = List.from(state);
  //
  //   updatedList.removeAt(index);
  //
  //   emit(updatedList);
  //
  // }
}

class MoveBloc extends Bloc<MoveEvent, MoveState> {
  MoveBloc()
    : super(MoveState(selectedIndex: -1, positions: {}, leftPosition: 0.0)) {
    on<MoveEvent>((event, emit) {
      Map<int, double> newPositions = Map.from(state.positions);
      if (state.selectedIndex == event.index) {
        emit(
          MoveState(
            selectedIndex: -1,
            positions: state.positions,
            leftPosition: 0.0,
          ),
        );
      } else {
        newPositions[event.index] =
            (newPositions[event.index] ?? 0.0) == 0.0 ? -42.0 : 0.0;
        emit(
          MoveState(
            selectedIndex: event.index,
            positions: newPositions,
            leftPosition: newPositions[event.index] ?? 0.0,
          ),
        );
      }
    });

    on<ResetMoveEvent>((event, emit) {
      emit(MoveState(selectedIndex: -1, positions: {}, leftPosition: 0.0));
    });
  }
}
