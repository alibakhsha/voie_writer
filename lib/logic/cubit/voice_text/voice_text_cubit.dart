import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voie_writer/data/models/voice_to_text_model.dart';
import 'package:voie_writer/logic/cubit/voice_text/voice_text_cubit.dart';

import '../../../data/database/database_helper.dart';
import '../../../data/services/api_service.dart';
import '../../device_registration.dart';
import '../../networkchecker.dart';
import '../../state/voiceTextsList/textList_state.dart';

class VoiceTextCubit extends Cubit<VoiceTextState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final ApiService _apiService;
  final NetworkChecker _NetworkChecker;

  VoiceTextCubit(this._NetworkChecker)
    : _apiService = ApiService(),
      super(VoiceTextInitial());

  /// دریافت لیست فایل‌های صوتی تبدیل‌شده از سرور
  Future<void> fetchVoiceList() async {
    emit(VoiceTextLoading());
    try {
      if (await _NetworkChecker.isOnline()) {

        List<VoiceToTextModel> voices = await _apiService.fetchVoiceToText();
                  for (var voice in voices) {
try {

  await _dbHelper.insertItem(voice.toJson());
}catch(e){

}

          }
        // if (voices != null) {
        //   emit(VoiceTextLoaded(voices));
        // } else {
        //   emit(VoiceTextLoaded([]));
        // }
      }
    } catch (e) {
      // print("khata dar fetchVoiceTexts: $e");
      emit(VoiceTextError('خطا در گرفتن داده‌ها: $e'));
    }
    final localVoices = await _dbHelper.getAllItems();
    final voiceModels =
    localVoices.map((map) => VoiceToTextModel.fromJson(map)).toList();
    if (voiceModels.isNotEmpty) {
      emit(VoiceTextLoaded(voiceModels));
    } else {
      emit(VoiceTextLoaded([]));
    }
  }

  Future<void> recordAndSendVoice(String audioPath, {String? title}) async {
    emit(VoiceTextLoading());
    try {
      final result = await _apiService.uploadVoiceToText(audioPath, title);
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

  /// حذف یک فایل صوتی هم از سرور و هم از لیست
  Future<void> deleteVoiceText(String id) async {
    emit(VoiceTextLoading());

    try {
      if (await _NetworkChecker.isOnline()) {
        final success = await _apiService.deleteVoiceText(id);
        if (success) {
          final itemId = int.parse(id);
          print('در حال حذف id: $itemId');
          final result = await _dbHelper.deleteItem(itemId);
          if (result > 0) {
            await fetchVoiceList();
            print("حذف موفق‌آمیز بود");
          } else {
            emit(VoiceTextError("حذف ناموفق بود: آیتم پیدا نشد"));
          }
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


// class VoiceTextCubitOffline extends Cubit<VoiceTextState> {
//   final DatabaseHelper _dbHelper = DatabaseHelper.instance;
//
//   VoiceTextCubitOffline(this._NetworkChecker, this._voiceTextCubit)
//     : super(VoiceTextInitial());
//   final NetworkChecker _NetworkChecker;
//   final VoiceTextCubit _voiceTextCubit;
//
//   Future<void> fetchVoiceList() async {
//     emit(VoiceTextLoading());
//     try {
//       final localVoices = await _dbHelper.getAllItems();
//       final voiceModels =
//           localVoices.map((map) => VoiceToTextModel.fromJson(map)).toList();
//
//       if (await _NetworkChecker.isOnline()) {
//         print("user is online");
//         await _voiceTextCubit.fetchVoiceList();
//         final cubitState = _voiceTextCubit.state;
//         if (cubitState is VoiceTextLoaded) {
//           // final localVoices = await _dbHelper.getAllItems();
//           // final localVoiceModels = localVoices.map((map) => VoiceToTextModel.fromJson(map)).toList();
//
//           // for (var voice in cubitState.voices) {
//           //
//           //   if (!localVoiceModels.any((local) => local.id == voice.id)) {
//           //     await _dbHelper.insertItem(voice.toJson());
//           //   }
//           //
//           // }
//
//           // final updatedVoices = await _dbHelper.getAllItems();
//           // final updatedVoiceModels = updatedVoices.map((map) => VoiceToTextModel.fromJson(map)).toList();
//           // emit(VoiceTextLoaded(updatedVoiceModels));
//         } else if (cubitState is VoiceTextError) {
//           emit(VoiceTextError(cubitState.message));
//         }
//       } else {
//         // final voices =await _dbHelper.getAllItems();
//         // final voiceModels = voices.map((map) => VoiceToTextModel.fromJson(map)).toList();
//         if (voiceModels.isNotEmpty) {
//           emit(VoiceTextLoaded(voiceModels));
//         } else {
//           emit(VoiceTextLoaded([]));
//         }
//       }
//     } catch (e) {
//       emit(VoiceTextError('خطا در گرفتن داده‌ها از دیتابیس: $e'));
//     }
//   }
//
//   Future<void> deleteVoiceText(String id) async {
//     emit(VoiceTextLoading());
//     try {
//       final itemId = int.parse(id);
//       print('در حال حذف id: $itemId');
//       final result = await _dbHelper.deleteItem(itemId);
//       if (result > 0) {
//         await fetchVoiceList();
//         print("حذف موفق‌آمیز بود");
//       } else {
//         emit(VoiceTextError("حذف ناموفق بود: آیتم پیدا نشد"));
//       }
//     } catch (e) {
//       emit(VoiceTextError("خطا در حذف: $e"));
//     }
//   }
// }
