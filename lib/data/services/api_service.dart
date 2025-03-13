import 'dart:convert';
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
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
    ),
  );

  /// دریافت Device ID برای هر گوشی
  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print("levele1: ${androidInfo.id}");
      return androidInfo.id; // Android Device ID
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print("levele2: ${iosInfo.identifierForVendor}");
      return iosInfo.identifierForVendor; // iOS Device ID
    }
    return throw Exception("Unsupported platform");
  }

  Future<bool> check_user(String deviceId) async {
    try {
      // String ss = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzczMzE1NzUxLCJpYXQiOjE3NDE3Nzk3NTEsImp0aSI6ImViMzFkMjcxNTcyYTRjZjI5NzNlZGY1YjhlYjYwZWMzIiwidXNlcl9pZCI6Mn0.Z6Ir3RVN5rVxlFxP26SezLgSxyV4gkIgEoC_-z1R6bw'
      // ;await _saveTokens(ss, ss);

      // Map<String, String> headerss = await getAuthHeaders();

      // final sss = await _dio.delete(
      //   '/auth/users/$deviceId/',
      //   options: Options(headers: headerss),
      // );

      var acc_tkn = await get_access_token();
      if (acc_tkn == null) {
        await createUserWithDeviceId(deviceId);
      } else {
        Map<String, String> headers = await getAuthHeaders();

        final response = await _dio.get(
          '/auth/users/',
          options: Options(headers: headers),
        );

        print('omad');
        return false;
      }
    } catch (e) {
      print("\x1B[31m check_user : token dar db vojod nadarad \x1B[0m");
      await createUserWithDeviceId(deviceId);
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
      //
      print("Create user - API status code: ${response.statusCode}");
      print("Create user - API response body: ${response.data}");
      if (response.statusCode == 201) {
        print('karbar sabtshod ${response.data}');
        return response.data as Map<String, dynamic>;
      } else if (response.statusCode == 400) {
        print('dade nadoroste: ${response.data}');
        return null;
      } else if (response.statusCode == 409) {
        print('karbar qablan sabt shode: ${response.data}');
        return null;
      } else {
        print('khata dar sabte karbar: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print("\x1B[31m createUserWithDeviceId : user vojod darad \x1B[0m");
    }
  }

  /// دریافت و ذخیره توکن از سرور با استفاده از Device ID
  Future<JwtToken?> registerDeviceId(String deviceId) async {
    try {
      // String? deviceId = await  getDeviceId();
      final response = await _dio.post(
        '/auth/jwt/create/',
        options: Options(headers: ApiConstant.headers),
        data: {'imei': deviceId},
      );
      print("Auth - API status code: ${response.statusCode}");
      print("Auth - API response body: ${response.data}");
      if (response.statusCode == 200) {
        print('ehraze hoviat shod: ${response.data}');
        var acc_tkn = await get_access_token();
        if (acc_tkn == null) {
          await _saveTokens(response.data['access'], response.data['refresh']);
        }

        // var gg =response.data['refresh'];
        // return JwtToken.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print('dastrasi qeye mojaz: ${response.data}');
        return null;
      } else {
        print('khata dar ehraz hoviat: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('moshkel dar ehraze hiviat: $e');
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
      print('No access token found, registering device...');
      try {
        JwtToken? token = await registerDeviceId('test1');
        if (token == null) {
          print('Failed to register device and fetch tokens');
          return ApiConstant.headers;
        }

        accessToken = token.access;
        await prefs.setString('access_token', token.access);
        await prefs.setString('refresh_token', token.refresh);
        print('Tokens fetched and saved successfully ✅');
      } catch (e) {
        print('Error registering device: $e');

        return ApiConstant.headers;
      }
    }

    print("Token fetched from SharedPreferences: $accessToken");
    return {...ApiConstant.headers, 'Authorization': 'JWT $accessToken'};
  }

  /// دریافت لیست تبدیل‌های صوت به متن
  Future<List<VoiceToTextModel>?> fetchVoiceToText() async {
    try {
      Map<String, String> headers = await getAuthHeaders();
      DateTime now = DateTime.now();
      int timestampMillis = now.millisecondsSinceEpoch;
      Response response = await _dio.get(
        '/voice-to-text/',
        options: Options(headers: headers),
        data: {'Timestamp': 0},
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          List<dynamic> data = response.data;
          return data.map((item) => VoiceToTextModel.fromJson(item)).toList();
        } else {
          print('Error: Expected a list but got ${response.data.runtimeType}');
          return null;
        }
      }
      print('Error: Status code ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error fetching voice-to-text data: $e');
      return null;
    }
  }

  /// ارسال فایل صوتی و دریافت متن تبدیل‌شده
  Future<VoiceToTextModel?> uploadVoiceToText(String audioPath) async {
    try {
      final headers = await getAuthHeaders();




      FormData formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          audioPath!,
          filename: audioPath!.split('/').last,
        ),
        'title': 'test',
      });

      Response response = await _dio.post(
        '/voice-to-text/',
        data: formData,
        options: Options(headers: headers),

        onSendProgress: (int sent, int total) {
          print("darhale ersal: ${(sent / total * 100).toStringAsFixed(0)}%");
        },
      );
      if (response.statusCode == 201) {
        return VoiceToTextModel.fromJson(response.data);
        print('موفقیت: ${response.data}');
      }
      print(
        'pasokhe qeyre montazere: ${response.statusCode} - ${response.data}',
      );
      return null;
    } catch (e) {

      print('khta dar ersal be server: $e');
      return null;
    }
  }

  // Future<VoiceToTextModel?> uploadVoiceToText(String filePath) async {
  //   try {
  //     Map<String, String> headers = await getAuthHeaders();
  //     String fileExtension = filePath.split('.').last;
  //     FormData formData = FormData.fromMap({
  //       "audio": await MultipartFile.fromFile(
  //         filePath,
  //         filename: "audio.$fileExtension",
  //         contentType: MediaType("audio", fileExtension),
  //       ),
  //     });
  //
  //     Response response = await _dio.post(
  //       '/voice-to-text/',
  //       options: Options(headers: headers),
  //       data: formData,
  //     );
  //
  //     if (response.statusCode == 201) {
  //       return VoiceToTextModel.fromJson(response.data);
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error uploading file: $e');
  //     return null;
  //   }
  // }

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
    String? refreshToken = await _getRefreshToken();
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
