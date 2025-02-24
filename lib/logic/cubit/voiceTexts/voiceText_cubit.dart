import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../event/voiceTextsList/textList_event.dart';
import '../../state/voiceTextsList/textList_state.dart';

class VoiceTextCubit extends Cubit<List<Map<String, String>>> {
  VoiceTextCubit() : super([]);
  String? authToken;
  final String baseUrl = "https://caliber24.pythonanywhere.com";


  Future<void> fetchVoiceTexts() async {
    emit([]);
    await Future.delayed(Duration(seconds: 2));


    bool voices = true;

    if (voices) {
      emit([
        {
          "title": "عنوان فایل1",
          "description": "طراح گرافیک از این متن به عنوان عنصری از ترکیب بندی برای پر کردن صفحه  ",
          "date": "۱۴۰۲/۱۱/۳۰"
        },
        {
          "title": "2عنوان فایل",
          "description": "طراح گرافیک از این متن به عنوان عنصری از ترکیب بندی برای پر کردن صفحه  ",
          "date": "۱۴۰۲/۱۰/۲۰"
        },
        {
          "title": "عنوان فایل3",
          "description": "طراح گرافیک از این متن به عنوان عنصری از ترکیب بندی برای پر کردن صفحه  ",
          "date": "۱۴۰۲/۱۰/۲۰"
        },
        {
          "title": "4عنوان فایل",
          "description": "طراح گرافیک از این متن به عنوان عنصری از ترکیب بندی برای پر کردن صفحه  ",
          "date": "۱۴۰۲/۱۰/۲۰"
        },
        {
          "title": "عنوان فایل5",
          "description": "طراح گرافیک از این متن به عنوان عنصری از ترکیب بندی برای پر کردن صفحه  ",
          "date": "۱۴۰۲/۱۰/۲۰"
        },
        {
          "title": "6عنوان فایل",
          "description": "طراح گرافیک از این متن به عنوان عنصری از ترکیب بندی برای پر کردن صفحه  ",
          "date": "۱۴۰۲/۱۰/۲۰"
        },
        {
          "title": "عنوان فایل7",
          "description": "طراح گرافیک از این متن به عنوان عنصری از ترکیب بندی برای پر کردن صفحه  ",
          "date": "۱۴۰۲/۱۰/۲۰"
        },
      ]);
    } else {
      emit([]);
    }
  }

  Future <void> deleteVoiceText(int index)async{



    if (index < 0 || index >= state.length) {

      return;
    }

    List<Map<String, String>> updatedList = List.from(state);

    updatedList.removeAt(index);

    emit(updatedList);

  }

}

// class VoiceTextCubit extends Cubit<List<Map<String, dynamic>>> {
//   VoiceTextCubit() : super([]);
//
//   String? authToken; // توکن رو اینجا نگه می‌داریم
//   final String baseUrl = "https://caliber24.pythonanywhere.com";
//
//   // متد ورود
//   Future<bool> login(String username, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/token/'), // فرض بر اینه که این مسیر درسته
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'username': username,
//           'password': password,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         authToken = data['access']; // توکن دسترسی رو ذخیره می‌کنیم
//         return true;
//       } else {
//         print('خطا در ورود: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('خطای ورود: $e');
//       return false;
//     }
//   }
//
//   Future<void> fetchVoiceTexts() async {
//     if (authToken == null) {
//       print('لطفاً اول وارد شوید');
//       return;
//     }
//     try {
//       emit([]);
//       final response = await http.get(
//         Uri.parse('$baseUrl/voice-to-text/'),
//         headers: {
//           'Authorization': 'Bearer $authToken',
//           'Content-Type': 'application/json',
//         },
//       );
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         emit(data.map((item) => item as Map<String, dynamic>).toList());
//       } else {
//         emit([]);
//       }
//     } catch (e) {
//       emit([]);
//       print('خطا: $e');
//     }
//   }
//
//   Future<void> deleteVoiceText(int index) async {
//     if (authToken == null) return;
//     final itemId = state[index]['id'];
//     try {
//       final response = await http.delete(
//         Uri.parse('$baseUrl/voice-to-text/$itemId/'),
//         headers: {
//           'Authorization': 'Bearer $authToken',
//           'Content-Type': 'application/json',
//         },
//       );
//       if (response.statusCode == 200) {
//         final updatedList = List.from(state)..removeAt(index);
//         emit(updatedList);
//       }
//     } catch (e) {
//       print('خطا در حذف: $e');
//     }
//   }
// }

class MoveBloc extends Bloc<MoveEvent, MoveState> {
  MoveBloc()
      : super(MoveState(selectedIndex: -1, positions: {}, leftPosition: 0.0)) {
    on<MoveEvent>((event, emit) {
      Map<int, double> newPositions = Map.from(state.positions);
      if (state.selectedIndex == event.index) {
        emit(MoveState(
          selectedIndex: -1,
          positions: state.positions,
          leftPosition: 0.0,
        ));
      } else {
        newPositions[event.index] =
        (newPositions[event.index] ?? 0.0) == 0.0 ? -42.0 : 0.0;
        emit(MoveState(
          selectedIndex: event.index,
          positions: newPositions,
          leftPosition: newPositions[event.index] ?? 0.0,
        ));
      }
    });

    on<ResetMoveEvent>((event, emit) {
      emit(MoveState(
        selectedIndex: -1,
        positions: {},
        leftPosition: 0.0,
      ));
    });
  }
}