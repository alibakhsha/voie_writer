
import 'package:voie_writer/services/api_service.dart';
import 'models/user_model/JwtToken.dart';


class DeviceRegistration {
  final ApiService _apiService;

  DeviceRegistration(this._apiService);


  Future<Map<String, dynamic>?> createUser(String deviceId) async {
    try {
      print("Sending create user request with deviceId: $deviceId");
      final result = await _apiService.createUserWithImei(deviceId);
      print("Create user response: $result");
      return result;
    } catch (e) {
      print('خطا در ثبت کاربر: $e');
      return null;
    }
  }


  Future<JwtToken?> authenticateDevice(String deviceId) async {
    try {
      print("Sending auth request with deviceId: $deviceId");
      final result = await _apiService.registerIMEI(deviceId);
      print("Auth response: $result");
      return result;
    } catch (e) {
      print('خطا در احراز هویت: $e');
      return null;
    }
  }
}