import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';
import '../../device_registration.dart';
import '../../event/voiceTextsList/textList_event.dart';
import '../../models/VoiceToText/get_list_voice.dart';
import '../../models/user_model/JwtToken.dart';
import '../../state/textList_state.dart';
import '../../state/voiceTextsList/textList_state.dart';


class VoiceTextCubit extends Cubit<VoiceTextState> {
  final ApiService _apiService;

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
  Future<bool> _isOnline() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print("اتصال به شبکه قطع است");
        return false;
      }


      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('https://www.google.com'));
      await request.close().timeout(Duration(seconds: 2));
      print("تست اتصال به سرور موفقیت‌آمیز بود");
      return true;
    } catch (e) {
      print("خطا توی چک کردن اینترنت: $e");
      return false;
    }
  }
  Future<void> fetchVoiceTexts() async {
    emit(VoiceTextLoading());
    print("شروع fetchVoiceTexts");
    final box = await Hive.openBox<GetListVoice>('voice_texts');

    try {
      print("چک کردن اتصال اینترنت...");
      if (await _isOnline()) {
        print("کاربر آنلاینه");
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('access_token');
        print("توکن: $accessToken");
        if (accessToken == null) {
          print("توکن پیدا نشد");
          emit(VoiceTextError('لطفاً ابتدا دستگاه را احراز هویت کنید'));
          return;
        }

        final voices = await _apiService.getVoiceToText();
        print("دیتا از سرور: $voices");
        if (voices != null) {

          await box.clear();
          await box.addAll(voices);
          emit(VoiceTextLoaded(voices));
        } else {
          emit(VoiceTextLoaded(voices ?? []));
        }
      } else {
        print("کاربر آفلاینه");

        final cachedVoices = box.values.toList();
        print("دیتای کش شده: $cachedVoices");
        if (cachedVoices.isNotEmpty) {
          emit(VoiceTextLoaded(cachedVoices));
        } else {
          emit(VoiceTextError('شما آفلاین هستید و داده‌ای در دسترس نیست'));
        }
      }
    } catch (e) {
      print("خطا توی fetchVoiceTexts: $e");

      final cachedVoices = box.values.toList();
      print("دیتای کش شده توی catch: $cachedVoices");
      if (cachedVoices.isNotEmpty) {
        emit(VoiceTextLoaded(cachedVoices));
      } else {
        emit(VoiceTextError('خطا در گرفتن داده‌ها: $e'));
      }
    }
  }
}





  // Future<void> fetchVoiceTexts() async {
  //   emit(VoiceTextLoading());
  //   final box = await Hive.openBox<GetListVoice>('voice_texts');
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final accessToken = prefs.getString('access_token');
  //     print("توکن قبل از درخواست: $accessToken");
  //     if (accessToken == null) {
  //       emit(VoiceTextError('لطفاً ابتدا دستگاه را احراز هویت کنید'));
  //       return;
  //     }
  //     // final ices = await _apiService.Delete();
  //     final voices = await _apiService.getVoiceToText();
  //
  //     emit(VoiceTextLoaded(voices ?? []));
  //   } catch (e) {
  //     emit(VoiceTextError('خطا در گرفتن داده‌ها: $e'));
  //   }
  // }

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
// }

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
