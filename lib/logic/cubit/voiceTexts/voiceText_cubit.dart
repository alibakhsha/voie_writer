import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voie_writer/logic/cubit/voiceTexts/voiceText_cubit.dart' as _apiService;
import '../../../services/api_service.dart';
import '../../device_registration.dart';
import '../../event/voiceTextsList/textList_event.dart';
import '../../models/VoiceToText/get_list_voice.dart';
import '../../models/user_model/JwtToken.dart';
import '../../state/voiceTextsList/delet_voice_state.dart';
import '../../state/voiceTextsList/textList_state.dart';
import '../../state/voiceTextsList/Move_Text.dart';


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




Future<void> deleteVoiceText(String id) async {
  emit(VoiceTextLoading()); // استفاده از VoiceTextLoading برای هماهنگی

  try {
    final success = await _apiService.deleteVoice(id); // فراخوانی تابع اصلاح‌شده

    if (success) {
      final box = await Hive.openBox<GetListVoice>('voice_texts');
      final updatedList = box.values.where((voice) => voice.id != id).toList();
      await box.clear();
      await box.addAll(updatedList);
      emit(VoiceTextLoaded(updatedList)); // برگردوندن به VoiceTextLoaded
      print("حذف موفقیت‌آمیز بود - لیست جدید: $updatedList");
    } else {
      emit(VoiceTextError("حذف ناموفق بود: سرور پاسخ معتبر نداد"));
    }
  } catch (e) {
    emit(VoiceTextError("خطا در حذف: $e"));
  }
}}

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
