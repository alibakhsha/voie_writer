import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voie_writer/constant/api_constant.dart';
import 'package:voie_writer/logic/cubit/voice/voice_cubit.dart';
import '../models/JwtToken.dart';
import '../models/voice_to_text_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      headers: ApiConstant.headers,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ),
  );

  /// دریافت Device ID برای هر گوشی
  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android Device ID
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // iOS Device ID
    }
    return throw Exception("Unsupported platform");
  }

  Future<bool> check_user(String deviceId) async {
    try {
      var acc_tkn = await get_access_token();
      if (acc_tkn == null) {
        await createUserWithDeviceId(deviceId);
      }
    } catch (e) {
      print("\x1B[31m check_user : token dar db vojod nadarad \x1B[0m");
      // await createUserWithDeviceId(deviceId);
    }
    return true;
  }

  Future<Map<String, dynamic>?> createUserWithDeviceId(String deviceId) async {
    try {

      final response = await _dio.post(
        '/auth/users/',
        options: Options(headers: ApiConstant.headers),
        data: {'imei': deviceId},
      );

      // if (response.statusCode == 201) {
      //   print('karbar sabtshod ${response.data}');
      //   // return response.data as Map<String, dynamic>;
      // }
    } catch (e) {
      print("\x1B[31m createUserWithDeviceId : user vojod darad \x1B[0m");
    }
    await registerDeviceId(deviceId);
    return null;
  }

  /// دریافت و ذخیره توکن از سرور با استفاده از Device ID
  Future<JwtToken?> registerDeviceId(String deviceId) async {
    try {
      final response = await _dio.post(
        '/auth/jwt/create/',
        options: Options(headers: ApiConstant.headers),
        data: {'imei': deviceId},
      );
      if (response.statusCode == 200) {
        var acc_tkn = await get_access_token();
        if (acc_tkn == null) {
          await _saveTokens(response.data['access'], response.data['refresh']);
        }
      }
    } catch (e) {
      return null;
    }
      return null;
  }

  Future<String?> get_access_token() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    return accessToken;
  }

  /// ارسال درخواست‌های محافظت‌شده
  Future<Map<String, String>> getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      try {
        JwtToken? token = await registerDeviceId('test1');
        if (token == null) {
          return ApiConstant.headers;
        }

        accessToken = token.access;
        await prefs.setString('access_token', token.access);
        await prefs.setString('refresh_token', token.refresh);
      } catch (e) {
        return ApiConstant.headers;
      }
    }

    return {...ApiConstant.headers, 'Authorization': 'JWT $accessToken'};
  }

  /// دریافت لیست تبدیل‌های صوت به متن
  Future<List<VoiceToTextModel>> fetchVoiceToText() async {
    try {
      Map<String, String> headers = await getAuthHeaders();
      DateTime now = DateTime.now();
      final timestampMillis = now.millisecondsSinceEpoch;
      final unixTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      Response response = await _dio.get(
          '/voice-to-text/',
          options: Options(headers: headers),
          queryParameters: {'timestamp': unixTimestamp}
      );
      if (response.statusCode == 200) {
        if (response.data is List) {
          List<dynamic> data = response.data;
          return data.map((item) => VoiceToTextModel.fromJson(item)).toList();
        } else {
          return List.empty(growable: true);
        }
      }
      return List.empty(growable: true);
    } catch (e) {
      return List.empty(growable: true);
    }
  }

  /// ارسال فایل صوتی و دریافت متن تبدیل‌شده
  Future<VoiceToTextModel?> uploadVoiceToText(String audioPath, String? title) async {
    try {
      final headers = await getAuthHeaders();

      FormData formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          audioPath!,
          filename: audioPath!.split('/').last,
        ),
        'title': title,
      });

      Response response = await _dio.post(
        '/voice-to-text/',
        data: formData,
        options: Options(headers: headers),

        onSendProgress: (int sent, int total) {
        },
      );
      if (response.statusCode == 201) {
        return VoiceToTextModel.fromJson(response.data);
      }
      return null;
    } catch (e) {

      return null;
    }
  }


  /// حذف یک تبدیل صوت به متن
  Future<bool> deleteVoiceText(String id) async {
    try {
      final headers = await getAuthHeaders();
      final response = await _dio.delete(
        '/voice-to-text/$id/',
        options: Options(headers: headers),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// تمدید توکن در صورت انقضا
  Future<bool> _refreshToken() async {
    String? refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    try {
      Response response = await _dio.post(
        '/auth/jwt/refresh/',
        data: {"refresh": refreshToken},
      );
      if (response.statusCode == 200) {
        String newAccessToken = response.data['access'];
        await _saveTokens(newAccessToken, refreshToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// ذخیره توکن‌ها در حافظه
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  /// دریافت `access_token`
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  /// دریافت `refresh_token`
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }
}
