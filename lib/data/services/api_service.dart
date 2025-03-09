import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voie_writer/constant/api_constant.dart';
import '../models/voice_to_text_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstant.baseUrl,
    connectTimeout: const Duration(milliseconds: 10000),
    receiveTimeout: const Duration(milliseconds: 10000),
  ));

  /// دریافت Device ID برای هر گوشی
  Future<String?> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android Device ID
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // iOS Device ID
    }
    return null;
  }

  /// دریافت و ذخیره توکن از سرور با استفاده از Device ID
  Future<bool> fetchTokens() async {
    try {
      String? deviceId = await _getDeviceId();
      if (deviceId == null) {
        print('خطا در دریافت Device ID ❌');
        return false;
      }

      Response response = await _dio.post('/auth/jwt/create/', data: {"imei": deviceId});

      if (response.statusCode == 200) {
        String accessToken = response.data['access'];
        String refreshToken = response.data['refresh'];
        await _saveTokens(accessToken, refreshToken);
        return true;
      }
      return false;
    } catch (e) {
      print('Error fetching tokens: $e');
      return false;
    }
  }

  /// ارسال درخواست‌های محافظت‌شده
  Future<Response> _authorizedRequest(Future<Response> Function() request) async {
    String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      print('Access Token not found! Fetching new token...');
      bool tokenFetched = await fetchTokens();
      if (!tokenFetched) {
        return Response(requestOptions: RequestOptions(path: ''), statusCode: 401);
      }
      accessToken = await _getAccessToken();
    }

    try {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
      Response response = await request();
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        bool refreshed = await _refreshToken();
        if (refreshed) {
          _dio.options.headers['Authorization'] = 'Bearer ${await _getAccessToken()}';
          return request(); // اجرای مجدد درخواست
        }
      }
      rethrow;
    }
  }

  /// دریافت لیست تبدیل‌های صوت به متن
  Future<List<VoiceToTextModel>?> fetchVoiceToText() async {
    try {
      Response response = await _authorizedRequest(() => _dio.get('/voice-to-text/'));
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((item) => VoiceToTextModel.fromJson(item)).toList();
      }
      return null;
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  /// ارسال فایل صوتی و دریافت متن تبدیل‌شده
  Future<VoiceToTextModel?> uploadVoiceToText(String filePath) async {
    try {
      String fileExtension = filePath.split('.').last;
      FormData formData = FormData.fromMap({
        "audio": await MultipartFile.fromFile(
          filePath,
          filename: "audio.$fileExtension",
          contentType: MediaType("audio", fileExtension),
        ),
      });

      Response response = await _authorizedRequest(() => _dio.post('/voice-to-text/', data: formData));

      if (response.statusCode == 201) {
        return VoiceToTextModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  /// حذف یک تبدیل صوت به متن
  Future<bool> deleteVoiceText(String id) async {
    try {
      Response response = await _authorizedRequest(() => _dio.delete('/voice-to-text/$id/'));
      return response.statusCode == 204;
    } catch (e) {
      print('Error deleting data: $e');
      return false;
    }
  }

  /// تمدید توکن در صورت انقضا
  Future<bool> _refreshToken() async {
    String? refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    try {
      Response response = await _dio.post('/auth/jwt/refresh/', data: {"refresh": refreshToken});
      if (response.statusCode == 200) {
        String newAccessToken = response.data['access'];
        await _saveTokens(newAccessToken, refreshToken);
        return true;
      }
      return false;
    } catch (e) {
      print('Token refresh failed: $e');
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
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  /// دریافت `refresh_token`
  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }
}
