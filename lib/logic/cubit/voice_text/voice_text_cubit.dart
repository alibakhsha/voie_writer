import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/api_service.dart';

class VoiceTextCubit extends Cubit<List<Map<String, dynamic>>> {
  final ApiService apiService;

  VoiceTextCubit(this.apiService) : super([]);

  /// دریافت لیست فایل‌های صوتی تبدیل‌شده از سرور
  Future<void> fetchVoiceList() async {
    final voices = await apiService.fetchVoiceToText();
    if (voices != null) {
      print("object");
      // تبدیل لیست از مدل VoiceToText به Map<String, dynamic>
      emit(voices.map((voice) => voice.toJson()).toList());
    } else {
      print("خطا در دریافت داده‌ها از سرور");
    }
  }

  /// ارسال فایل صوتی به سرور و افزودن به لیست
  Future<void> uploadVoiceText(String filePath) async {
    final response = await apiService.uploadVoiceToText(filePath);
    if (response != null) {
      // تبدیل response از نوع VoiceToText به Map<String, dynamic>
      List<Map<String, dynamic>> updatedList = List.from(state);
      updatedList.add(response.toJson()); // اضافه کردن آیتم جدید به لیست
      emit(updatedList);
    } else {
      print("خطا در آپلود فایل صوتی");
    }
  }

  /// حذف یک فایل صوتی هم از سرور و هم از لیست
  Future<void> deleteVoiceText(int index, String id) async {
    bool isDeleted = await apiService.deleteVoiceText(id);

    if (isDeleted) {
      List<Map<String, dynamic>> updatedList = List.from(state);
      updatedList.removeAt(index);
      emit(updatedList);
    } else {
      print("خطا در حذف آیتم از سرور");
    }
  }
}
