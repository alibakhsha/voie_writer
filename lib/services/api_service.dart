import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../logic/models/VoiceToText/get_list_voice.dart';
import '../logic/models/user_model/JwtToken.dart';


class ApiService {
  static const String _baseUrl = 'https://caliber24.pythonanywhere.com';
  static const Map<String, String> _headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-CSRFTOKEN': '2WACHb1J9hx8KZgBhkTMktdJ9WONXYBB1uFlB5RVlz58N9TLHVRBphcHiKWA4Kxz',
  };

  Future<Map<String, String>> _getHeadersWithToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print("Token fetched from SharedPreferences: $token"); // برای دیباگ
    if (token != null) {
      return {
        ..._headers,
        'Authorization': 'JWT $token',
      };
    }
    return _headers;
  }

  Future<Map<String, dynamic>?> createUserWithImei(String imei) async {
    final url = Uri.parse('$_baseUrl/auth/users/');
    final body = jsonEncode({'imei': imei});

    try {
      final response = await http.post(url, headers: _headers, body: body);
      print("Create user - API status code: ${response.statusCode}");
      print("Create user - API response body: ${response.body}");
      if (response.statusCode == 201) {
        print('کاربر ثبت شد: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('خطا در ثبت کاربر: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('مشکل ارتباط در ثبت کاربر: $e');
      return null;
    }
  }

  Future<JwtToken?> registerIMEI(String imei) async {
    final url = Uri.parse('$_baseUrl/auth/jwt/create/');
    final body = jsonEncode({'imei': imei});

    try {
      final response = await http.post(url, headers: _headers, body: body);
      print("Auth - API status code: ${response.statusCode}");
      print("Auth - API response body: ${response.body}");
      if (response.statusCode == 200) {
        print('احراز هویت شد: ${response.body}');
        return JwtToken.fromJson(jsonDecode(response.body));
      } else {
        print('خطا در احراز هویت: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('مشکل ارتباط در احراز هویت: $e');
      return null;
    }
  }

  Future<List<GetListVoice>?> getVoiceToText() async {
    final url = Uri.parse('$_baseUrl/voice-to-text/');
    final headers = await _getHeadersWithToken();
    print("Headers being sent: $headers"); // برای دیباگ

    try {
      final response = await http.get(url, headers: headers);
      print("VTT - API status code: ${response.statusCode}");
      print("VTT - API response body: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => GetListVoice.fromJson(json)).toList();
      } else {
        print('خطا در گرفتن داده‌ها: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('مشکل ارتباط در گرفتن داده‌ها: $e');
      return null;
    }
  }
}