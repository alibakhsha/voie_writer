import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voie_writer/data/models/VoiceToText/get_list_voice.dart';
import '../../../data/services/api_service.dart';
import '../../device_registration.dart';
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
        await fetchVoiceList();
      } else {
        emit(VoiceTextError('احراز هویت ناموفق'));
      }
    } catch (e) {
      emit(VoiceTextError('خطا در مقداردهی اولیه: $e'));
    }
  }

  // تابع چک کردن اتصال اینترنت
  Future<bool> _isOnline() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print("etesla be server qate");
        return false;
      }
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('https://www.google.com'));
      await request.close().timeout(Duration(seconds: 2));
      print("teste ersal moafaq amize");
      return true;
    } catch (e) {
      print("khata to check kardane internet: $e");
      return false;
    }
  }

  /// دریافت لیست فایل‌های صوتی تبدیل‌شده از سرور
  Future<void> fetchVoiceList() async {
    emit(VoiceTextLoading());
    print("شروع fetchVoiceTexts");

    try {
      print("dar hale gereftane dade az server");
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      print("توکن: $accessToken");

      if (accessToken == null) {
        print("token peyda nashod");
        emit(VoiceTextError('لطفاً ابتدا دستگاه را احراز هویت کنید'));
        return;
      }

      final voices = await _apiService.fetchVoiceToText();
      print("data az server: $voices");
      if (voices != null) {
        emit(VoiceTextLoaded(voices));
      } else {
        emit(VoiceTextLoaded([]));
      }
    } catch (e) {
      print("khata dar fetchVoiceTexts: $e");
      emit(VoiceTextError('خطا در گرفتن داده‌ها: $e'));
    }
  }
  Future<void> recordAndSendVoice(String audioPath) async {
    emit(VoiceTextLoading());
    try {
      final result = await _apiService.uploadVoiceToText(audioPath);
      if (result != null) {
        final currentState = state;
        if (currentState is VoiceTextLoaded) {
          emit(VoiceTextLoaded([...currentState.voices, result]));
        } else {
          emit(VoiceTextLoaded([result]));
        }
      } else {
        emit(VoiceTextError('خطا در گرفتن متن'));
      }
    } catch (e) {
      emit(VoiceTextError('خطا: $e'));
    }
  }
  /// ارسال فایل صوتی به سرور و افزودن به لیست
  // Future<void> uploadVoiceText(String filePath) async {
  //   final response = await _apiService.uploadVoiceToText(filePath);
  //   if (response != null) {
  //     // تبدیل response از نوع VoiceToText به Map<String, dynamic>
  //     List<Map<String, dynamic>> updatedList = List.from(state);
  //     updatedList.add(response.toJson()); // اضافه کردن آیتم جدید به لیست
  //     emit(updatedList);
  //   } else {
  //     print("خطا در آپلود فایل صوتی");
  //   }
  // }

  /// حذف یک فایل صوتی هم از سرور و هم از لیست
  Future<void> deleteVoiceText(String id) async {
    emit(VoiceTextLoading());

    try {
      if (await _isOnline()) {
        final success = await _apiService.deleteVoiceText(id);
        if (success) {
          await fetchVoiceList();
          print("hazf moafaq amiz bod");
        } else {
          emit(VoiceTextError("حذف ناموفق بود: سرور پاسخ معتبر نداد"));
        }
      } else {
        emit(VoiceTextError('اتصال به اینترنت برقرار نیست'));
      }
    } catch (e) {
      emit(VoiceTextError("خطا در حذف: $e"));
    }
  }
}
