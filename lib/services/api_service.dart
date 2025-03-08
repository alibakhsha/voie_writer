import 'package:shared_preferences/shared_preferences.dart';
import '../logic/models/VoiceToText/get_list_voice.dart';
import '../logic/models/user_model/JwtToken.dart';
import 'package:dio/dio.dart';

class ApiService {
  static const String _baseUrl = 'https://caliber24.pythonanywhere.com';
  static const Map<String, String> _headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-CSRFTOKEN':
        '2WACHb1J9hx8KZgBhkTMktdJ9WONXYBB1uFlB5RVlz58N9TLHVRBphcHiKWA4Kxz',
  };
  final Dio _dio;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          headers: _headers,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  Future<Map<String, dynamic>?> createUserWithImei(String imei) async {
    try {
      final response = await _dio.post(
        '/auth/users/',
        options: Options(headers: _headers),
        data: {'imei': imei},
      );
      //
      // print("Create user - API status code: ${response.statusCode}");
      // print("Create user - API response body: ${response.data}");
      if (response.statusCode == 201) {
        // print('کاربر ثبت شد: ${response.data}');
        return response.data as Map<String, dynamic>;
      } else {
        // print('خطا در ثبت کاربر: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('مشکل ارتباط در ثبت کاربر: $e');
      return null;
    }
  }

  Future<JwtToken?> registerIMEI(String imei) async {
    try {
    final response = await _dio.post(
      '/auth/jwt/create/',
      options: Options(headers: _headers),
      data: {'imei': imei},
    );
    // print("Auth - API status code: ${response.statusCode}");
    // print("Auth - API response body: ${response.data}");
    if (response.statusCode == 200) {
      // print('احراز هویت شد: ${response.data}');
      return JwtToken.fromJson(response.data);
    } else {
      // print('خطا در احراز هویت: ${response.statusCode}');
      return null;
    }
  } catch (e) {
  // print('مشکل ارتباط در احراز هویت: $e');
  return null;
  }
}

  Future<Map<String, String>> _getHeadersWithToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print("Token fetched from SharedPreferences: $token");
    if (token != null) {
      return {..._headers, 'Authorization': 'JWT $token'};
    }
    return _headers;
  }

  Future <List<GetListVoice>?>getVoiceToText() async {
    try{
      final headers = await _getHeadersWithToken();
      final response = await _dio.get(
        "/voice-to-text/",
        options:await Options (headers: headers)
      );
      // print("VTT - API status code: ${response.statusCode}");
      // print("VTT - API response body: ${response.data}");
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => GetListVoice.fromJson(json)).toList();
      } else {
        // print('خطا در گرفتن داده‌ها: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('مشکل ارتباط در گرفتن داده‌ها: $e');
      return null;
    }
  }
  Future<bool> deleteVoice(String id) async {
    try{
      final headers= await _getHeadersWithToken();
      final response=await _dio.delete(
        '/voice-to-text/$id/',
        options: Options(headers: headers),

      );
      if (response.statusCode ==200 || response.statusCode==204) {
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }

  }


}
